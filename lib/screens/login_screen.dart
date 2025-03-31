import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'package:app_cadastro_pessoas/screens/adm_geral.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a senha';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      print('Tentando fazer login...');
                      bool loginSuccess = await ApiService.login(_emailController.text, _senhaController.text);
                      
                      if (loginSuccess) {
                        print('Login bem-sucedido');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login realizado com sucesso!')),
                        );

                        // Verifique se o usuário é administrador
                        bool isAdmin = await ApiService.isAdmin(_emailController.text);
                        
                        if (isAdmin) {
                          // Navegar para a tela de administrador
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AdmGeralScreen()),
                          );
                        } else {
                          print('Não é administrador');
                          // Navegar para a tela principal (ou outra tela de usuário comum)
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                        }
                      } else {
                        print('Credenciais inválidas');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Email ou senha incorretos.')),
                        );
                      }
                    } catch (e) {
                      print('Erro ao fazer login: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao fazer login: $e')),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Cor de fundo verde
                  elevation: 5, // Elevação (relevo)
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Espaçamento interno
                ),
                child: Text(
                  'Entrar',
                  style: TextStyle(
                    fontSize: 16, // Tamanho da fonte
                    color: Colors.white, // Cor do texto
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}