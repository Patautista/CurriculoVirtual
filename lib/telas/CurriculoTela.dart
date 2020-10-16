import 'dart:io';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:curriculo_virtual/service/Capturer.dart';
import 'package:curriculo_virtual/service/auth.dart';
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
  CurriculoTela({Key key, this.title, this.curriculo, this.uid}) : super(key: key);

  final String title;
  final String uid;
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
  bool editmode_nome = false;
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

    CurriculoObject c;

    //c = await fetchCurriculo(widget.uid);
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
        if(_image!=null){
          await _image.delete();
          imageCache.evict(FileImage(_image));
        }
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
        if(_image!=null){
          await _image.delete();
          imageCache.evict(FileImage(_image));
        }
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
  TextEditingController perfilController = new TextEditingController();
  TextEditingController nomeController = new TextEditingController();
  TextEditingController expertiseController = new TextEditingController();
  TextEditingController telefoneController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  TextEditingController cursoController = new TextEditingController();
  TextEditingController instituicaoController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController dataController = new TextEditingController();

  List<Map<String, TextEditingController>> editorCursos = [];
  List<Map<String, TextEditingController>> editorTitulos = [];

  void initState() {
    super.initState();

    curriculo = widget.curriculo;
    ///Testes.

    perfilController.text = curriculo.perfil;
    expertiseController.text = curriculo.informal;
    telefoneController.text = curriculo.telefone;
    emailController.text = curriculo.email;


    //Preparando os controladores de texto gerados dinamicamente para Cursos e Títulos.
    for(int i=0; i< curriculo.listaCursos.length; i++){
      var mapaControladoreCurso = {"cursoController": TextEditingController(),"instituicaoController": TextEditingController() ,
        "statusController": TextEditingController(), "dataController": TextEditingController()};

      mapaControladoreCurso["cursoController"].text = curriculo.listaCursos[i].titulo;
      mapaControladoreCurso["instituicaoController"].text = curriculo.listaCursos[i].instituicao;
      mapaControladoreCurso["statusController"].text = curriculo.listaCursos[i].status;
      mapaControladoreCurso["dataController"].text = curriculo.listaCursos[i].data;
      editorCursos.add(mapaControladoreCurso);
    }
    for(int i=0; i< curriculo.listaTitulos.length; i++){
      var mapaControladoreTitulo = {"tituloController": TextEditingController(),"resumoController": TextEditingController()};

      mapaControladoreTitulo["tituloController"].text = curriculo.listaTitulos[i].titulo;
      mapaControladoreTitulo["resumoController"].text = curriculo.listaTitulos[i].resumo;
      editorTitulos.add(mapaControladoreTitulo);
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
                        _image==null?
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              editmode_img = !editmode_img;
                            });
                          },
                          child: Container(child: Text("Cancelar", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold))),
                        )
                        :
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async{
                                await _image.delete();
                                imageCache.evict(FileImage(_image));
                                setState(() {
                                  editmode_img = !editmode_img;
                                });
                              },
                              child: Container(child: Text("Apagar", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold))),
                            ),
                            SizedBox(width: alturaTela*0.05,),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  editmode_img = !editmode_img;
                                });
                              },
                              child: Container(child: Text("Cancelar", style: TextStyle(fontSize: 16, color: Colors.red, fontWeight: FontWeight.bold))),
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        )
                      ],
                    )
                        :
                        printmode && _image==null?
                            SizedBox()
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
              editmode_nome?
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
                            controller: nomeController,
                            decoration: InputDecoration(
                                hintText: "Nome"
                            ),
                            onSaved: (String value) {
                              print(nomeController.text);
                            },
                          ),
                        ),
                        SizedBox(height: alturaTela*0.05),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                            color: color,
                            textColor: Colors.white,
                            onPressed: () {
                              // Validate returns true if the form is valid, or false
                              // otherwise.
                              setState(() {
                                curriculo.nome = nomeController.text;
                                editmode_nome = !editmode_nome;
                              });
                            },
                            child: Text('Salvar alterações'),
                          ),
                        ),
                      ]
                  ),
                ),
              )
                  :
              GestureDetector(
                onTap: (){
                  setState(() {
                    editmode_nome = !editmode_nome;
                  });
                },
                child: Text(
                  curriculo.nome,
                  style: nome,
                ),
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
                              for(int i=0; i < curriculo.listaTitulos.length; i++){
                                //Checa se algum dos campos está vazio.Se sim, então remove o elemento da lista e seus controladores.
                                if(editorTitulos[i]["tituloController"].text == "" || editorTitulos[i]["resumoController"].text == ""){
                                  setState(() {
                                    curriculo.listaTitulos.removeAt(i);
                                    editorTitulos.removeAt(i);
                                  });
                                }
                              }
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
                      itemCount: curriculo.listaTitulos.length,
                      itemBuilder: (BuildContext context, int index){
                        return Column(
                            children: [
                              SizedBox(height: alturaTela*0.03),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextFormField(
                                  onChanged: (text) {
                                    print("First text field: $text");
                                  },
                                  controller: editorTitulos[index]["tituloController"],
                                  decoration: InputDecoration(
                                      hintText: "Nome do Título"
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.13)),
                                child: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  onChanged: (text) {
                                    print("First text field: $text");
                                  },
                                  controller: editorTitulos[index]["resumoController"],
                                  decoration: InputDecoration(
                                      hintText: "Resumo"
                                  ),
                                ),
                              ),
                            ]
                        );
                      },
                    ),
                  ),
                  SizedBox(height: alturaTela*0.03,),
                  GestureDetector(
                    onTap: (){

                      var mapaControladoreTitulo = {"tituloController": TextEditingController(),"resumoController": TextEditingController()};

                      setState(() {
                        curriculo.listaTitulos.add(Titulo(titulo: "", resumo: ""));
                        editorTitulos.add(mapaControladoreTitulo);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                          height: alturaTela*0.1,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            children: [
                              Text("Novo título", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 16),),
                              Icon(Icons.add, color: Colors.blueGrey,)
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      color: color,
                      textColor: Colors.white,
                      onPressed: () {
                        for(int i=0; i < curriculo.listaTitulos.length; i++){
                          if(editorTitulos[i]["tituloController"].text == "" || editorTitulos[i]["resumoController"].text == ""){
                            setState(() {
                              curriculo.listaTitulos.removeAt(i);
                              editorTitulos.removeAt(i);
                            });
                          }
                          else{
                            setState(() {
                              curriculo.listaTitulos[i].titulo = editorTitulos[i]["tituloController"].text;
                              curriculo.listaTitulos[i].resumo = editorTitulos[i]["resumoController"].text;
                            });
                          }
                        }
                        setState(() {
                          editmode_titl = !editmode_titl;
                        });
                      },
                      child: Text('Salvar alterações'),
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
                          for(int i=0; i < curriculo.listaCursos.length; i++){
                            //Checa se algum dos campos está vazio.Se sim, então remove o elemento da lista e seus controladores.
                            if(editorCursos[i]["cursoController"].text == "" || editorCursos[i]["instituicaoController"].text == ""
                                || editorCursos[i]["statusController"].text == "" || editorCursos[i]["dataController"].text == ""){
                              setState(() {
                                curriculo.listaCursos.removeAt(i);
                                editorCursos.removeAt(i);
                              });
                            }
                          }
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
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextFormField(
                                  controller: editorCursos[index]["statusController"],
                                  decoration: InputDecoration(
                                      hintText: "Status do curso"
                                  ),
                                ),
                              ),
                              ConstrainedBox(
                                constraints: BoxConstraints.tight(Size(alturaTela*0.55, alturaTela*0.08)),
                                child: TextField(
                                  controller: editorCursos[index]["dataController"],
                                  decoration: InputDecoration(
                                      hintText: "Data de início"
                                  ),
                                ),
                              ),
                            ]
                        );
                      },
                    ),
                  ),
                  SizedBox(height: alturaTela*0.03,),
                  GestureDetector(
                    onTap: (){

                      var mapaControladoreCurso = {"cursoController": TextEditingController(),"instituicaoController": TextEditingController() ,
                        "statusController": TextEditingController(), "dataController": TextEditingController()};

                      setState(() {
                        curriculo.listaCursos.add(Curso(titulo: "", data: "", status: "", instituicao: ""));
                        editorCursos.add(mapaControladoreCurso);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                          height: alturaTela*0.1,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            children: [
                              Text("Novo curso", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 16),),
                              Icon(Icons.add, color: Colors.blueGrey,)
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: RaisedButton(
                      color: color,
                      textColor: Colors.white,
                      onPressed: () {
                        for(int i=0; i < curriculo.listaCursos.length; i++){
                          //Checa se algum dos campos está vazio.Se sim, então remove o elemento da lista e seus controladores.
                          if(editorCursos[i]["cursoController"].text == "" || editorCursos[i]["instituicaoController"].text == ""
                              || editorCursos[i]["statusController"].text == "" || editorCursos[i]["dataController"].text == ""){
                            setState(() {
                              curriculo.listaCursos.removeAt(i);
                              editorCursos.removeAt(i);
                            });
                          }
                          else{
                            setState(() {
                              curriculo.listaCursos[i].titulo = editorCursos[i]["cursoController"].text;
                              curriculo.listaCursos[i].instituicao = editorCursos[i]["instituicaoController"].text;
                              curriculo.listaCursos[i].status = editorCursos[i]["statusController"].text;
                              curriculo.listaCursos[i].data = editorCursos[i]["dataController"].text;
                            });
                          }
                        }
                        setState(() {
                          editmode_curs = !editmode_curs;
                        });
                      },
                      child: Text('Salvar alterações'),
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
                            },
                            child: Text('Salvar alterações'),
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
                              setState(() {
                                curriculo.telefone = telefoneController.text;
                                curriculo.email = emailController.text;
                                editmode_cont = !editmode_cont;
                              });
                            },
                            child: Text('Salvar alterações'),
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
              }),
          BackButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            }
          )
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