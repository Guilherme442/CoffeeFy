import 'package:flutter/material.dart';
import 'drawer.dart';

class SobrePage extends StatelessWidget {
  const SobrePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        drawer: const CustomDrawer(),
       appBar: AppBar(
    centerTitle: true,
    title: const Text(
      'Sobre',
      style: TextStyle(
        color: Colors.white,
      ),
    ),
       ),
      body: Stack(
        children: [
          Container(
         decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF000000), Color(0xFF404258)],
            ),
          ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/logo.png', width: 150, height: 150),
              ),
              const SizedBox(height: 10),
              const Text(
                'CoffeeFy',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Versão: 1.0 ',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 1),
              const Text(
                '2023',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 50),
              _buildInformationRow(
                context,
                Icons.android_outlined,
                Icons.desktop_windows_outlined,
                Icons.phone_iphone_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformationRow(
    BuildContext context,
    IconData icon1,
    IconData icon2,
    IconData icon3,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon1, color: Colors.green, size: 30),
        const SizedBox(width: 10),
        Icon(icon3, color: Colors.grey, size: 30),
      ],
    );
  }
}
