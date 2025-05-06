import 'package:auto_injector/auto_injector.dart';

import '../../date/services/fake_db_service.dart';
import '../../date/services/local_storage_contract.dart';
import '../../date/services/repository/student_repository_contract.dart';
import '../../date/services/repository/student_repository_impl.dart';
import '../../ui/pages/controllers/home_page_controller.dart';

final injector = AutoInjector();

void seputDependencies() {
  injector.addSingleton<StudentRepositoryContract>(StudentRepositoryImpl.new);

  injector.addSingleton<LocalStorageContract>(FakeDbService.new);
  injector.addSingleton(HomePageController.new);
  injector.commit();
}