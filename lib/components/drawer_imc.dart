import 'dart:developer';

import 'package:calculadora_imc/database/shared_db.dart';
import 'package:calculadora_imc/model/pessoa.dart';
import 'package:calculadora_imc/pages/configuracoes.dart';
import 'package:calculadora_imc/utils/mynavigator.dart';
import 'package:flutter/material.dart';

class DrawerImc extends StatefulWidget {
  const DrawerImc({super.key});

  @override
  State<DrawerImc> createState() => _DrawerImcState();
}

class _DrawerImcState extends State<DrawerImc> {
  Pessoa? pessoa;

  getUser() async {
    try {
      pessoa = await SharedDB().getUser();
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text((pessoa != null) ? pessoa!.nome : ""),
            accountEmail: const Text(""),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Configurações"),
                  onTap: () {
                    Navigator.pop(context);
                    navigatorPush(
                        context: context, page: const Configuracoes());
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
