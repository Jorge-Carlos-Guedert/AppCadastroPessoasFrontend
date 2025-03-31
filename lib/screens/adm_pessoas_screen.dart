import 'package:app_cadastro_pessoas/screens/adm_geral.dart';
import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'editar_pessoa_screen.dart'; // Import da tela de edição
 // Import da tela ADM_GERAL

class Administrador_Pessoas_Screen extends StatefulWidget {
  @override
  _Administrador_Pessoas_ScreenState createState() => _Administrador_Pessoas_ScreenState();
}

class _Administrador_Pessoas_ScreenState extends State<Administrador_Pessoas_Screen> {
  Future<List<Map<String, dynamic>>>? _futurePessoas;

  @override
  void initState() {
    super.initState();
    _futurePessoas = ApiService.getPessoas();
  }

  void _atualizarLista() {
    setState(() {
      _futurePessoas = ApiService.getPessoas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrar Pessoas'),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futurePessoas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar usuários'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum usuário cadastrado'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final pessoa = snapshot.data![index];
                return ListTile(
                  title: Text(pessoa['nome']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarPessoaScreen(pessoa: pessoa),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          bool confirmado = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Confirmar Exclusão'),
                                content: Text('Tem certeza que deseja excluir ${pessoa['nome']}?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancelar'),
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Excluir'),
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
                              await ApiService.excluirPessoa(pessoa['id']);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Pessoa excluída com sucesso!')),
                              );
                              _atualizarLista(); // Atualiza a lista após a exclusão
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao excluir pessoa: $e')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}