import 'package:curriculo_virtual/main.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../main.dart';
import '../service/CurriculoObject.dart';

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
  bool editmode_supl = false;
  bool editmode_cont = false;
  bool editmode_prof = false;


  //Controladores de texto.
  final perfilController = new TextEditingController();
  TextEditingController expertiseController = new TextEditingController();
  TextEditingController telefoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  void initState() {
    super.initState();
    perfilController.addListener(() {
      final text = perfilController.text.toLowerCase();
      perfilController.value = perfilController.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });


    curriculo = widget.curriculo;
    ///Testes.

    Titulo tituloteste = Titulo("Programação em linguagem Java", "ExperiênciacomFrameworkSpringBootecriação de aplicações Backend com API REST");
    Curso cursoteste = Curso("01/01/2017", "Biologia" , "Incompleto", "Universidade Federal do Ceará");
    List<Curso> cursos = <Curso> [cursoteste, cursoteste, cursoteste];
    List<Titulo> titulos = <Titulo> [tituloteste, tituloteste];
    curriculo = new CurriculoObject("caleb.kart@gmail.com", true, "Idiomas.", cursos,
        titulos, "Gosto de aprender.", "84028922", "Caleb de Sousa Vasconcelos");
    perfilController.text = curriculo.perfil;
    expertiseController.text = curriculo.informal;
    telefoneController.text = curriculo.telefone;
    emailController.text = curriculo.email;

  }

  void dispose() {
    perfilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Formação Profissional ',
                            style: titulo,
                          ),
                          Container(
                            height: alturaTela*0.05,
                            width: alturaTela*0.05,
                            child: Ink(
                              decoration: const ShapeDecoration(
                                color: color,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(icon: Icon(Icons.create, size: alturaTela*0.025,),
                                color: Colors.white,
                                onPressed: (){
                                  setState(() {
                                    editmode_prof = !editmode_prof;
                                  });
                                },),
                            ),
                          )
                        ],
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Informações suplementares ',
                            style: titulo,
                          ),
                          Container(
                            height: alturaTela*0.05,
                            width: alturaTela*0.05,
                            child: Ink(
                              decoration: const ShapeDecoration(
                                color: color,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(icon: Icon(Icons.create, size: alturaTela*0.025,),
                                color: Colors.white,
                                onPressed: (){
                                  setState(() {
                                    editmode_supl = !editmode_supl;
                                  });
                                },),
                            ),
                          )
                        ],
                      ),
                      Divider(color: Colors.black,),
                      editmode_supl?
                      FocusTraversalGroup(
                        child: Form(
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: () {
                            Form.of(primaryFocus.context).save();
                          },
                          child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                  child: TextFormField(
                                    onChanged: (text) {
                                      print("First text field: $text");
                                    },
                                    controller: perfilController,
                                    decoration: InputDecoration(
                                        hintText: "Perfil"
                                    ),
                                    onSaved: (String value) {
                                      print(perfilController.text);
                                    },
                                  ),
                                ),
                                SizedBox(height: alturaTela*0.05),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                  child: TextFormField(
                                    controller: expertiseController,
                                    decoration: InputDecoration(
                                        hintText: "Expertise Informal"
                                    ),
                                    onSaved: (String value) {
                                      print('Value for field ');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      // Validate returns true if the form is valid, or false
                                      // otherwise.
                                      setState(() {
                                        curriculo.perfil = perfilController.text;
                                        curriculo.informal = expertiseController.text;
                                        editmode_supl = !editmode_supl;
                                      });
                                      /*
                                        if (_formKey.currentState.validate()) {
                                          // If the form is valid, display a Snackbar.
                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                                        }
                                         */
                                    },
                                    child: Text('Salvar'),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      )
                          :
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Perfil',
                                    style: subtitulo,
                                  ),
                                  Text(
                                    curriculo.perfil,
                                    style: conteudo,
                                  ),
                                ],
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Expertise Informal',
                                      style: subtitulo,
                                    ),
                                    Text(
                                      curriculo.informal,
                                      style: conteudo,
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Informações para contato ',
                            style: titulo,
                          ),
                          Container(
                            height: alturaTela*0.05,
                            width: alturaTela*0.05,
                            child: Ink(
                              decoration: const ShapeDecoration(
                                color: color,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(icon: Icon(Icons.create, size: alturaTela*0.025,),
                                color: Colors.white,
                                onPressed: (){
                                  setState(() {
                                    editmode_cont = !editmode_cont;
                                  });
                                },),
                            ),
                          )
                        ],
                      ),
                      Divider(color: Colors.black,),
                      editmode_cont?
                      FocusTraversalGroup(
                        child: Form(
                          autovalidateMode: AutovalidateMode.always,
                          onChanged: () {
                            Form.of(primaryFocus.context).save();
                          },
                          child: Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                  child: TextFormField(
                                    onChanged: (text) {
                                      print("First text field: $text");
                                    },
                                    controller: telefoneController,
                                    decoration: InputDecoration(
                                        hintText: "Telefone"
                                    ),
                                    onSaved: (String value) {
                                      print(perfilController.text);
                                    },
                                  ),
                                ),
                                SizedBox(height: alturaTela*0.05),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                  child: TextFormField(
                                    controller: emailController,
                                    decoration: InputDecoration(
                                        hintText: "E-mail"
                                    ),
                                    onSaved: (String value) {
                                      print('Value for field ');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      // Validate returns true if the form is valid, or false
                                      // otherwise.
                                      setState(() {
                                        curriculo.telefone = telefoneController.text;
                                        curriculo.email = emailController.text;
                                        editmode_cont = !editmode_cont;
                                      });
                                      /*
                                        if (_formKey.currentState.validate()) {
                                          // If the form is valid, display a Snackbar.
                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                                        }
                                         */
                                    },
                                    child: Text('Salvar'),
                                  ),
                                ),
                              ]
                          ),
                        ),
                      )
                          :
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Telefone',
                                      style: subtitulo,
                                    ),
                                    Text(
                                      curriculo.telefone,
                                      style: conteudo,
                                    ),
                                  ],
                                )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'E-mail',
                                      style: subtitulo,
                                    ),
                                    Text(
                                      curriculo.email,
                                      style: conteudo,
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          )
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          setState(() { editmode_supl = !editmode_supl; })
        },
        tooltip: 'Editar',
        child: Icon(Icons.create),
      ),
       */
    );
  }
}

Widget listarCursos(List<Curso> cursos, double alturaTela, TextStyle conteudo){
  return ListView.builder(
    physics: ScrollPhysics(),
    shrinkWrap: true,
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

Widget editar(BuildContext context, TextEditingController perfilController, TextEditingController expertiseController){

  final _formKey = GlobalKey<FormState>();
  return FocusTraversalGroup(
    child: Form(
      autovalidateMode: AutovalidateMode.always,
      onChanged: () {
        Form.of(primaryFocus.context).save();
      },
      child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints.tight(const Size(300, 50)),
              child: TextFormField(
                onChanged: (text) {
                  print("First text field: $text");
                },
                controller: perfilController,
                decoration: InputDecoration(
                    hintText: "Perfil"
                ),
                onSaved: (String value) {
                  print(perfilController.text);
                },
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints.tight(const Size(300, 50)),
              child: TextFormField(
                controller: expertiseController,
                decoration: InputDecoration(
                    hintText: "Expertise Informal"
                ),
                onSaved: (String value) {
                  print('Value for field ');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  /*
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                }
                 */
                },
                child: Text('Salvar'),
              ),
            ),
          ]
      ),
    ),
  );
}