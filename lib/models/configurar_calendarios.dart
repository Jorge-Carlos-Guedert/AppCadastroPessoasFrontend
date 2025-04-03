// configurar_calendarios.dart

class ConfigurarCalendarios {
  int ano;
  int mes;
  String primeiroDiaSemana;
  List<DiaSemana> diasSemana;
  List<DataEspecifica> datasEspecificas;

  ConfigurarCalendarios({
    required this.ano,
    required this.mes,
    required this.primeiroDiaSemana,
    required this.diasSemana,
    required this.datasEspecificas,
  });

  factory ConfigurarCalendarios.fromJson(Map<String, dynamic> json) {
    return ConfigurarCalendarios(
      ano: json['ano'],
      mes: json['mes'],
      primeiroDiaSemana: json['primeiroDiaSemana'],
      diasSemana: (json['diasSemana'] as List)
          .map((dia) => DiaSemana.fromJson(dia))
          .toList(),
      datasEspecificas: (json['datasEspecificas'] as List)
          .map((data) => DataEspecifica.fromJson(data))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ano': ano,
      'mes': mes,
      'primeiroDiaSemana': primeiroDiaSemana,
      'diasSemana': diasSemana.map((dia) => dia.toJson()).toList(),
      'datasEspecificas': datasEspecificas.map((data) => data.toJson()).toList(),
    };
  }
}

class DiaSemana {
  String nome;
  List<Horario> horarios;

  DiaSemana({
    required this.nome,
    required this.horarios,
  });

  factory DiaSemana.fromJson(Map<String, dynamic> json) {
    return DiaSemana(
      nome: json['nome'],
      horarios: (json['horarios'] as List)
          .map((horario) => Horario.fromJson(horario))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'horarios': horarios.map((horario) => horario.toJson()).toList(),
    };
  }
}

class DataEspecifica {
  int dia;
  List<Horario> horarios;

  DataEspecifica({
    required this.dia,
    required this.horarios,
  });

  factory DataEspecifica.fromJson(Map<String, dynamic> json) {
    return DataEspecifica(
      dia: json['dia'],
      horarios: (json['horarios'] as List)
          .map((horario) => Horario.fromJson(horario))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dia': dia,
      'horarios': horarios.map((horario) => horario.toJson()).toList(),
    };
  }
}
class Calendario {
  final int ano;
  final int mes;
  final String primeiroDiaSemana;
  final List<DiaSemana> diasSemana;
  final List<DataEspecifica> datasEspecificas;

  Calendario({
    required this.ano,
    required this.mes,
    required this.primeiroDiaSemana,
    required this.diasSemana,
    required this.datasEspecificas,
  });

  factory Calendario.fromJson(Map<String, dynamic> json) {
    var diasSemanaList = json['diasSemana'] as List;
    List<DiaSemana> diasSemana = diasSemanaList.map((i) => DiaSemana.fromJson(i)).toList();

    var datasEspecificasList = json['datasEspecificas'] as List;
    List<DataEspecifica> datasEspecificas = datasEspecificasList.map((i) => DataEspecifica.fromJson(i)).toList();

    return Calendario(
      ano: json['ano'],
      mes: json['mes'],
      primeiroDiaSemana: json['primeiroDiaSemana'],
      diasSemana: diasSemana,
      datasEspecificas: datasEspecificas,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ano': ano,
      'mes': mes,
      'primeiroDiaSemana': primeiroDiaSemana,
      'diasSemana': diasSemana.map((d) => d.toJson()).toList(),
      'datasEspecificas': datasEspecificas.map((d) => d.toJson()).toList(),
    };

    
  }
  }
class Horario {
  String hora;
  int vagas;

  Horario({
    required this.hora,
    required this.vagas,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      hora: json['hora'],
      vagas: json['vagas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hora': hora,
      'vagas': vagas,
    };
  }
  
}