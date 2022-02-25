class Features {
  final String id;
  final String name;

  Features(
    this.id,
    this.name,
  );
   static List<Features> getFeatures() {
    return <Features>[
      Features('1', 'Refrigerado'),
      Features('2', 'No refrigerado'),
      Features('3', 'Grande'),
      Features('4', 'Mediano'),
    ];
  }
}