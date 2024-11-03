import 'package:calculadora_imc/database/database_sqflite.dart';
import 'package:sqflite/sqflite.dart';

class Calculo {
  int? id;
  String? classificacao;
  final String data;
  final double imc;
  final double peso;

  Calculo({
    this.id,
    required this.data,
    required this.imc,
    required this.peso,
    this.classificacao,
  });

  static fromMap(Map map) {
    return Calculo(
        id: map['id'],
        data: map['data'],
        imc: map['imc'],
        peso: map['peso'],
        classificacao: map['classificacao']);
  }

  get map => {
        "data": data,
        "imc": imc,
        "peso": peso,
        "classificacao": classificacao,
      };

  excluir() async {
    Database? db = await DatabaseSqFlite().db;

    db!.delete('calculos_imc', where: "id = $id");
  }
}
