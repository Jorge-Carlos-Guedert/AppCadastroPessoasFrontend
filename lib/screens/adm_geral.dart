

import 'package:app_cadastro_pessoas/screens/calendario_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'package:app_cadastro_pessoas/screens/adm_pessoas_screen.dart';
import 'package:app_cadastro_pessoas/screens/login_screen.dart';
import 'package:app_cadastro_pessoas/screens/cadastro_screen.dart';


class AdmGeralScreen extends StatefulWidget {
  @override
  _AdmGeralScreenState createState() => _AdmGeralScreenState();
}

class _AdmGeralScreenState extends State<AdmGeralScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reseta o estado ao retornar à tela
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrador Geral'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Lista de administradores
          Expanded(
            child: FutureBuilder<List<String>>(
              future: ApiService.getAdmins(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar administradores'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Nenhum administrador cadastrado'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data![index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Botões
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Administrador_Pessoas_Screen()),
                    );
                  },
                  child: Text('PESSOAS'),
                ),
                
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CalendarioScreen()),
                    );
                  },
                  child: Text('CALENDÁRIO'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => CadastroScreen()),
                    );
                  },
                  child: Text('CADASTRAR'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text('SAIR'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}