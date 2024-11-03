//enum para cores de classificacao imc
import 'package:flutter/material.dart';

enum ClassificacaoIMC {
  magrezaGrave,
  magrezaModerada,
  magrezaLeve,
  pesoNormal,
  sobrepeso,
  obesidadeGrau1,
  obesidadeGrau2,
  obesidadeGrau3,
}

Map<String, dynamic> colorIMC = {
  "Magreza grave": Colors.blue[100],
  "Magreza moderada": Colors.blue[300],
  "Magreza leve": Colors.blue[900],
  "Saudável": Colors.green[700],
  "Sobrepeso": Colors.yellow,
  "Obesidade Grau I": Colors.amber[300],
  "Obesidade Grau II": Colors.amber[700],
  "Obesidade Grau III": Colors.amber[900],
};

// funcao recebe uma datetime e retorna data do brasil por extenso
String formatarData(String txt) {
  int? datetime = int.tryParse(txt);
  var data = DateTime.fromMillisecondsSinceEpoch(datetime ?? 0);
  final diasDaSemana = [
    'domingo',
    'segunda-feira',
    'terça-feira',
    'quarta-feira',
    'quinta-feira',
    'sexta-feira',
    'sábado'
  ];
  final meses = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro'
  ];

  return '${diasDaSemana[data.weekday - 1]} ${data.day} de ${meses[data.month - 1]} de ${data.year}';
}
