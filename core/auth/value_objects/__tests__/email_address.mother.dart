import '../email_address.value_object.dart';

class EmailAddressMother {
  static EmailAddress valid() => EmailAddress.create('user@example.com');
}
