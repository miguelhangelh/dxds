class CountryRegister {
  String id;
  String name;
  String image;
  CountryRegister(this.id, this.name, this.image);

  static List<CountryRegister> getCountries() {
    return <CountryRegister>[
      CountryRegister('BO', '+591', 'bo.png'),
      // CountryRegister('CH', 'Chuquisaca'),
      // CountryRegister('LP', 'La Paz'),
      // CountryRegister('CB', 'Cochabamba'),
      // CountryRegister('OR', 'Oruro'),
      // CountryRegister('PT', 'Potosí'),
      // CountryRegister('TJ', 'Tarija'),
      // CountryRegister('BE', 'Beni'),
      // CountryRegister('PD', 'Pando'),
    ];
  }
}
