import 'package:flutter/material.dart';
import 'package:flutter_projeto/ui/pages/controllers/home_page_controller.dart';

import '../../common/config/dependencies.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{

  late HomePageController viewController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isEditing = false;

@override
void initState() {
  super.initState();
  viewController = injector.get<HomePageController>();
  viewController.load.execute();

  _animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  _scaleAnimation = Tween<double>(
    begin: 1.0,
    end: 0.9,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
    ));
}

@override
void dispose(){
  _animationController.dispose();
  super.dispose();
}

void _toggleEditMode() {
  setState(() {
    _isEditing = !_isEditing;
    if (_isEditing){
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  });
}

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
        'Cartão do Estudante',
        style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {},
            tooltip: 'Editar Informações',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {},
            tooltip: 'Resetar Informações',
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -80,
            right: -70,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            bottom: -70,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}