import 'dart:async';

import 'package:flutter/foundation.dart';

import 'result.dart';

/// Função assíncrona que representa uma ação sem argumentos,
/// retornando um [Result] com tipos genéricos TOk e TError.
typedef CommandAction0<Success, Error> = Future<Result<Success, Error>>
    Function();

/// Função assíncrona que representa uma ação com um argumento do tipo A,
/// retornando um [Result] com tipos genéricos TOk e TError.
typedef CommandAction1<Success, Error, A> = Future<Result<Success, Error>>
    Function(A);

/// Classe base abstrata que encapsula a execução de uma ação e gerencia seu estado.
/// Usa [ChangeNotifier] para permitir que a interface reaja a mudanças de estado.
abstract class Command<Success, Error> extends ChangeNotifier {
  Command();

  // Indica se a ação está sendo executada no momento.
  bool _running = false;
  bool get running => _running;

  // Armazena o resultado da execução da ação.
  Result<Success, Error>? _result;

  // Retorna true se o resultado for um erro.
  bool get error => _result is Error;

  // Retorna true se o resultado for um sucesso.
  bool get completed => _result is Success;

  // Permite acesso ao último resultado.
  Result<Success, Error>? get result => _result;

  // Limpa o resultado atual e notifica ouvintes.
  void clearResult() {
    _result = null;
    notifyListeners();
  }

  // Método interno que executa a ação e atualiza o estado (_running, _result).
  Future<void> _execute(
      Future<Result<Success, Error>> Function() action) async {
    // evita que a ação seja executada duas vezes
    if (_running) return;

    _running = true;
    _result = null;
    notifyListeners();

    _result = await action();

    _running = false;
    notifyListeners();
  }
}

/// Classe concreta que representa um comando sem argumentos.
/// Exemplo: carregar uma lista de itens.
class Command0<Success, Error> extends Command<Success, Error> {
  Command0(this._action);

  final CommandAction0<Success, Error> _action;

  // Executa a ação associada.
  Future<void> execute() async {
    await _execute(_action);
  }
}

/// Classe concreta que representa um comando com um argumento do tipo A.
/// Exemplo: buscar um item pelo ID.
class Command1<Success, Error, A> extends Command<Success, Error> {
  Command1(this._action);

  final CommandAction1<Success, Error, A> _action;

  // Executa a ação passando o argumento necessário.
  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}
