import 'package:calculadora_imc/model/pessoa.dart';
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  final Pessoa? pessoa;
  const MyForm({this.pessoa, super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  TextEditingController alturaController = TextEditingController();

  TextEditingController pesoController = TextEditingController();
  @override
  void initState() {
    alturaController.text = widget.pessoa?.altura.toString() ?? "";
    pesoController.text = widget.pessoa?.peso.toString() ?? "";

    super.initState();
  }

  String nome = '';
  double altura = 0;
  double peso = 0;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FORMULÁRIO"),
      ),
      body: Form(
        key: formKey,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(16)),
            Text(
              "Calcular IMC",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightGreen[900]),
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar")),
                  const VerticalDivider(),
                  ElevatedButton(
                      onPressed: () async {
                        salvarCalcular().then((pessoa) {
                          if (pessoa != null && context.mounted) {
                            Navigator.pop(context, pessoa);
                          }
                        });
                      },
                      child: const Text("Salvar")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future salvarCalcular() async {
    altura = formateNumber(alturaController.text);
    peso = formateNumber(pesoController.text);

    if (!formKey.currentState!.validate()) {
      showAlertSnackBar("Preencha todos os campos corretamente");
    } else {
      Pessoa pessoa = Pessoa(nome: nome, altura: altura, peso: peso);
      calcularIMC(pessoa);

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(pessoa.nome),
          content: Text(
              'Seu IMC é ${pessoa.imc!.toStringAsFixed(2)} : ${pessoa.classificacao} '),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Ok"),
            )
          ],
        ),
      );

      if (mounted) {
        Navigator.pop(context, pessoa);
      }
    }
  }

  calcularIMC(Pessoa pessoa) {
    pessoa.calcularIMC();
    pessoa.classificarIMC();
  }

  // String? _validarNome(String? name) {
  //   String nome = (name ?? "").trim();
  //   return (nome.isEmpty) ? "Informe um nome" : null;
  // }

  String? _validarAltura(String? alt) {
    double altura = formateNumber(alt ?? "");

    if (altura == 0 || altura > 3) {
      return "Informe uma altura válida ex: 1,60";
    }
    return null;
  }

  String? _validarPeso(String? peso) {
    double p = formateNumber(peso ?? "");

    if (p == 0) {
      return "Informe um peso Válido";
    }
    return null;
  }

  showAlertSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.amber[900],
    ));
  }

  double formateNumber(String? texto) {
    texto = (texto ?? "").replaceAll(",", ".").trim();
    return double.tryParse(texto) ?? 0;
  }
}
