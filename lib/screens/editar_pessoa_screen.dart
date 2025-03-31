import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'package:app_cadastro_pessoas/screens/adm_pessoas_screen.dart';

class EditarPessoaScreen extends StatefulWidget {
  final Map<String, dynamic> pessoa;

  EditarPessoaScreen({required this.pessoa});

  @override
  _EditarPessoaScreenState createState() => _EditarPessoaScreenState();
}

class _EditarPessoaScreenState extends State<EditarPessoaScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nomeController = TextEditingController(text: widget.pessoa['nome']);
  late final _emailController = TextEditingController(text: widget.pessoa['email']);
  late final _telefoneController = TextEditingController(text: widget.pessoa['telefone']);
  late final _senhaController = TextEditingController(text: widget.pessoa['senha']);
  late bool _isAdmin = widget.pessoa['isAdmin'];

  Future<void> _salvarEdicao() async {
  if (_formKey.currentState!.validate()) {
    final dadosAtualizados = {
      'nome': _nomeController.text,
      'email': _emailController.text,
      'telefone': _telefoneController.text,
      'senha': _senhaController.text,
      'isAdmin': _isAdmin,
    };

    // Exibir diálogo de confirmação
    bool confirmado = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Edição'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nome: ${dadosAtualizados['nome']}'),
                Text('Email: ${dadosAtualizados['email']}'),
                Text('Senha: ${dadosAtualizados['senha']}'),
                Text('Administrador: ${dadosAtualizados['isAdmin']}'),
            
              ],
            
            ),
          ),
        
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
        
      },
    );

    

    if (confirmado == true) {
      try {
        int id = int.parse(widget.pessoa['id'].toString());
        await ApiService.atualizarPessoa(id, dadosAtualizados);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pessoa atualizada com sucesso!')),
        );
        // Navegar de volta para a tela de administração de pessoas
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Administrador_Pessoas_Screen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar pessoa: $e')),
        );
      }
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Pessoa'),
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
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
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
                    return 'Campo obrigatório';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Administrador'),
                value: _isAdmin,
                onChanged: (value) {
                  setState(() {
                    _isAdmin = value;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _salvarEdicao,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}