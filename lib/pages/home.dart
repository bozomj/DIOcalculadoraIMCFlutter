import 'dart:developer';

import 'package:calculadora_imc/model/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:calculadora_imc/pages/lista_page.dart';
import 'package:calculadora_imc/pages/my_form.dart';
import 'package:calculadora_imc/utils/mynavigator.dart' show navigatorPush;

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Pessoa> pessoas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora IMC")),
      body: ListaPage(
        pessoas: pessoas,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Pessoa? pessoa =
              await navigatorPush(context: context, page: const MyForm());
          if (pessoa != null) pessoas.add(pessoa);
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
