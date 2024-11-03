import 'package:calculadora_imc/database/shared_db.dart';
import 'package:calculadora_imc/model/calculo.dart';
import 'package:calculadora_imc/model/pessoa.dart';
import 'package:calculadora_imc/pages/my_form.dart';
import 'package:calculadora_imc/utils/mynavigator.dart';
import 'package:calculadora_imc/utils/utils.dart';
import 'package:flutter/material.dart';

class ListaCalculosPage extends StatefulWidget {
  final List<Calculo> calculos;

  const ListaCalculosPage({
    required this.calculos,
    super.key,
  });

  @override
  State<ListaCalculosPage> createState() => _ListaCalculosPageState();
}

class _ListaCalculosPageState extends State<ListaCalculosPage> {
  Pessoa? pessoa;

  @override
  void initState() {
    super.initState();
    updatePessoa();
  }

  updatePessoa() async {
    pessoa = await Pessoa.getSharedPreference();

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  formateDate(String txt) {
    int? data = int.tryParse(txt);
    var datetime = DateTime.fromMillisecondsSinceEpoch(data ?? 0);

    return '${'${datetime.day}'.padLeft(2, '0')}/${'${datetime.month}'.padLeft(2, '0')}/${'${datetime.year}'.padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return (widget.calculos.isEmpty)
        ? const Center(
            child: Text(
              "Nenhuma pessoa cadastrada",
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.builder(
            itemCount: widget.calculos.length,
            itemBuilder: (context, index) {
              Calculo calculo = widget.calculos[index];

              return Card(
                color: colorIMC[calculo.classificacao],
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(calculo.data.toString()),
                            actions: [
                              const TextButton(
                                // onPressed: () => editarPessoa(pessoa, index),
                                onPressed: null,
                                child: Text("Editar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  calculo.excluir();
                                  widget.calculos.remove(calculo);
                                  setState(() {});
                                },
                                child: const Text(
                                  "Excluir",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  title: Text(pessoa!.nome),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Altura: ${pessoa!.altura}, '
                        'Peso: ${calculo.peso} Kg,',
                      ),
                      Text(
                        formatarData(calculo.data),
                        style: const TextStyle(),
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${calculo.classificacao}'),
                      Text(
                        'IMC: ${calculo.imc.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: false,
                ),
              );
            },
          );
  }

  editarPessoa(Pessoa pessoa, int index) async {
    Navigator.pop(context);
    Calculo? newpessoa = await navigatorPush(
        context: context,
        page: MyForm(
          pessoa: pessoa,
        ));

    if (newpessoa != null) {
      widget.calculos[index] = newpessoa;
      setState(() {});
    }
  }
}
