import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:curriculo_virtual/service/Capturer.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:curriculo_virtual/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../main.dart';
import '../service/CurriculoObject.dart';
import 'dart:ui' as ui;
import 'package:share/share.dart';


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
  bool printmode = false;

  ui.Image curriculoImage = null;

  GlobalKey<OverRepaintBoundaryState> globalKey = GlobalKey();
  compartilharCurriculo() async{
    String path;
    await getTemporaryDirectory().then((value) => path = value.path);
    var renderObject = globalKey.currentContext.findRenderObject();

    RenderRepaintBoundary boundary = renderObject;
    ui.Image captureImage = await boundary.toImage(pixelRatio: 2.0);

    ByteData byteData = await captureImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();

    File imgFile = new File('$path/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
    print(imgFile.path);

    Share.shareFiles(['$path/screenshot.png'], text: 'Meu currículo');
    setState(() => printmode = !printmode);
  }

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

  TextEditingController cursoController = new TextEditingController();
  TextEditingController instituicaoController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController dataController = new TextEditingController();

  List<Map<String, TextEditingController>> editorCursos = [];

  void initState() {
    super.initState();

    curriculo = widget.curriculo;
    ///Testes.

    List<Curso> cursos = <Curso> [
      Curso(data:"01/01/2017", titulo: "Biologia" , status: "Incompleto", instituicao: "Universidade Federal do Ceará"),
      Curso(data:"04/03/2019", titulo: "Computação" , status: "Completo", instituicao: "Universidade Federal do Ceará"),
      Curso(data:"31/05/2019", titulo: "Direito" , status: "Completo", instituicao: "Universidade Federal do Ceará")
    ];
    List<Titulo> titulos = <Titulo> [
      Titulo(titulo:"Programação em linguagem Java", resumo: "Experiência com Framework SpringBoot e criação de aplicações Backend com API REST"),
      Titulo(titulo:"Programação em linguagem Java", resumo: "Experiência com Framework SpringBoot e criação de aplicações Backend com API REST")
    ];
    curriculo = new CurriculoObject("caleb.kart@gmail.com", true, "Idiomas.", cursos,
        titulos, "Gosto de aprender.", "84028922", "Caleb de Sousa Vasconcelos");

    perfilController.text = curriculo.perfil;
    expertiseController.text = curriculo.informal;
    telefoneController.text = curriculo.telefone;
    emailController.text = curriculo.email;


    for(int i=0; i< curriculo.listaCursos.length; i++){
      var mapaControladoreCurso = {"cursoController": TextEditingController(),"instituicaoController": TextEditingController() ,
        "statusController": TextEditingController(), "dataController": TextEditingController()};

      mapaControladoreCurso["cursoController"].text = curriculo.listaCursos[i].titulo;
      mapaControladoreCurso["instituicaoController"].text = curriculo.listaCursos[i].instituicao;
      mapaControladoreCurso["statusController"].text = curriculo.listaCursos[i].status;
      mapaControladoreCurso["dataController"].text = curriculo.listaCursos[i].data;
      editorCursos.add(mapaControladoreCurso);
    }
  }

  void dispose() {
    perfilController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(printmode){
      Future.delayed(const Duration(milliseconds: 100), () {compartilharCurriculo();});
    }

    final alturaTela = MediaQuery.of(context).size.height;

    List<Widget> corpoCurriculo = [

      Column(
        children: [
          SizedBox(height: alturaTela * 0.025),
          FutureBuilder<dynamic>(
              future: getImage(), // function where you call your api
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {  // AsyncSnapshot<Your object type>
                if( snapshot.connectionState == ConnectionState.waiting){
                  return  Container(
                    height: alturaTela * 0.25,
                    width: alturaTela * 0.25,
                  );
                }else{
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  else
                    return editmode_img?
                    Column(
                      children: [
                        SizedBox(height: alturaTela*0.05,),
                        Text("Por onde deseja carregar a nova imagem?", style: conteudo,),
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
                    printmode?
                        Container()
                        :
                        Container(
                          height: alturaTela*0.05,
                          width: alturaTela*0.05,
                          child:  IconButton(icon: Icon(Icons.create, size: alturaTela*0.03,),
                            color: color,
                            onPressed: (){
                              setState(() {
                                editmode_titl = !editmode_titl;
                              });
                            },),
                        )
                  ],
                ),
              ),
              editmode_titl?
              Column(
                children: [
                  Form(
                    //key: GlobalKey<FormState>(),
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () {
                      //Form.of(primaryFocus.context).save();
                    },
                    child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: curriculo.listaCursos.length,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                            children: [
                              SizedBox(height: alturaTela*0.05),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextFormField(
                                  onChanged: (text) {
                                    print("First text field: $text");
                                  },
                                  controller: editorCursos[index]["cursoController"],
                                  decoration: InputDecoration(
                                      hintText: "Nome do Curso"
                                  ),
                                  onSaved: (String value) {
                                    print(editorCursos[index]["cursoController"].text);
                                  },
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextFormField(
                                  onChanged: (text) {
                                    print("First text field: $text");
                                  },
                                  controller: editorCursos[index]["instituicaoController"],
                                  decoration: InputDecoration(
                                      hintText: "Nome da Instituição"
                                  ),
                                  onSaved: (String value) {
                                    print(editorCursos[index]["instituicaoController"].text);
                                  },
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextFormField(
                                  controller: editorCursos[index]["statusController"],
                                  decoration: InputDecoration(
                                      hintText: "Status do curso"
                                  ),
                                  onSaved: (String value) {
                                    print('Value for field ');
                                  },
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextField(
                                  controller: editorCursos[index]["dataController"],
                                  decoration: InputDecoration(
                                      hintText: "Status do curso"
                                  ),
                                ),
                              ),
                            ]
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      color: color,
                      textColor: Colors.white,
                      onPressed: () {
                        for(int i=0; i < curriculo.listaCursos.length; i++){
                          setState(() {
                            curriculo.listaCursos[i].titulo = editorCursos[i]["cursoController"].text;
                            curriculo.listaCursos[i].instituicao = editorCursos[i]["instituicaoController"].text;
                            curriculo.listaCursos[i].status = editorCursos[i]["statusController"].text;
                            curriculo.listaCursos[i].data = editorCursos[i]["dataController"].text;
                          });
                        }
                        setState(() {
                          editmode_curs = !editmode_curs;
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
                ],
              )
                  :
              listarTitulos(curriculo.listaTitulos, alturaTela, conteudo),
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Cursos ',
                      style: subtitulo,
                    ),
                    printmode?
                    Container()
                        :
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
              editmode_curs?
              Column(
                children: [
                  Form(
                    //key: GlobalKey<FormState>(),
                    autovalidateMode: AutovalidateMode.always,
                    onChanged: () {
                      //Form.of(primaryFocus.context).save();
                    },
                    child: ListView.builder(
                      addAutomaticKeepAlives: true,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: curriculo.listaCursos.length,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                            children: [
                              SizedBox(height: alturaTela*0.05),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextFormField(
                                  onChanged: (text) {
                                    print("First text field: $text");
                                  },
                                  controller: editorCursos[index]["cursoController"],
                                  decoration: InputDecoration(
                                      hintText: "Nome do Curso"
                                  ),
                                  onSaved: (String value) {
                                    print(editorCursos[index]["cursoController"].text);
                                  },
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextFormField(
                                  onChanged: (text) {
                                    print("First text field: $text");
                                  },
                                  controller: editorCursos[index]["instituicaoController"],
                                  decoration: InputDecoration(
                                      hintText: "Nome da Instituição"
                                  ),
                                  onSaved: (String value) {
                                    print(editorCursos[index]["instituicaoController"].text);
                                  },
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextFormField(
                                  controller: editorCursos[index]["statusController"],
                                  decoration: InputDecoration(
                                      hintText: "Status do curso"
                                  ),
                                  onSaved: (String value) {
                                    print('Value for field ');
                                  },
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextField(
                                  controller: editorCursos[index]["dataController"],
                                  decoration: InputDecoration(
                                      hintText: "Status do curso"
                                  ),
                                ),
                              ),
                            ]
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      color: color,
                      textColor: Colors.white,
                      onPressed: () {
                        for(int i=0; i < curriculo.listaCursos.length; i++){
                          setState(() {
                            curriculo.listaCursos[i].titulo = editorCursos[i]["cursoController"].text;
                            curriculo.listaCursos[i].instituicao = editorCursos[i]["instituicaoController"].text;
                            curriculo.listaCursos[i].status = editorCursos[i]["statusController"].text;
                            curriculo.listaCursos[i].data = editorCursos[i]["dataController"].text;
                          });
                        }
                        setState(() {
                          editmode_curs = !editmode_curs;
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
                ],
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
                  printmode?
                  Container()
                      :
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
                            color: color,
                            textColor: Colors.white,
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
                  printmode?
                  Container()
                      :
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
                            color: color,
                            textColor: Colors.white,
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
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: Icon(Icons.share, color: Colors.white,),
              onPressed: (){
                setState(() => printmode = !printmode);
              })
        ],
        title: Text(widget.title),
      ),
      body: Capturer(
          child: Column(
            children: corpoCurriculo,
          ),
          overRepaintKey: globalKey,
      ),
    );
  }
}


Widget listarTitulos(List<Titulo> titulos, double alturaTela, TextStyle conteudo){
  return ListView.builder(
    physics: ScrollPhysics(),
    shrinkWrap: true,
    itemCount: titulos.length,
    itemBuilder: (BuildContext context, int index){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: alturaTela * 0.1,
          child: Column(
            children: [
              Align(child: Text(titulos[index].titulo,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                alignment: Alignment.centerLeft,
              ),
              Align(child: Text(titulos[index].resumo, style: conteudo), alignment: Alignment.centerLeft,),
            ],
          ),
        ),
      );
    },
  );
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
              Align(child: Text(cursos[index].titulo,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                alignment: Alignment.centerLeft,
              ),
              Align(child: Text(cursos[index].instituicao, style: conteudo), alignment: Alignment.centerLeft,),
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