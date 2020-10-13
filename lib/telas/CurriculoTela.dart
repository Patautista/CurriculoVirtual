import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:curriculo_virtual/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
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
  bool editmode_curs = false;
  bool editmode_titl = false;
  bool editmode_prof = false;
  bool editmode_img = false;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    String path;
    await getApplicationDocumentsDirectory().then((value) => path = value.path);
    if(await File("$path/image1.png").exists()){
      _image = File("$path/image1.png");
    }
    else{
      _image = null;
    }
  }

  Future setImageCamera() async {
    String path;
    await getApplicationDocumentsDirectory().then((value) => path = value.path);
    if (await Permission.camera.request().isGranted) {
      final pickedFile = await picker.getImage(source: ImageSource.camera);
      if (pickedFile != null) {
        await _image.delete();
        imageCache.evict(FileImage(_image));
        setState(() {
          _image = File(pickedFile.path);
        });
        await _image.copy('$path/image1.png');
      }
      editmode_img = !editmode_img;
    }
    else{
      print("Erro");
    }
  }

  Future setImageMedia() async {
    String path;
    await getApplicationDocumentsDirectory().then((value) => path = value.path);
    if (await Permission.mediaLibrary.request().isGranted) {
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        await _image.delete();
        imageCache.evict(FileImage(_image));
        setState(() {
          _image = File(pickedFile.path);
        });
        await _image.copy('$path/image1.png');
      }
      editmode_img = !editmode_img;
    }
    else{
      print("Erro");
    }
  }


  //Controladores de texto.
  final perfilController = new TextEditingController();
  TextEditingController expertiseController = new TextEditingController();
  TextEditingController telefoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  List<List<TextEditingController>> editorCursos;

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
                children: [
                  SizedBox(height: alturaTela * 0.025),
                  FutureBuilder<dynamic>(
                      future: getImage(), // function where you call your api
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
                        if( snapshot.connectionState == ConnectionState.waiting){
                          return  Center();
                        }else{
                          if (snapshot.hasError)
                            return Center(child: Text('Error: ${snapshot.error}'));
                          else
                            return editmode_img?
                            Column(
                              children: [
                                Text("Escolha de onde carregar a nova imagem:", style: conteudo,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(icon: Icon(Icons.image, color: color,size: alturaTela*0.06,),
                                        onPressed: setImageMedia),
                                    IconButton(icon: Icon(Icons.camera, color: color,size: alturaTela*0.06,),
                                        onPressed: setImageCamera),
                                  ],
                                ),
                                SizedBox(height: alturaTela*0.015,),
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      editmode_img = !editmode_img;
                                    });
                                  },
                                  child: Container(child: Text("Cancelar", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold))),
                                ),
                              ],
                            )
                                :
                            GestureDetector(
                                onTap: (){
                                  setState(() {
                                    editmode_img = !editmode_img;
                                  });
                                },
                                child: carregarImagem(_image, alturaTela)
                            );
                        }
                      }),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
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
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Divider(color: Colors.black,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Títulos ',
                              style: subtitulo,
                            ),

                            Container(
                              height: alturaTela*0.05,
                              width: alturaTela*0.05,
                              child: IconButton(icon: Icon(Icons.create, size: alturaTela*0.03,),
                                color: color,
                                onPressed: (){
                                  setState(() {
                                    editmode_curs = !editmode_curs;
                                  });
                                },),
                            )
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Cursos ',
                                style: subtitulo,
                              ),

                              Container(
                                height: alturaTela*0.05,
                                width: alturaTela*0.05,
                                child: IconButton(icon: Icon(Icons.create, size: alturaTela*0.03,),
                                  color: color,
                                  onPressed: (){
                                    setState(() {
                                      editmode_prof = !editmode_prof;
                                    });
                                  },),
                              )
                            ],
                          ),
                      ),
                      editmode_curs?
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: curriculo.listaCursos.length,
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
                                        Flexible(child: Text(curriculo.listaCursos[index].titulo, style: conteudo), flex: 5,),
                                        Flexible(child: Text(curriculo.listaCursos[index].instituicao, style: conteudo), flex: 5,),
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
                                          Text(curriculo.listaCursos[index].status, style: conteudo),
                                        ],
                                      )),
                                  Expanded(flex: 1, child: SizedBox()),
                                  Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          Text("Data de início: "),
                                          Text(curriculo.listaCursos[index].data, style: conteudo),
                                        ],
                                      )
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                          :
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
                            child: IconButton(icon: Icon(Icons.create, size: alturaTela*0.04,),
                              color: color,
                              onPressed: (){
                                setState(() {
                                  editmode_supl = !editmode_supl;
                                });
                              },),
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
                            child: IconButton(icon: Icon(Icons.create, size: alturaTela*0.04,),
                              color: color,
                              onPressed: (){
                                setState(() {
                                  editmode_cont = !editmode_cont;
                                });
                              },),
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
Widget carregarImagem(File _image, double alturaTela){
  if(_image != null){
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: Image.file(_image).image),
        //borderRadius: BorderRadius.circular(100),
      ),
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