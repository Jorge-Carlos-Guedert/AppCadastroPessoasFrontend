import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'package:app_cadastro_pessoas/screens/adm_geral.dart'; // Import da tela ADM_GERAL

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _isadminValue = false; // false = Usuário comum, true = Administrador

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar Pessoas'),
        // Botão de voltar no canto superior esquerdo
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ícone de voltar
          onPressed: () {
            // Navega para a tela ADM_GERAL
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdmGeralScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome';
                  }
                  return null;
                },
              ),
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
                controller: _telefoneController,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
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
              ListTile(
                title: Text('Função'),
                subtitle: Text('Selecione a função do usuário'),
              ),
              RadioListTile<bool>(
                title: Text('Usuário'),
                value: false,
                groupValue: _isadminValue,
                onChanged: (value) {
                  setState(() {
                    _isadminValue = value!;
                  });
                },
              ),
              RadioListTile<bool>(
                title: Text('Administrador'),
                value: true,
                groupValue: _isadminValue,
                onChanged: (value) {
                  setState(() {
                    _isadminValue = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Cria um mapa com os dados da pessoa
                    Map<String, dynamic> pessoa = {
                      'nome': _nomeController.text,
                      'email': _emailController.text,
                      'telefone': _telefoneController.text,
                      'senha': _senhaController.text,
                      'isadmin': _isadminValue, // Usa o valor booleano do RadioButton
                    };
                    print('Função selecionada: $_isadminValue');

                    try {
                      // Envia os dados para a API
                      await ApiService.cadastrarPessoa(pessoa);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Pessoa cadastrada com sucesso!')),
                      );
                      // Retorna para a tela AdmGeralScreen
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AdmGeralScreen()),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Erro ao cadastrar pessoa: $e')),
                      );
                    }
                  }
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}