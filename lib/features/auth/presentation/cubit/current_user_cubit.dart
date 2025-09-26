import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/user.dart';

@injectable
class CurrentUserCubit extends Cubit<UserModel?> {
  CurrentUserCubit() : super(null);

  void setCurrentUser(UserModel user) => emit(user);
}
