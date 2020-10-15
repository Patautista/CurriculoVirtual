class CurriculoObject{

  CurriculoObject(this.email, this.informal, this.listaCursos,
    this.listaTitulos, this.perfil, this.telefone, this.nome);

  //Formação profissional
  List<Titulo> listaTitulos;
  List<Curso> listaCursos;
  //Irfomações pessoais
  String nome;
  String perfil;
  String informal;
  //Informações de contato
  String telefone;
  String email;
}
class Titulo {
  Titulo({this.resumo, this.titulo});

  String titulo;
  String resumo;
}
class Curso {
  Curso({this.data, this.titulo, this.status, this.instituicao});

  String titulo;
  String data;
  String status;
  String instituicao;
}