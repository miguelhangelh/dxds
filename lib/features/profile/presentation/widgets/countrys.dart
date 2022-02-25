class Country {
  String id;
  String name;

  Country(this.id, this.name);

  static List<Country> getCountries() {
    return <Country>[
      Country('1', 'Bolivia'),
      Country('CH', 'Brasil'),
      Country('LP', 'Paraguay'),
      Country('CB', 'Perú'),
      Country('OR', 'Chile'),
    ];
  }
}
