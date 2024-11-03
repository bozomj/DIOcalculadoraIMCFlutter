import 'dart:developer';

import 'package:calculadora_imc/components/drawer_imc.dart';
import 'package:calculadora_imc/database/shared_db.dart';
import 'package:calculadora_imc/model/calculo.dart';
import 'package:calculadora_imc/model/pessoa.dart';
import 'package:calculadora_imc/pages/configuracoes.dart';
import 'package:calculadora_imc/pages/lista_calculos_page.dart';
import 'package:calculadora_imc/utils/mynavigator.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Calculo> calculos = [];
  Pessoa? pessoa;
  TextEditingController pesoController = TextEditingController();

  @override
  void initState() {
    getUser();
    getCalculos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text("Calculadora IMC")),
        drawer: const DrawerImc(),
        body: ListaCalculosPage(
          calculos: calculos,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            pesoController.clear();
            (pessoa == null && context.mounted)
                ? await navigatorPush(
                    context: context, page: const Configuracoes())
                : showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Calcular IMC"),
                        content: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: pesoController,
                          decoration: const InputDecoration(
                            label: Text('Peso'),
                            suffix: Text('Kg'),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                              onPressed: () async =>
                                  await _salvarConsulta(context),
                              child: const Text("Salvar")),
                        ],
                      );
                    },
                  );
            getUser();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future<bool> getUser() async {
    bool rt = false;
    try {
      pessoa = await Pessoa.getSharedPreference();
      rt = true;
    } catch (e) {
      log(e.toString());
    }
    setState(() {});
    return rt;
  }

  Future getCalculos() async {
    if (pessoa == null) return;
    List<Map> list = await pessoa!.getAllCalculos();
    calculos.clear();
    for (Map calculo in list) {
      log(calculo.toString());
      calculos.add(Calculo.fromMap(calculo));
    }

    setState(() {});
  }

  cheUser() async {
    if (pessoa == null) {
      return await navigatorPush(context: context, page: const Configuracoes());
    }

    return true;
  }

  Future<void> _salvarConsulta(context) async {
    double? peso = double.tryParse(pesoController.text);
    if (peso != null) pessoa!.peso = peso;

    try {
      pessoa!.calcularIMC();
      pessoa!.classificarIMC();
      pessoa!.salvar();
      await pessoa!.salvarCalculo();
      await getCalculos();
      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      log("ERROR: $e");
    }
  }
}
