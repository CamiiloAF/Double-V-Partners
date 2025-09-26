import '../../domain/model/address.dart';

class AddressPageParams {
  final List<AddressModel> initialAddresses;
  final String title;

  AddressPageParams({required this.initialAddresses, required this.title});
}
