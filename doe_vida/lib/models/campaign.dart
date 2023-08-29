import 'package:flutter/foundation.dart';

class Campaign {
  String icone;
  int codigo;
  String titulo;
  String descricao;
  List<String> tiposSanguineos;
  String localizacao;
  String nomePaciente;
  int progresso;
  int progressoEsperado;
  String userId;

  Campaign({
    required this.icone,
    required this.codigo,
    required this.titulo,
    required this.descricao,
    required this.tiposSanguineos,
    required this.localizacao,
    required this.nomePaciente,
    required this.progresso,
    required this.progressoEsperado,
    required this.userId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Campaign &&
              runtimeType == other.runtimeType &&
              icone == other.icone &&
              codigo == other.codigo &&
              titulo == other.titulo &&
              descricao == other.descricao &&
              listEquals(tiposSanguineos, other.tiposSanguineos) &&
              localizacao == other.localizacao &&
              nomePaciente == other.nomePaciente &&
              progresso == other.progresso &&
              progressoEsperado == other.progressoEsperado &&
              userId == other.userId;

  @override
  int get hashCode =>
      icone.hashCode ^
      codigo.hashCode ^
      titulo.hashCode ^
      descricao.hashCode ^
      hashList(tiposSanguineos) ^
      localizacao.hashCode ^
      nomePaciente.hashCode ^
      progresso.hashCode ^
      progressoEsperado.hashCode ^
      userId.hashCode;

  // Helper function to hash a list
  int hashList(List<dynamic> list) {
    int result = 0;
    for (dynamic element in list) {
      result = 31 * result + element.hashCode;
    }
    return result;
  }
}
