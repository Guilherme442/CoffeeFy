import 'dart:io';

import 'package:flutter/material.dart';

import 'controller/configuracoes.dart';
import 'dowloads/visual_dow.dart';
import 'dowloads/youtube.dart';
import 'features/shared/ui/screens/AllSongs.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 40,
                  // Adicione a imagem do perfil do usuário aqui
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
                SizedBox(height: 20),
                Text(
                  'CoffeeFy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Versão 1.0 - Beta',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            subtitle: const Text('Pagina Inicial'),
            onTap:  () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AllSongs()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.smart_display_outlined),
            title: const Text('Youtube'),
            subtitle: const Text('Explore suas músicas no YouTube'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const YouTubePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.file_download_outlined),
            title: const Text('Dowloads'),
            subtitle: const Text('Baixe suas músicas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const YoutubeutilPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            subtitle: const Text('Configure aqui seu App'),
             onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Confi()),
              );
            },
          ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLogoutListTile(context),
              ],
        ),
      ),
    ],
  ),
);
  }


   Widget _buildLogoutListTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Sair'),
      subtitle: const Text('Finalizar sessão'),
      onTap: () {
        // Fecha o aplicativo completamente
        exit(0);
      },
    );
  }
}
