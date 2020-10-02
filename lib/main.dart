import 'package:flutter/material.dart';

import 'CurriculoObject.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu currículo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CurriculoTela(title: 'Meu currículo'),
    );
  }
}

class CurriculoTela extends StatefulWidget {
  CurriculoTela({Key key, this.title, this.curriculo}) : super(key: key);

  final String title;
  final CurriculoObject curriculo;

  @override
  _CurriculoTelaState createState() => _CurriculoTelaState();
}

class _CurriculoTelaState extends State<CurriculoTela> {

  CurriculoObject curriculo;
  final TextStyle titulo = TextStyle(fontSize: 20);
  final TextStyle subtitulo = TextStyle(fontSize: 16);
  final TextStyle conteudo = TextStyle(fontSize: 14);
  final TextStyle nome = TextStyle(fontSize: 24);

  @override
  Widget build(BuildContext context) {

    curriculo = widget.curriculo;
    ///Testes.
    List<Curso> cursos = <Curso> [Curso("01/01/2017", "Biologia" , "Incompleto", "Universidade Federal do Ceará")];
    List<Titulo> titulos = <Titulo> [];
    curriculo = new CurriculoObject("caleb.kart@gmail.com", true, "Idiomas.", cursos,
        titulos, "Gosto de aprender.", "84028922", "Caleb de Sousa Vasconcelos");

    final alturaTela = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
          height: alturaTela,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: alturaTela * 0.025),
                carregarImagem(curriculo.imagem, alturaTela),
                SizedBox(height: alturaTela * 0.075),
                Column(
                  children: [
                    Text(
                      curriculo.nome,
                      style: nome,
                    ),
                    SizedBox(height: alturaTela * 0.05),
                    Text(
                      'Formação profissional:',
                      style: titulo,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0),
                      child: Divider(color: Colors.black,),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Títulos',
                          style: subtitulo,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Cursos',
                          style: subtitulo,
                        ),
                      ),
                    ),
                    listarCursos(curriculo.listaCursos, alturaTela, conteudo)
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Informações pessoais:',
                      style: titulo,
                    ),
                    Divider(color: Colors.black,),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Perfil',
                          style: subtitulo,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Expertise Informal',
                          style: subtitulo,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Informações para contato:',
                      style: titulo,
                    ),
                    Divider(color: Colors.black,),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Telefone',
                          style: subtitulo,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'E-mail',
                          style: subtitulo,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Editar',
        child: Icon(Icons.create),
      ),
    );
  }
}

Widget listarCursos(List<Curso> cursos, double alturaTela, TextStyle conteudo){
  return Container(
    height: alturaTela * 0.25,
    child: ListView.builder(
      itemCount: cursos.length,
      itemBuilder: (BuildContext context, int index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: alturaTela * 0.15,
            child: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(cursos[index].titulo, style: conteudo), flex: 5,),
                      Flexible(child: Text(cursos[index].instituicao, style: conteudo), flex: 5,),
                      Flexible(child: SizedBox(), flex: 1)
                    ],
                  ),
                ),
                Expanded(flex: 2, child: SizedBox()),
                Expanded(
                    flex: 3,
                    child: Row(
                  children: [
                    Text("Status: "),
                    Text(cursos[index].status, style: conteudo),
                  ],
                )),
                Expanded(flex: 1, child: SizedBox()),
                Expanded(
                  flex: 2,
                    child: Row(
                      children: [
                        Text("Data de início: "),
                        Text(cursos[index].data, style: conteudo),
                      ],
                    )
                )
              ],
            ),
          ),
        );
      },
    ),
  );
}
Widget carregarImagem(bool imagem, double alturaTela){
  if(imagem){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage('https://scontent.ffor8-1.fna.fbcdn.net/v/t1.0-9/84750702_1749653265171418_2193533840671113216_o.jpg?_nc_cat=108&_nc_sid=174925&_nc_eui2=AeGA9VVcfezAkYxWxI5ixn5nRBrMK6x0vaFEGswrrHS9oXFBOD8k-PYBf0UHFvG6hPs6Qw0KrdtbrbHDAcuKHnVM&_nc_ohc=ZrKGxMndcSgAX98kgfa&_nc_ht=scontent.ffor8-1.fna&oh=57e16768d1ed5ba0a6286721fa2574b8&oe=5F9C9845')),
        borderRadius: BorderRadius.circular(100),),
      height: alturaTela * 0.25,
      width: alturaTela * 0.25,
    );
  }
  else{
    return Container(
      child: Icon(
        Icons.account_circle,
        size: alturaTela * 0.25,
      ),
    );
  }
}
