import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/model/user.dart';

@injectable
class CurrentUserCubit extends Cubit<UserModel?> {
  CurrentUserCubit() : super(null);

  void setCurrentUser(UserModel user) => emit(user);
}
