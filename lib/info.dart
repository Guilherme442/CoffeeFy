// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'drawer.dart';



class InfoPage extends StatefulWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Desconhecido',
    packageName: 'Desconhecido',
    version: 'Desconhecido',
    buildNumber: 'Desconhecido',
    buildSignature: 'Desconhecido',
    installerStore: 'Desconhecido',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Não configurado' : subtitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Informações sobre o App'),
        elevation: 4,
      ),
       drawer: const CustomDrawer(),
      body: ListView(
        children: <Widget>[
          _infoTile('Nome do aplicativo', _packageInfo.appName),
          _infoTile('Nome do pacote', _packageInfo.packageName),
          _infoTile('Versão do aplicativo', _packageInfo.version),
          _infoTile('Número da versão', _packageInfo.buildNumber),
          _infoTile('Assinatura', _packageInfo.buildSignature),
          _infoTile(
            'Loja de instaladores',
            _packageInfo.installerStore ?? 'Não disponível',
          ),
        ],
      ),
    );
  }
}