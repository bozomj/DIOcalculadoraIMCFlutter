import 'dart:developer';

import 'package:calculadora_imc/database/shared_db.dart';
import 'package:calculadora_imc/model/pessoa.dart';
import 'package:flutter/material.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  Pessoa? pessoa;
  TextEditingController nomeController = TextEditingController();

  TextEditingController alturaController = TextEditingController();

  TextEditingController pesoController = TextEditingController();

  Future<void> getUser() async {
    try {
      pessoa = await SharedDB().getUser();

      if (pessoa != null) {
        nomeController.text = pessoa!.nome;
        alturaController.text = pessoa!.altura.toString();
        pesoController.text = pessoa!.peso.toString();
      }

      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  void initState() {
    getUser();

    super.initState();
  }

  String nome = '';
  double altura = 0;
  double peso = 0;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: pessoa != null,
      onPopInvokedWithResult: (didPop, result) {
        if (pessoa == null) {
          showAlertSnackBar('Voce 1 deve Cadastrar uma Pessoa');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("FORMULÁRIO"),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(16)),
              Text(
                "Informe os dados pessoais",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightGreen[900]),
              ),
              ListTile(
                title: TextFormField(
                  validator: _validarNome,
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  validator: _validarAltura,
                  keyboardType: TextInputType.number,
                  controller: alturaController,
                  decoration: const InputDecoration(
                    labelText: "Altura",
                    suffix: Text("Metros"),
                  ),
                ),
              ),
              ListTile(
                title: TextFormField(
                  validator: _validarPeso,
                  keyboardType: TextInputType.number,
                  controller: pesoController,
                  decoration: const InputDecoration(
                    labelText: "Peso",
                    suffix: Text("Kg"),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () async {
                          await getUser();
                          (pessoa == null)
                              ? showAlertSnackBar(
                                  'Voce deve Cadastrar uma Pessoa')
                              : {if (context.mounted) Navigator.pop(context)};
                        },
                        child: const Text("Cancelar")),
                    const VerticalDivider(),
                    ElevatedButton(
                        onPressed: () async {
                          await salvarCalcular();
                          if (pessoa != null && context.mounted) {
                            Navigator.pop(context, pessoa);
                          }
                        },
                        child: const Text("Salvar")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future salvarCalcular() async {
    nome = nomeController.text.trim();
    altura = formateNumber(alturaController.text);
    peso = formateNumber(pesoController.text);

    if (!formKey.currentState!.validate()) {
      showAlertSnackBar("Preencha todos os campos corretamente");
    } else {
      pessoa = Pessoa(nome: nome, altura: altura, peso: peso);
      SharedDB? db = SharedDB();

      try {
        await db.salvar(pessoa!);
        showSuccessSnackBar("Salvo com sucesso");
      } catch (e) {
        log(e.toString());
        showAlertSnackBar("Erro ao salvar");
      }
    }
  }

  calcularIMC(Pessoa pessoa) {
    pessoa.calcularIMC();
    pessoa.classificarIMC();
  }

  String? _validarNome(String? nome) {
    nome = (nome ?? "").trim();
    if (nome.isEmpty) {
      return "Informe um nome";
    }
    return null;
  }

  String? _validarAltura(String? alt) {
    double altura = formateNumber(alt ?? "");

    if (altura == 0 || altura > 3) {
      return "Informe uma altura válida ex: 1,60";
    }
    return null;
  }

  String? _validarPeso(String? ppeso) {
    double peso = formateNumber(ppeso ?? "");

    if (peso == 0) {
      return "Informe um peso Válido";
    }
    return null;
  }

  showAlertSnackBar(String msg, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: color ??= Colors.amber[900],
    ));
  }

  showSuccessSnackBar(String msg) {
    showAlertSnackBar(msg, color: Colors.green);
  }

  double formateNumber(String? texto) {
    texto = (texto ?? "").replaceAll(",", ".").trim();
    return double.tryParse(texto) ?? 0;
  }
}
