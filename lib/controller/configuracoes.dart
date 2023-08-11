// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import '../drawer.dart';
import '../info.dart';
import '../sobre.dart';

class Confi extends StatefulWidget {
  const Confi({Key? key}) : super(key: key);

  @override
  _ConfiState createState() => _ConfiState();
}

class _ConfiState extends State<Confi> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Configurações'),
      ),
        drawer: const CustomDrawer(),
      body: ListView(
        children: [
          Column(
            
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                'Geral',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildListTile(
                context,
                Icons.manage_accounts_outlined,
                'Guilherme Henrique da Cruz Horst ',
                'Editar informações da conta',
                '',
              ),
               const SizedBox(height: 20),
              _buildListTile(
                context,
                Icons.support_outlined,
                'Suporte',
                'Inicie um chat com o suporte',
                '',
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Feramentas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
                 const SizedBox(height: 20),
              _buildListTile(
                context,
                Icons.memory_outlined,
                'Informações',
                '.........',
              () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const InfoPage()),
    );
  },
 ),
              const SizedBox(height: 20),
              const Text(
                'Outros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            _buildListTile(
  context,
  Icons.star_outline,
  'Sobre',
  'Sobre o App',
  () {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SobrePage()),
    );
  },
 ),

            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title,
      String subtitle, dynamic onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle),
        ],
      ),
      onTap: onTap is Function
          ? () => onTap()
          : () => Navigator.of(context).restorablePushReplacementNamed(onTap),
    );
  }
}
