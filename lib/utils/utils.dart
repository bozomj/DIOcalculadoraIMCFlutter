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
