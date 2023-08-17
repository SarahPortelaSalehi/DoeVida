class Campanha {
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

  Campanha({
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
}
