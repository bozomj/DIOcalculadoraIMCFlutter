import 'package:calculadora_imc/database/database_sqflite.dart';
import 'package:calculadora_imc/database/shared_db.dart';
import 'package:sqflite/sqflite.dart';

class Pessoa {
  String _nome;
  String? _classificacaoIMC;
  double _altura;
  double _peso;
  double? _imc;

  Pessoa({
    required String nome,
    required double altura,
    required double peso,
    double? imc,
    String? classificacaoIMC,
  })  : _nome = nome,
        _altura = altura,
        _peso = peso,
        _imc = imc,
        _classificacaoIMC = classificacaoIMC;

  String get nome => _nome;
  double get altura => _altura;
  double get peso => _peso;
  double? get imc => _imc;
  String? get classificacao => _classificacaoIMC;

  set peso(p) => _peso = p;
  set nome(nome) => _nome = nome;
  set altura(altura) => _altura = altura;

  get calculoMap => {
        "data": DateTime.now().millisecondsSinceEpoch,
        "imc": imc,
        "peso": peso,
        "classificacao": classificacao
      };

  calcularIMC() {
    _imc = _peso / (_altura * _altura);
  }

  salvar() async {
    SharedDB? db = SharedDB();

    await db.salvar(this);
  }

  Future salvarCalculo() async {
    Database? db = await DatabaseSqFlite().db;

    try {
      return await db!.insert('calculos_imc', calculoMap);
    } catch (e) {
      throw Exception('Erro ao salvar calculo IMC: $e');
    }
  }

  Future<List<Map>> getAllCalculos() async {
    Database? db = await DatabaseSqFlite().db;

    try {
      return await db!.query('calculos_imc', orderBy: 'data');
    } catch (e) {
      throw Exception("Erro ao buscar calculos: $e");
    }
  }

  classificarIMC() {
    if (imc == null) {
      return "";
    }

    String classificacao = "";
    switch (imc!) {
      case < 16:
        classificacao = "Magreza grave";
        break;
      case (>= 16 && < 17):
        classificacao = "Magreza moderada";
        break;
      case (>= 17 && < 18.5):
        classificacao = "Magreza leve";
        break;
      case (>= 18.5 && < 25):
        classificacao = "Saudável";
        break;
      case (>= 25 && < 30):
        classificacao = "Sobrepeso";
        break;
      case (>= 30 && < 35):
        classificacao = "Obesidade Grau I";
        break;
      case (>= 35 && < 40):
        classificacao = "Obesidade Grau II";
        break;
      default:
        classificacao = "Obesidade Grau III";
        break;
    }
    _classificacaoIMC = classificacao;

    return classificacao;
  }
}
