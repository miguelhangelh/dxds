class Departments {
  String id;
  String name;

  Departments(this.id, this.name);

  static List<Departments> getDepartments() {
    return <Departments>[
      Departments('SC', 'Santa Cruz'),
      Departments('CH', 'Chuquisaca'),
      Departments('LP', 'La Paz'),
      Departments('CB', 'Cochabamba'),
      Departments('OR', 'Oruro'),
      Departments('PT', 'Potosí'),
      Departments('TJ', 'Tarija'),
      Departments('BE', 'Beni'),
      Departments('PD', 'Pando'),
    ];
  }
}
