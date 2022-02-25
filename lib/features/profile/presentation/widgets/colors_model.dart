import 'package:flutter/material.dart';

class ColorsModel {
  final int id;
  final String name;
  final Color color;

  ColorsModel(
    this.id,
    this.name,
      this.color,
  );
   static List<ColorsModel> getColors() {
    return <ColorsModel>[
      ColorsModel(1, 'Blanco', Colors.white),
      ColorsModel(2, 'Rojo', Colors.red),
      ColorsModel(3, 'Amarillo', Colors.yellow),
      ColorsModel(4, 'Verde', Colors.green),
      ColorsModel(5, 'Negro', Colors.black),
      ColorsModel(6, 'Azul', Colors.blue),
      ColorsModel(7, 'Celeste', Colors.cyan),
      ColorsModel(8, 'Morado', Colors.purple),
      ColorsModel(9, 'Plomo', Colors.grey),
      ColorsModel(10, 'Cafe', Colors.brown),
      ColorsModel(11, 'Naranja', Colors.orange),
    ];
  }
}