import 'dart:developer';

import 'package:calculadora_imc/model/pessoa.dart';
import 'package:calculadora_imc/utils/utils.dart';
import 'package:flutter/material.dart';

class ListaPage extends StatelessWidget {
  final List<Pessoa> pessoas;

  const ListaPage({required this.pessoas, super.key});

  @override
  Widget build(BuildContext context) {
    return (pessoas.isEmpty)
        ? const Center(
            child: Text(
              "Nenhuma pessoa cadastrada",
              style: TextStyle(fontSize: 20),
            ),
          )
        : ListView.builder(
            itemCount: pessoas.length,
            itemBuilder: (context, index) {
              Pessoa pessoa = pessoas[index];
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
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Editar"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  pessoas.remove(pessoa);
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
}
