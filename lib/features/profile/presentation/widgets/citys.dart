class Departments {
  String id;
  String name;

  Departments(this.id, this.name);

  static List<Departments> getDepartments() {
    return <Departments>[
      Departments('SC', 'Santa Cruz de la sierra'),
      Departments('CH', 'Andrés Ibáñez'),
      Departments('LP', 'Ángel Sandóval'),
      Departments('CB', 'Germán Busch'),
      Departments('OR', 'Oruro'),
      Departments('PT', 'Potosí'),
      Departments('TJ', 'Tarija'),
      Departments('BE', 'Beni'),
      Departments('PD', 'Pando'),
    ];
  }
}
