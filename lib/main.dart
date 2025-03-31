import 'package:app_cadastro_pessoas/screens/adm_geral.dart';
import 'package:app_cadastro_pessoas/screens/adm_pessoas_screen.dart';
import 'package:app_cadastro_pessoas/screens/cadastro_screen.dart';
import 'package:app_cadastro_pessoas/screens/calendario_screen.dart';
import 'package:app_cadastro_pessoas/screens/editar_pessoa_screen.dart';
import 'package:app_cadastro_pessoas/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';


import 'package:app_cadastro_pessoas/services/http_overrides.dart';
import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  try {
    await ApiService.verificarConexao();
    print('Conexão com o banco de dados verificada com sucesso!');
  } catch (e) {
    print('Erro ao verificar conexão com o banco de dados: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Cadastro de Pessoas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: 
      LoginScreen(),
      //CalendarioScreen(),
      //CadastroScreen(),
      //Administrador_Pessoas_Screen(),
      //AdmGeralScreen(),
      //AdmLoginScreen(),
    );
  }
}