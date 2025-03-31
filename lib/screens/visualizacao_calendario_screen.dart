import 'package:app_cadastro_pessoas/models/configurar_calendarios.dart';
import 'package:app_cadastro_pessoas/services/api_service.dart';
import 'package:flutter/material.dart';


class VisualizacaoCalendarioScreen extends StatefulWidget {
  final int ano;
  final int mes;
  final List<Map<String, dynamic>> diasComHorarios;
  final Calendario calendarioCompleto;

  const VisualizacaoCalendarioScreen({
    required this.ano,
    required this.mes,
    required this.diasComHorarios,
    required this.calendarioCompleto,
  });

  @override
  _VisualizacaoCalendarioScreenState createState() => _VisualizacaoCalendarioScreenState();
}

class _VisualizacaoCalendarioScreenState extends State<VisualizacaoCalendarioScreen> {
  final ApiService apiService = ApiService();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário ${widget.mes}/${widget.ano}'),
        actions: [
          IconButton(
            icon: _isSaving 
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.save),
            onPressed: _isSaving ? null : _gravarCalendario,
            tooltip: 'Gravar no banco de dados',
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.diasComHorarios.length,
        itemBuilder: (context, index) {
          final dia = widget.diasComHorarios[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${dia['diaSemana']}, dia ${dia['dia']}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ...(dia['horarios'] as List<Horario>).map((horario) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Text(horario.hora, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(width: 16),
                          Text('${horario.vagas} vagas'),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _enviarEmail,
        child: Icon(Icons.email),
        tooltip: 'Enviar por e-mail',
      ),
    );
  }

  Future<void> _gravarCalendario() async {
    setState(() => _isSaving = true);
    
    try {
      // Primeiro limpa os dados existentes
      await apiService.limparCalendarioExistente(widget.ano, widget.mes);
      
      // Depois grava o novo calendário
      await apiService.salvarCalendario(widget.calendarioCompleto);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Calendário gravado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao gravar calendário: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _enviarEmail() async {
    // Implementação do envio por e-mail
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Funcionalidade de e-mail será implementada aqui')),
    );
  }
}