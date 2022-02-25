
import 'package:appdriver/features/profile/domain/entities/address_entity.dart';

class AddressModel extends AddresstEntity {

    AddressModel( {
      String? country,
      String? city,
      String? states,
      String? street,
      String? postalCode,
    } ) : super(
      country: country,
      city: city,
      states: states,
      street: street,
      postalCode: postalCode
    );

    AddressModel copyWith({
      String? country,
      String? city,
      String? states,
      String? street,
      String? postalCode,
    }) {
      return AddressModel(
        country    : country ?? this.country,
        city       : city ?? this.city,
        states     : states ?? this.states,
        street     : states ?? this.street,
        postalCode : states ?? this.postalCode,
      );
    }

    factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        country    : json.containsKey( 'country' )    ? json["country"] : '',
        city       : json.containsKey( 'city' )       ? json["city"] : '',
        states     : json.containsKey( 'states' )     ? json["states"] : '',
        street     : json.containsKey( 'street' )     ? json["street"] : '',
        postalCode : json.containsKey( 'postalCode' ) ? json["postalCode"] : '',
    );

    Map<String, dynamic> toJson() => {
        "country"    : country,
        "city"       : city,
        "states"     : states,
        "street"     : street,
        "postalCode" : postalCode,
    };
}