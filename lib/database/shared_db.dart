import 'dart:developer';

import 'package:calculadora_imc/model/pessoa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedDB {
  SharedPreferences? _db;

  Future<SharedPreferences?> get db async {
    return _db ??= await SharedPreferences.getInstance();
  }

  SharedDB();

  Future<void> salvar(Pessoa pessoa) async {
    var database = await db;
    try {
      database!.setString("nome", pessoa.nome);
      database.setDouble("altura", pessoa.altura);
      database.setDouble("peso", pessoa.peso);
    } catch (e) {
      throw "Erro ao salvar Pessoa: $e";
    }
  }

  Future<Pessoa?> getUser() async {
    var database = await db;

    String? nome;
    double? altura;
    double? peso;

    try {
      nome = database!.getString("nome");
      altura = database.getDouble("altura");
      peso = database.getDouble("peso");
    } catch (e) {
      throw "Erro ao buscar Pessoa: $e";
    }

    return (nome == null || altura == null || peso == null)
        ? null
        : Pessoa(
            nome: nome,
            altura: altura,
            peso: peso,
          );
  }
}
