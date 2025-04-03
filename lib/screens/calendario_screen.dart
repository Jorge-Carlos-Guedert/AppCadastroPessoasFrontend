import 'package:app_cadastro_pessoas/screens/adm_geral.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:app_cadastro_pessoas/models/configurar_calendarios.dart';
import 'package:app_cadastro_pessoas/screens/visualizacao_calendario_screen.dart';
import 'package:http/http.dart' as http;



class CalendarioScreen extends StatefulWidget {
  @override
  _CalendarioScreenState createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  
  int? ano;
  int? mes;
  String? primeiroDiaSemana;
  List<DiaSemana> diasSemana = [];
  List<DataEspecifica> datasEspecificas = [];
  
  final List<String> diasDaSemana = [
    'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado', 'Domingo'
  ];

  @override
  void initState() {
    super.initState();
    _carregarDadosIniciais();
  }

  Future<void> _carregarDadosIniciais() async {
    // Carrega dados padrão ou do banco de dados
    final hoje = DateTime.now();
    setState(() {
      ano = hoje.year;
      mes = hoje.month;
      primeiroDiaSemana = 'Segunda';
      
      // Inicializa dias da semana com listas vazias
      diasSemana = diasDaSemana.map((dia) => DiaSemana(nome: dia, horarios: [])).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuração de Calendário'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _salvarCalendario,
          ),

          
        ],
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnoMesInput(),
              SizedBox(height: 20),
              _buildPrimeiroDiaSemanaInput(),
              SizedBox(height: 20),
              Text('Horários Padrão por Dia da Semana', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              ..._buildDiasSemanaHorarios(),
              SizedBox(height: 20),
              _buildAdicionarDataEspecifica(),
              SizedBox(height: 20),
              if (datasEspecificas.isNotEmpty) _buildDatasEspecificasList(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _visualizarCalendario,
                child: Text('Visualizar Calendário'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnoMesInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Ano'),
            initialValue: ano?.toString(),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe o ano';
              final year = int.tryParse(value);
              if (year == null || year < 1900 || year > 2100) return 'Ano inválido';
              return null;
            },
            onSaved: (value) => ano = int.parse(value!),
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Mês'),
            initialValue: mes?.toString(),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe o mês';
              final month = int.tryParse(value);
              if (month == null || month < 1 || month > 12) return 'Mês inválido';
              return null;
            },
            onSaved: (value) => mes = int.parse(value!),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimeiroDiaSemanaInput() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: 'Dia 1 é que dia da semana ?'),
      value: primeiroDiaSemana,
      items: diasDaSemana.map((dia) {
        return DropdownMenuItem(
          value: dia,
          child: Text(dia),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          primeiroDiaSemana = value;
        });
      },
      validator: (value) {
        if (value == null) return 'Selecione um dia';
        return null;
      },
    );
  }

  List<Widget> _buildDiasSemanaHorarios() {
    return diasSemana.map((diaSemana) {
      return Card(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(diaSemana.nome, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...diaSemana.horarios.map((horario) => _buildHorarioItem(horario, diaSemana)),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => _adicionarHorarioDialog(diaSemana),
                child: Text('Adicionar Horário'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 36),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildHorarioItem(Horario horario, DiaSemana diaSemana) {
    return ListTile(
      title: Text('${horario.hora} - ${horario.vagas} vagas'),
      trailing: IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          setState(() {
            diaSemana.horarios.remove(horario);
          });
        },
      ),
    );
  }

  Widget _buildAdicionarDataEspecifica() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Datas Específicas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _adicionarDataEspecificaDialog,
          child: Text('Adicionar Data Específica'),
        ),
      ],
    );
  }

  Widget _buildDatasEspecificasList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Datas Configuradas:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...datasEspecificas.map((data) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dia ${data.dia}', style: TextStyle(fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            datasEspecificas.remove(data);
                          });
                        },
                      ),
                    ],
                  ),
                  ...data.horarios.map((horario) => ListTile(
                    title: Text('${horario.hora} - ${horario.vagas} vagas'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          data.horarios.remove(horario);
                          if (data.horarios.isEmpty) {
                            datasEspecificas.remove(data);
                          }
                        });
                      },
                    ),
                  )),
                  ElevatedButton(
                    onPressed: () => _adicionarHorarioDataEspecificaDialog(data),
                    child: Text('Adicionar Horário'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 36),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Future<void> _adicionarHorarioDialog(DiaSemana diaSemana) async {
    final horaController = TextEditingController();
    final vagasController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Horário para ${diaSemana.nome}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: horaController,
                decoration: InputDecoration(
                  labelText: 'Horário (HH:mm)',
                  hintText: 'Ex: 08:30 ou 19:45',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o horário';
                  if (!_validarFormatoHorario(value)) return 'Formato inválido (HH:mm)';
                  return null;
                },
              ),
              TextFormField(
                controller: vagasController,
                decoration: InputDecoration(
                  labelText: 'Quantidade de Vagas',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a quantidade';
                  final qtd = int.tryParse(value);
                  if (qtd == null || qtd < 1 || qtd > 100) return 'Entre 1 e 100';
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (horaController.text.isNotEmpty && 
                    vagasController.text.isNotEmpty &&
                    _validarFormatoHorario(horaController.text)) {
                  final horario = Horario(
                    hora: horaController.text,
                    vagas: int.parse(vagasController.text),
                  );
                  setState(() {
                    diaSemana.horarios.add(horario);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _adicionarDataEspecificaDialog() async {
    if (mes == null || ano == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Defina o ano e mês primeiro')),
      );
      return;
    }

    final ultimoDiaMes = DateTime(ano!, mes! + 1, 0).day;
    final diaController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Data Específica'),
          content: TextFormField(
            controller: diaController,
            decoration: InputDecoration(
              labelText: 'Dia do mês (1-$ultimoDiaMes)',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Informe o dia';
              final dia = int.tryParse(value);
              if (dia == null || dia < 1 || dia > ultimoDiaMes) return 'Dia inválido';
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (diaController.text.isNotEmpty) {
                  final dia = int.parse(diaController.text);
                  if (dia >= 1 && dia <= ultimoDiaMes) {
                    setState(() {
                      datasEspecificas.add(DataEspecifica(dia: dia, horarios: []));
                    });
                    Navigator.pop(context);
                    _adicionarHorarioDataEspecificaDialog(datasEspecificas.last);
                  }
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _adicionarHorarioDataEspecificaDialog(DataEspecifica data) async {
    final horaController = TextEditingController();
    final vagasController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Horário para dia ${data.dia}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: horaController,
                decoration: InputDecoration(
                  labelText: 'Horário (HH:mm)',
                  hintText: 'Ex: 08:30 ou 19:45',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o horário';
                  if (!_validarFormatoHorario(value)) return 'Formato inválido (HH:mm)';
                  return null;
                },
              ),
              TextFormField(
                controller: vagasController,
                decoration: InputDecoration(
                  labelText: 'Quantidade de Vagas',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a quantidade';
                  final qtd = int.tryParse(value);
                  if (qtd == null || qtd < 1 || qtd > 100) return 'Entre 1 e 100';
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (horaController.text.isNotEmpty && 
                    vagasController.text.isNotEmpty &&
                    _validarFormatoHorario(horaController.text)) {
                  final horario = Horario(
                    hora: horaController.text,
                    vagas: int.parse(vagasController.text),
                  );
                  setState(() {
                    data.horarios.add(horario);
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  bool _validarFormatoHorario(String horario) {
    if (horario.length != 5 || horario[2] != ':') return false;
    
    final horasStr = horario.substring(0, 2);
    final minutosStr = horario.substring(3, 5);
    
    final horas = int.tryParse(horasStr);
    final minutos = int.tryParse(minutosStr);
    
    if (horas == null || minutos == null) return false;
    if (horas < 0 || horas > 23) return false;
    if (minutos < 0 || minutos > 59) return false;
    
    return true;
  }

  Future<void> _salvarCalendario() async {
  // Verifica se o formulário é válido
  if (!_formKey.currentState!.validate()) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Corrija os erros no formulário antes de salvar')),
    );
    return;
  }
  
  // Salva os dados do formulário
  _formKey.currentState!.save();
  
  // Verificação adicional de campos obrigatórios
  if (ano == null || mes == null || primeiroDiaSemana == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Preencha todos os campos obrigatórios')),
    );
    return;
  }
  
  // Verifica se há pelo menos um horário configurado
  final hasAnyHorarios = diasSemana.any((dia) => dia.horarios.isNotEmpty) || 
                       datasEspecificas.any((data) => data.horarios.isNotEmpty);
  
  if (!hasAnyHorarios) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Adicione pelo menos um horário em algum dia')),
    );
    return;
  }
  
  // Mostra indicador de carregamento
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(child: CircularProgressIndicator()),
  );
  
  try {
    // Prepara o objeto calendário
    final calendario = Calendario(
      ano: ano!,
      mes: mes!,
      primeiroDiaSemana: primeiroDiaSemana!,
      diasSemana: diasSemana.where((dia) => dia.horarios.isNotEmpty).toList(),
      datasEspecificas: datasEspecificas.where((data) => data.horarios.isNotEmpty).toList(),
    );
    
    // Tenta salvar
    await apiService.salvarCalendario(calendario);
    
    // Fecha o diálogo de carregamento
    Navigator.of(context).pop();
    
    // Mostra mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Calendário salvo com sucesso!')),
    );
    
  } catch (e, stackTrace) {
    // Fecha o diálogo de carregamento
    Navigator.of(context).pop();
    
    // Log para depuração
    debugPrint('Erro ao salvar calendário: $e');
    debugPrint('Stack trace: $stackTrace');
    
    // Mensagem amigável para o usuário
    String errorMessage = 'Erro ao salvar calendário';
    if (e is http.ClientException) {
      errorMessage = 'Erro de conexão com o servidor';
    } else if (e is FormatException) {
      errorMessage = 'Erro no formato dos dados';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$errorMessage: ${e.toString()}')),
    );
  }
}

  Future<void> _visualizarCalendario() async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    
    final ultimoDiaMes = DateTime(ano!, mes! + 1, 0).day;
    
    // Processa o calendário para exibição
    final diasComHorarios = <Map<String, dynamic>>[];
    
    // Cria uma fila de dias da semana começando pelo primeiro dia
    final indexInicio = diasDaSemana.indexOf(primeiroDiaSemana!);
    final filaDiasSemana = [...diasDaSemana.sublist(indexInicio), ...diasDaSemana.sublist(0, indexInicio)];
    
    int diaSemanaIndex = 0;
    
    for (int dia = 1; dia <= ultimoDiaMes; dia++) {
      final diaSemana = filaDiasSemana[diaSemanaIndex];
      
      // Combina horários padrão e específicos
      final horariosPadrao = diasSemana.firstWhere((d) => d.nome == diaSemana).horarios;
      final dataEspecifica = datasEspecificas.firstWhere((d) => d.dia == dia, orElse: () => DataEspecifica(dia: dia, horarios: []));
      
      final todosHorarios = <Horario>[];
      todosHorarios.addAll(horariosPadrao);
      todosHorarios.addAll(dataEspecifica.horarios);
      
      // Remove duplicatas (mantém a última ocorrência)
      final horariosUnicos = <String, Horario>{};
      for (var horario in todosHorarios) {
        horariosUnicos[horario.hora] = horario;
      }
      
      if (horariosUnicos.isNotEmpty) {
        diasComHorarios.add({
          'dia': dia,
          'diaSemana': diaSemana,
          'horarios': horariosUnicos.values.toList(),
        });
      }
      
      diaSemanaIndex = (diaSemanaIndex + 1) % 7;
    }
    
    // Cria o objeto calendário completo para gravação
    final calendarioCompleto = Calendario(
      ano: ano!,
      mes: mes!,
      primeiroDiaSemana: primeiroDiaSemana!,
      diasSemana: diasSemana,
      datasEspecificas: datasEspecificas,
    );
    
    // Navega para a tela de visualização
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisualizacaoCalendarioScreen(
          ano: ano!,
          mes: mes!,
          diasComHorarios: diasComHorarios,
          calendarioCompleto: calendarioCompleto,
        ),
      ),
    );
  }
}
}