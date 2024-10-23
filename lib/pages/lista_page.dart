import 'dart:developer';

import 'package:calculadora_imc/model/pessoa.dart';
import 'package:calculadora_imc/pages/my_form.dart';
import 'package:calculadora_imc/utils/mynavigator.dart';
import 'package:calculadora_imc/utils/utils.dart';
import 'package:flutter/material.dart';

class ListaPage extends StatefulWidget {
  final List<Pessoa> pessoas;

  const ListaPage({required this.pessoas, super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  @override
  Widget build(BuildContext context) {
    return (widget.pessoas.isEmpty)
        ? const Center(
            child: Text(
              "Nenhuma pessoa cadastrada",
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.builder(
            itemCount: widget.pessoas.length,
            itemBuilder: (context, index) {
              Pessoa pessoa = widget.pessoas[index];
              log(pessoa.classificacao.toString());
              return Card(
                color: colorIMC[pessoa.classificacao],
                child: ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(pessoa.nome),
                            actions: [
                              TextButton(
                                onPressed: () => editarPessoa(pessoa, index),
                                child: const Text("Editar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.pessoas.remove(pessoa);
                                  setState(() {});
                                },
                                child: const Text("Excluir"),
                              ),
                            ],
                          );
                        });
                  },
                  title: Text(pessoa.nome),
                  subtitle: Text(
                    'Altura: ${pessoa.altura}, '
                    'Peso: ${pessoa.peso} Kg,',
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${pessoa.classificacao}'),
                      Text(
                        'IMC: ${pessoa.imc!.toStringAsFixed(2)}',
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
    Pessoa? newpessoa = await navigatorPush(
        context: context,
        page: MyForm(
          pessoa: pessoa,
        ));

    if (newpessoa != null) {
      widget.pessoas[index] = newpessoa;
      setState(() {});
    }
  }
}
