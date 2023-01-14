import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatefulWidget{
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingState();
}
class _LoadingState extends State<LoadingPage>{
  double increaser=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initF();
  }
  initF() async {
    final prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString('name');
    final String? username = prefs.getString('username');
    Timer.periodic(Duration(milliseconds:5), (loaderno) async {
      if(increaser<1) {
        setState(() {
          increaser += 0.003;
        });
      }
      else{
        loaderno.cancel();
        if(name!=null&&username!=null){
          await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
              MyHomePage(name: name, username: username)));
        }
        else{
          await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
              ProfilePage()));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Bluff();
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg/bg2.png"),
              fit: BoxFit.fill
          ),
        ),
        child: Container(
            padding: EdgeInsets.only(top: 40),
            alignment: Alignment.center,
            child: Column(
              children: [
                Image.asset("assets/logo/b2glarge.png"),
                Expanded(
                  child: Container(),
                ),
                Text(
                  'Loading',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                  ),
                ),
                Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width*0.4,
                  height: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: increaser,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xfff62525)),
                      backgroundColor: Color(0xffD6D6D6),
                    ),
                  ),
                ),
                Divider(),
                Text(
                  'Do you know! Vegas Casinos change decks more than you change your pants',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white
                  ),
                ),
                Divider(),

              ],
            )
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget{
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfileState();
}
class _ProfileState extends State<ProfilePage>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String usrname = '';
  TextEditingController nm = new TextEditingController();
  int a = (DateTime.now().millisecondsSinceEpoch/1000).round().remainder(100000);

  save() async {
    if(nm.text.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name',nm.text);
      await prefs.setString('username', usrname);
      await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          MyHomePage(name: nm.text, username: usrname)));
    }
  }

  Widget page(){
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.6,
      height: MediaQuery.of(context).size.height*0.8,
      child: Card(
        elevation: 10,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: TextField(
                controller: nm,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                onChanged: (String s){
                  if(s.isNotEmpty) {
                    setState(() {
                      usrname = s.toLowerCase().replaceAll(" ", "") + (a).toString();
                    });
                  }
                  else{
                    setState(() {
                      usrname = '';
                    });
                  }
                },
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: Text("your username",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              width: double.infinity,
              child: Text(
                usrname,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text(
                    "Save",
                  ),
                  onPressed: (){
                    save();
                  },
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/bg/bg1.png"),
              fit: BoxFit.fill
          ),
        ),
        alignment: Alignment.center,
        child: page(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.name, required this.username});
  final String name, username;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = widget.name;
    username  = widget.username;
  }

  String username = '', name = '';

  void ssd(String ss){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(ss),
        );
      },
    );
  }
  playFriends(){
    Navigator.push(context, MaterialPageRoute(builder: (context) =>
        MultiPlayPage(name: widget.name, username: widget.username)));
  }
  settings(){

  }
  howPlay(){

  }

  Widget uprLayer(){
    return Container(
      padding: EdgeInsets.only(top: 20,left: 20,right: 20),
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Image(
            image: AssetImage("assets/icons/avatar1.png"),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              // TODO change here
                widget.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                )
            ),
          ),
          Expanded(
              child: Container()
          ),
          Image(
              image: AssetImage("assets/logo/bluff2gathersmall.png")
          ),
        ],
      ),
    );
  }
  Widget butons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(2),
            child: SizedBox(
              child: ElevatedButton(
                child: Center(
                  child: Text(
                    "Play with Friends",
                    style: GoogleFonts.langar (
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        )
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  elevation: MaterialStateProperty.all(3),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black)
                  )),
                ),
                onPressed: playFriends,
              ),
              width: MediaQuery.of(context).size.width*0.2,
              height: MediaQuery.of(context).size.width*0.1,
            )
        ),
        Container(
            padding: EdgeInsets.all(2),
            child: SizedBox(
              child: ElevatedButton(
                child: Center(
                  child: Text(
                    "Setting",
                    style: GoogleFonts.langar (
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        )
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  elevation: MaterialStateProperty.all(3),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black)
                  )),
                ),
                onPressed: settings,
              ),
              width: MediaQuery.of(context).size.width*0.2,
              height: MediaQuery.of(context).size.width*0.1,
            )
        ),
        Container(
            padding: EdgeInsets.all(2),
            child: SizedBox(
              child: ElevatedButton(
                child: Center(
                  child: Text(
                    "How to Play",
                    style: GoogleFonts.langar (
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        )
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.orange),
                  elevation: MaterialStateProperty.all(3),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black)
                  )),
                ),
                onPressed: howPlay,
              ),
              width: MediaQuery.of(context).size.width*0.2,
              height: MediaQuery.of(context).size.width*0.1,
            )
        )
      ],
    );
  }
  Widget lowerLayer(){
    return Container(
      height: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg/bg1.png"),
                fit: BoxFit.fill
            ),
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                uprLayer(),
                butons(),
                lowerLayer()
              ],
            ),
          ),
        )
    );
  }
}

class MultiPlayPage extends StatefulWidget{
  const MultiPlayPage({super.key, required this.name, required this.username});
  final String name, username;

  @override
  State<MultiPlayPage> createState() => _MultiPlayState();
}
class _MultiPlayState extends State<MultiPlayPage>{

  start1(bool host){
    showDialog(context: context, builder: (BuildContext context){
      return AlertBox(host);
    });
  }
  start2(bool host, int i){
    if(host){
      advertise(i);
    }
    else{
      discover(i);
    }
  }
  advertise(int i){
    if(i==1){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          BluffPage(name: widget.name, username: widget.username, host: true,)));
    }
    if(i==2){

    }
  }
  discover(int i){
    if(i==1){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>
          BluffPage(name: widget.name, username: widget.username, host: false,)));
    }
    if(i==2){

    }
  }
  playonline(){

  }

  int gm_i = 0;
  Widget AlertBox(bool host){
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height*0.6,
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.red,
                  width: 1
              ),
              borderRadius: BorderRadius.circular(5)
          ),
          color: Color.fromRGBO(1, 1, 1, 0.7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.cancel_presentation_sharp,
                        color: Colors.red,
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  "Select Game to play",
                  style: GoogleFonts.langar(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.16,
                margin: EdgeInsets.only(bottom: 15),
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Card(
                          shape: false?RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 2
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ):null,
                          color: Colors.green,
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              start2(host, 1);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.height*0.35,
                                margin: EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    'Bluff',
                                    style: GoogleFonts.pacifico(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                            ),
                          )
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget uprLayer(){
    return Container(
      padding: EdgeInsets.only(top: 20,left: 20,right: 20),
      width: double.infinity,
      height: MediaQuery.of(context).size.height*0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Image(
            image: AssetImage("assets/icons/avatar1.png"),
          ),
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              // TODO change here
                widget.name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                )
            ),
          ),
          Expanded(
              child: Container()
          ),
          Image(
              image: AssetImage("assets/logo/bluff2gathersmall.png")
          ),
        ],
      ),
    );
  }
  Widget butons(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(2),
            child: SizedBox(
              child: ElevatedButton(
                  child: Center(
                    child: Text(
                      "Create Room",
                      style: GoogleFonts.langar (
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          )
                      ),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black)
                    )),
                  ),
                  onPressed: (){
                    start1(true);
                  }
              ),
              width: MediaQuery.of(context).size.width*0.2,
              height: MediaQuery.of(context).size.width*0.1,
            )
        ),
        Container(
            padding: EdgeInsets.all(2),
            child: SizedBox(
              child: ElevatedButton(
                child: Center(
                  child: Text(
                    "Join Room",
                    style: GoogleFonts.langar (
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        )
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                  elevation: MaterialStateProperty.all(3),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black)
                  )),
                ),
                onPressed: (){
                  start1(false);
                },
              ),
              width: MediaQuery.of(context).size.width*0.2,
              height: MediaQuery.of(context).size.width*0.1,
            )
        ),
        Container(
            padding: EdgeInsets.all(2),
            child: SizedBox(
              child: ElevatedButton(
                child: Center(
                  child: Text(
                    "Play Online",
                    style: GoogleFonts.langar (
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        )
                    ),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal),
                  elevation: MaterialStateProperty.all(3),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.black)
                  )),
                ),
                onPressed: playonline,
              ),
              width: MediaQuery.of(context).size.width*0.2,
              height: MediaQuery.of(context).size.width*0.1,
            )
        ),
      ],
    );
  }
  Widget lowerLayer(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 8,left: 10),
          child: IconButton(
            icon: Image.asset("assets/icons/back.png"),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        )
      ],
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg/bg1.png"),
                fit: BoxFit.fill
            ),
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                uprLayer(),
                butons(),
                lowerLayer()
              ],
            ),
          ),
        )
    );
  }
}

class BluffPage extends StatefulWidget{
  const BluffPage({super.key, required this.name, required this.username, required this.host});
  final String name, username;
  final bool host;

  @override
  State<BluffPage> createState() => _BluffState();
}
class _BluffState extends State<BluffPage> with WidgetsBindingObserver{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    name = widget.name;
    username = widget.username;
    if(widget.host){
      stts = 'Setting up room, please wait...';
      isloading = true;
      advertise();
    }
    else{
      stts = 'searching rooms...';
      isloading = true;
      discover();
    }
  }

  List<String> players = [];
  bool isloading = false, isinroom = false, gameStarted = false;
  String name='', username='', stts = '';
  final Strategy strategy = Strategy.P2P_STAR;
  Map<String, String> playerids = new Map();
  String serverid = '', serverName='';

  Widget uprLayer(){
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Color.fromRGBO(26, 4, 4, 1.0),
      ),
      child: Text("Room",
        style: GoogleFonts.righteous(
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20
            )
        ),
      ),
    );
  }
  Widget item(int i){
    return Card(
      margin: EdgeInsets.all(4),
      color: Colors.transparent,
      child: ListTile(
        title: Text(
          players[i],
          style: GoogleFonts.dosis(
              textStyle: TextStyle(
                color: Colors.white,
              )
          ),
        ),
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/icons/avatar2.png"),
        ),
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Colors.white,
                width: 1
            ),
            borderRadius: BorderRadius.circular(5)
        ),
      ),
    );
    return Container(
      child: Text(players[i]),
    );
  }
  Widget mainlayer(){
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Players",
                    style: GoogleFonts.righteous(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        )
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.4,
                    height: MediaQuery.of(context).size.height*0.65,
                    child: Card(
                      color: Color.fromRGBO(26, 4, 4, 1.0),
                      child: ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (BuildContext ctx, int i){
                          return item(i);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("\n",
                    style: GoogleFonts.righteous(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        )
                    ),
                  ),
                  Text(
                    "Bluff",
                    style: GoogleFonts.pacifico(
                        color: Colors.white,
                        fontSize: 25
                    ),
                  ),
                  Expanded(child: Container()),
                  Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    alignment: Alignment.center,
                    child: Text(stts,
                      style: GoogleFonts.righteous(
                          textStyle: TextStyle(
                              color: Color.fromRGBO(255, 221, 221, 1.0),
                              fontSize: 18
                          )
                      ),
                      maxLines: 4,
                    ),
                  ),
                  Divider()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget lowerLayer(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 8,left: 10),
          child: IconButton(
            icon: Image.asset("assets/icons/back.png"),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 8,left: 6),
          child: IconButton(
            icon: Image.asset("assets/icons/home.png"),
            onPressed: (){
              Navigator.of(context)..pop()..pop();
            },
          ),
        ),
        Expanded(child: Container()),
        Visibility(
          child: Container(
            padding: EdgeInsets.only(bottom: 8,right: 12),
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.13,
              width: MediaQuery.of(context).size.width*0.12,
              child: IconButton(
                icon: Image.asset(
                  "assets/icons/start.png",
                ),
                onPressed: (){
                  startBluff();
                },
              ),
            ),
          ),
          visible: widget.host,
        )

      ],
    );
  }
  Widget Room(){
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg/bg1.png"),
                fit: BoxFit.fill
            ),
          ),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                uprLayer(),
                mainlayer(),
                lowerLayer()
              ],
            ),
          ),
        )
    );
  }
  Widget loadingOnGameStart(){
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/bg/bg1.png"),
                fit: BoxFit.fill
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/bg/loading.gif',
                height: 140,
              ),
              Text(
                stts,
                style: GoogleFonts.kalam(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Divider(),
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text(
                'cancel',
                style: GoogleFonts.langar(
                  color: Colors.white,
                ),
              )
              )
            ],
          )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isloading){
      return loadingOnGameStart();
    }
    if(gameStarted){
      return Bluff();
    }
    return Room();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(widget.host){
      Nearby().stopAdvertising();
    }
    else{
      Nearby().stopDiscovery();
    }
  }

  Widget acceptConnectionDialogBox(String id, dynamic info){
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      color: Color.fromRGBO(1, 1, 1, 0.05),
      child: SizedBox(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height*0.5,
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.red,
                  width: 1
              ),
              borderRadius: BorderRadius.circular(5)
          ),
          color: Color.fromRGBO(1, 1, 1, 0.7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Text(
                  "Allow user to join your room ?",
                  style: GoogleFonts.langar(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.14,
                margin: EdgeInsets.only(bottom: 15),
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Reject button
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.red,
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.height*0.3,
                                child: Center(
                                  child: Text(
                                    'Reject',
                                    style: GoogleFonts.langar(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                            ),
                          )
                      ),
                      // Accept button
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero
                          ),
                          color: Colors.green,
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              acceptC(id, info);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.height*0.3,
                                margin: EdgeInsets.all(5),
                                child: Center(
                                  child: Text(
                                    'Accept',
                                    style: GoogleFonts.langar(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                            ),
                          )
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  advertise() async {
    bool a = await Nearby().checkLocationPermission();
    bool b = await Nearby().askLocationPermission();
    await Nearby().enableLocationServices();
    bool d = await Nearby().checkBluetoothPermission();
    Nearby().askBluetoothPermission();
    FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);

    try {
      bool a = await Nearby().startAdvertising(
        name,
        strategy,
        onConnectionInitiated: (String id,ConnectionInfo info) {
          if(!gameStarted) {
            initConnection(id, info);
          }
          // Called whenever a discoverer requests connection
        },
        onConnectionResult: (String id,Status status) {
          // Called when connection is accepted/rejected
        },
        onDisconnected: (String id) {
          setState(() {
            players.remove(id);
          });
          // Callled whenever a discoverer disconnects from advertiser
        },
        serviceId: 'com.carsd2gather', // uniquely identifies your app
      );
      setState(() {
        stts = 'Hosting with name $name.\nWaiting for others to join the room';
        players.add("$name (Host)");
        isloading = false;
      });

    } catch (exception) {
      setState(() {
        stts = 'Failed ${exception.toString()}';
      });
      // platform exceptions like unable to start bluetooth or insufficient permissions
    }
  }
  initConnection(String id,ConnectionInfo info) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return acceptConnectionDialogBox(id, info);
      },
    );
  }

  Widget joinConnectionDialogBox(String id, String userName){
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      color: Color.fromRGBO(1, 1, 1, 0.05),
      child: SizedBox(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height*0.5,
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.red,
                  width: 1
              ),
              borderRadius: BorderRadius.circular(5)
          ),
          color: Color.fromRGBO(1, 1, 1, 0.7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(15),
                child: Text(
                  "Join to $userName's room ?",
                  style: GoogleFonts.langar(
                      color: Colors.white,
                      fontSize: 20
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height*0.14,
                margin: EdgeInsets.only(bottom: 15),
                child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [

                      // Reject button
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          color: Colors.red,
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.height*0.3,
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.langar(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                )
                            ),
                          )
                      ),

                      // Accept button
                      Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero
                          ),
                          color: Colors.green,
                          child: Container(
                            width: MediaQuery.of(context).size.height*0.3,
                            child: InkWell(
                              onTap: (){
                                Nearby().stopDiscovery();
                                Navigator.pop(context);
                                serverName=userName;
                                Nearby().requestConnection(
                                  userName,
                                  id,
                                  onConnectionInitiated: (id, info) {
                                    acceptC(id, info);
                                  },
                                  onConnectionResult: (id, status) {
                                    if(status==Status.CONNECTED){
                                      setState(() {
                                        isinroom = true;
                                        isloading = false;
                                        serverid = id;
                                        playerids.clear();
                                        playerids[serverName] = serverid;
                                        stts = 'Connected to $serverName\nwaiting for host to start game';
                                      });
                                      sendM(serverid, {'name':name});
                                    }
                                  },
                                  onDisconnected: (id) {

                                  },
                                );
                              },
                              child: Container(
                                  width: MediaQuery.of(context).size.height*0.5,
                                  margin: EdgeInsets.all(5),
                                  child: Center(
                                    child: Text(
                                      'Join',
                                      style: GoogleFonts.langar(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  )
                              ),
                            ),
                          )
                      ),
                    ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  discover() async {
    bool a = await Nearby().checkLocationPermission();
    bool b = await Nearby().askLocationPermission();
    await Nearby().enableLocationServices();
    bool d = await Nearby().checkBluetoothPermission();
    Nearby().askBluetoothPermission();
    FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);

    try {
      bool a = await Nearby().startDiscovery(
        name,
        strategy,
        onEndpointFound: (String id,String userName, String serviceId) {
          if(!isinroom) {
            askConnection(id, userName);
          }
        },
        onEndpointLost: (String? id) {
          //called when an advertiser is lost (only if we weren't connected to it )
        },
        serviceId: "com.carsd2gather", // uniquely identifies your app
      );
    } catch (e) {
      // platform exceptions like unable to start bluetooth or insufficient permissions
    }
  }
  askConnection(String id,String userName){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return joinConnectionDialogBox(id, userName);
      },
    );
  }

  acceptC(String id,ConnectionInfo info){
    FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          String str = String.fromCharCodes(payload.bytes!);
          Map<String, dynamic> mp = new Map();
          try{
            mp = jsonDecode(str);
          }
          catch(e){
            mp = Map();
          }
          print('RECEIVED ==> ');
          print(mp);
          if(mp.containsKey('name')){
            playerids[mp['name']] = endid;
            setState(() {
              players.add(mp['name']);
            });
            playerids.forEach((key, value) {
              if(value!=endid) {
                sendM(value, {'newPlayer': mp['name']});
              }
            });
            players.forEach((element) {
              sendM(endid, {'newPlayer':element});
            });
          }
          if(mp.containsKey('newPlayer')){
            setState(() {
              players.add(mp['newPlayer']);
            });
          }
          if(mp.containsKey('start')){
            startBluff();
          }

          if(mp.containsKey('cardadd')){
            sendCardTo('', mp['cardadd'], true);
          }
          if(mp.containsKey('newStart')){
            setState(() {
              newStart = mp['newStart'];
              if(newStart) msg = '';
            });
            if(centerCP){
              animateTCards2(true);
              setState(() {
                centerCP = false;
              });
            }
          }
          if(mp.containsKey('bluffed')){
            if(turn==name) animateTCards(true);
            else           animateTCards(false);
            bluffed.clear();
            bluffed.addAll(jsonDecode(mp['bluffed']));
            setState(() {
              _task = 'bluff';
              msg = 'claimed ${bluffed.length} cards of series ${bluffSeries}';
            });
          }
          if(mp.containsKey('turn')){
            setState(() {
              _user = turn;
              turn = mp['turn'];
              tt = true;
            });
            checkIFwin();
          }
          if(mp.containsKey('series')){
            passC=0;
            setState(() {
              bluffSeries = mp['series'];
            });
          }
          if(mp.containsKey('pass')){
            setState(() {
              _task = 'pass';
            });
          }
          if(mp.containsKey('open')){
            setState((){
              _task = 'open';
              _user = turn;
              opened = true;
              centerCP = false;
              msg = '$turn opened ${mp['open']}\'s cards';
              if(turn==name||turn=='$name (Host)'){
                msg=msg.replaceAll(turn, 'you');
              }
              if(mp['open']==name||mp['open']=='$name (Host)'){
                msg = msg.replaceAll('${mp['open']}\'s', 'your');
              }
            });
          }
          if(mp.containsKey('opened')){
            setState(() {
              opened = false;
              msg = '$turn made it!';
              if(mp['opened']){
                msg = '$turn bust!!';
              }
              if(turn==name||turn=='$name (Host)'){
                msg = msg.replaceAll(turn, 'you');
              }
              centerCP = false;
            });
          }
          if(mp.containsKey('quantity')){
            setState(() {
              quantity = jsonDecode(mp['quantity']);
            });
          }
          if(mp.containsKey('finished')){
            winners.clear();
            winners = mp['finished'];
            finishGame();
          }

          if(mp.containsKey('passC')){
            pass_Host(mp['passC']);
          }
          if(mp.containsKey('bluffedH')){
            animateTCards(false);
            bluffed.clear();
            bluffed.addAll(jsonDecode(mp['bluffedH']));
            bluff_Host();
          }
          if(mp.containsKey('seriesH')){
            setState(() {
              bluffSeries = mp['seriesH'];
              newStart = false;
            });
            playerids.forEach((key, value) {
              sendM(value, {'series':bluffSeries,'newStart':newStart});
            });
          }
          if(mp.containsKey('openH')){
            open_Host();
          }
        }
      },
    );
  }
  sendM(String id, Map<String, dynamic> mp){
    print('SENT ==>');
    print(mp);
    Nearby().sendBytesPayload(id, Uint8List.fromList(jsonEncode(mp).codeUnits));
  }
  void ssd(String ss){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(ss),
        );
      },
    );
  }

  startBluff(){
    FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    if(widget.host) {
      playerids.forEach((key, value) {
        sendM(value, {'start': 'bluff'});
      });
    }
    setState(() {
      isloading = true;
      stts = 'starting game..';
    });
    Future.delayed(const Duration(milliseconds: 1000), () async {
      setState(() {
        isloading = false;
        gameStarted = true;
        stts = '';
      });
      if(widget.host){
        host_shuffle();
      }
    });
  }

  List<String> allCards = [
    'clubs_2.png','clubs_3.png','clubs_4.png','clubs_5.png','clubs_6.png','clubs_7.png','clubs_8.png','clubs_9.png',
    'clubs_10.png','clubs_ace.png','clubs_jack.png','clubs_king.png','clubs_queen.png',
    'diamonds_2.png','diamonds_3.png','diamonds_4.png','diamonds_5.png','diamonds_6.png','diamonds_7.png','diamonds_8.png','diamonds_9.png',
    'diamonds_10.png','diamonds_ace.png','diamonds_jack.png','diamonds_king.png','diamonds_queen.png',
    'hearts_2.png','hearts_3.png','hearts_4.png','hearts_5.png','hearts_6.png','hearts_7.png','hearts_8.png','hearts_9.png',
    'hearts_10.png','hearts_ace.png','hearts_jack.png','hearts_king.png','hearts_queen.png',
    'spades_2.png','spades_3.png','spades_4.png','spades_5.png','spades_6.png','spades_7.png','spades_8.png','spades_9.png',
    'spades_10.png','spades_ace.png','spades_jack.png','spades_king.png','spades_queen.png',
  ];

  bool centerCards = false, sideCards = false, centerCards2= false, centerCP = false, sideCP = false;

  List<String> cards = ['',''];
  Map<String,bool> selected = {};
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  String turn = '';
  int trn = 0, newS = 0;
  bool newStart = false;
  List<String> series = ['','A','2','3','4','5','6','7','8','9','10','J','Q','K',''];
  String bluffSeries = '', msg = '', _user = '';
  int passC = 0;
  bool tt = false;
  Map<String, dynamic> quantity = {};
  List<dynamic> winners = [];

  bool opened = false;
  String _task = '';
  String preBluffed = '';
  List<String> allBluffedC = [];
  Map<String, dynamic> bluffed = Map();

  animateTCards(bool c){
    // print("OKOK");
    setState(() {
      if(c){
        centerCards = true;
      }
      else{
        centerCards2= true;
      }
    });
    Future.delayed(Duration(seconds: 1), (){
      setState(() {
        centerCP = true;
        if(c) centerCards = false;
        else  centerCards2= false;
      });
    });
    // setState((){
    //   centerCards = !centerCards;
    // });
  }
  animateTCards2(bool c){
    setState(() {
      centerCP = false;
      sideCards = true;
    });
    Future.delayed(Duration(seconds: 1), (){
      setState(() {
        sideCP = true;
        sideCards = false;
      });
    });
  }
  nxt(bool b) {
    setState(() {
      stts = '';
    });
    setState(() {
      tt = true;
    });
    playerids.forEach((key, value) {
      sendM(value, {'turn':players[trn], 'newStart':b});
    });
    setState((){
      turn = players[trn];
      newStart=b;
    });
    trn++;
    if(trn>=players.length) trn = 0;
  }
  host_shuffle() async {
    allCards.shuffle();
    setState(() {
      stts = 'distributing cards...';
    });
    int i=0;
    await Timer.periodic(Duration(milliseconds: 100), (timer) {
      playerids.forEach((key, value) {
        if(i>=52) {
          i=-1;
          timer.cancel();
          nxt(true);
        }
        else {
          sendCardTo(value, allCards[i], false);
          i++;
        }
      });
      if(i>=0) {
        if (i >= 52) {
          i=-1;
          timer.cancel();
          nxt(true);
        }
        else {
          setState(() {
            sendCardTo('value', allCards[i], true);
            i++;
          });
        }
      }
    });
  }
  bluff_open(){
    if(!newStart){
      setState(() {
        tt = false;
      });
      if(widget.host){
        open_Host();
      }
      else{
        sendM(serverid, {'openH':true});
      }
    }
  }
  bluff_bluff(){
    int c = 0;
    bluffed = Map();
    bluffed.clear();
    selected.forEach((key, value) {
      if(value){
        bluffed[key] = value;
        c++;
      }
    });
    if(c>0){
      if(newStart){
        showDialog(context: context, builder: (BuildContext ctx){
          return BluffBox1();
        });
      }
      else {
        selected.forEach((key, value) {
          if(value){
            removeItem(key);
          }
        });
        bluff_Bluff1();
      }
    }
  }
  bluff_Bluff1(){
    setState(() {
      tt = false;
    });
    if(widget.host){
      animateTCards(true);
      bluff_Host();
    }
    else{
      Map<String, dynamic> msp = Map();
      msp['bluffedH'] = jsonEncode(bluffed);
      playerids.forEach((key, value) {
        sendM(value, msp);
      });
    }
    if(cards.isEmpty){
      setState(() {
        stts = 'you finished your cards, let\'s see others';
      });
    }
  }
  bluff_pass(){
    if(!newStart) {
      setState(() {
        tt = false;
      });
      if (widget.host) {
        pass_Host(true);
      }
      else {
        Map<String, dynamic> mmp = new Map();
        mmp['passC'] = true;
        playerids.forEach((key, value) {
          sendM(value, mmp);
        });
      }
    }
  }
  checkIFwin(){
    if(cards.length<=2&&(turn==name||turn=='$name (Host)')) {
      if (widget.host) {
        pass_Host(false);
      }
      else {
        sendM(serverid, {'passC': true});
      }
    }
  }
  checkIFFinish(bool b){
    int i = 0;
    quantity.values.forEach((element) {
      if (element > 0) i++;
    });
    return i;
    // if (i <= 1) {
    //   finishGame();
    // }
  }
  Widget finishBox(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      color: Color.fromRGBO(255, 255, 255, 0.05),
      child: SizedBox(
        width: MediaQuery.of(context).size.height,
        height: MediaQuery.of(context).size.height*0.9,
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Colors.red,
                    width: 1
                ),
                borderRadius: BorderRadius.circular(5)
            ),
            color: Color.fromRGBO(1, 1, 1, 0.7),
            child: Column(

              children: [

                Container(
                  height: MediaQuery.of(context).size.height*0.15,
                  alignment: Alignment.center,
                  child: Text(
                    'Winners ',
                    style: GoogleFonts.langar(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                        )
                    ),
                  ),
                ),
                Expanded(
                  // height: MediaQuery.of(context).size.height*0.5,
                  // color: Colors.blue,
                  child: ListView.builder(
                    itemCount: winners.length,
                    itemBuilder: (BuildContext btx, int i){
                      return Card(
                        margin: EdgeInsets.all(2),
                        color: Colors.transparent,
                        child: ListTile(
                          title: Text(
                            winners[i],
                            style: GoogleFonts.langar(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                )
                            ),
                          ),
                          leading: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.height*0.1,
                            child: Text(
                              (i+1).toString(),
                              style: GoogleFonts.langar(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18
                                  )
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.white,
                                  width: 1
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  height: MediaQuery.of(context).size.height*0.15,
                  alignment: Alignment.center,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                      ),
                      color: Colors.blue,
                      child: InkWell(
                        onTap: (){
                          Navigator.pop(context);
                          setState(() {
                            isloading = true;
                            stts  = 'loading...';
                          });
                          cards = [];
                          winners = [];
                          Future.delayed(Duration(seconds: 2),(){
                            setState(() {
                              if(!widget.host) stts = 'waiting to restart game...';
                              else             stts = 'play again';
                              isloading = false;
                              gameStarted = false;
                            });
                          });
                        },
                        child: Container(
                            child: Center(
                              child: Text(
                                'OK',
                                style: GoogleFonts.langar(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            )
                        ),
                      )
                  ),
                ),
              ],
            )
        ),
      ),
    );
  }
  finishGame(){
    if(widget.host){
      playerids.forEach((key, value) {
        sendM(value, {'finished':winners});
      });
    }
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return finishBox();
        }
    );
  }

  sendCardTo(String id, String e, bool host){
    if(!host) {
      sendM(id, {'cardadd': e});
    }
    else{
      addItem(e);
    }
    if(widget.host){
      String p = players[0];
      if(!host){
        playerids.forEach((key, value) {
          if(value==id) p = key;
        });
      }
      if(quantity.containsKey(p))
        quantity[p]++;
      else
        quantity[p] = 1;
      playerids.forEach((key, value) {
        sendM(value, {'quantity':jsonEncode(quantity)});
      });
      setState(() {});
      quantity.forEach((key, value) {
        if(value>0){
          winners.remove(key);
        }
        else if(!winners.contains(key)){
          winners.add(key);
        }
      });
    }
  }
  pass_Host(bool b){
    if(checkIFFinish(true)<=1){
      finishGame();
      return;
    }
    Map<String, dynamic> mmp = {};
    passC++;
    print('passCC $passC ${players.length}');
    if(passC==players.length){
      print('okokokookk $passC');
      // TODO clean table here
      animateTCards2(true);
      passC=0;
      newS = (newS+1)%players.length;
      trn = newS;
      mmp['newStart'] = true;
      newStart = true;
      allBluffedC = [];
      bluffed = {};
    }
    setState(() {
      _user = turn;
      _task = 'pass';
      turn = players[trn];
      tt = true;
    });
    mmp['turn'] = players[trn];
    mmp['pass'] = true;
    trn = (trn+1)%players.length;
    playerids.forEach((key, value) {
      sendM(value, mmp);
    });
    checkIFwin();
  }
  bluff_Host(){
    if(checkIFFinish(true)<=1){
      finishGame();
      return;
    }
    allBluffedC.addAll(bluffed.keys);
    preBluffed = turn;
    passC = 0;
    Map<String, dynamic> msp = Map();
    msp['bluffed'] = jsonEncode(bluffed);
    msp['turn'] = players[trn];
    setState(() {
      quantity[turn] = quantity[turn]-bluffed.length;
      if(quantity[turn]==0){
        if(!winners.contains(turn)){
          winners.add(turn);
        }
      }
      tt = true;
      _user = turn;
      _task = 'bluff';
      turn = players[trn];
      trn = (trn+1)%players.length;
      msg = 'claimed ${bluffed.length} cards of series ${bluffSeries}';
    });
    msp['quantity'] = jsonEncode(quantity);
    playerids.forEach((key, value) {
      sendM(value, msp);
    });
    checkIFwin();
  }
  open_Host(){
    print(allBluffedC);
    print(bluffed);
    passC=0;
    setState((){
      centerCP = false;
      _task = 'open';
      _user = turn;
      opened = true;
      msg = '$turn opened ${preBluffed}\'s cards';
      if(turn==name||turn=='$name (Host)'){
        msg = msg.replaceAll(turn, 'you');
      }
      if(preBluffed==name||preBluffed=='$name (Host)'){
        msg = msg.replaceAll('$preBluffed\'s', 'your');
      }
    });
    playerids.forEach((key, value) {
      sendM(value, {'open':preBluffed});
    });
    bool g = true;
    bluffed.forEach((key, value) {
      switch (bluffSeries){
        case 'A':
          if(!key.contains('ace')){
            g = false;
          }
          break;

        case 'Q':
          if(!key.contains('queen')){
            g = false;
          }
          break;

        case 'K':
          if(!key.contains('king')){
            g = false;
          }
          break;

        case 'J':
          if(!key.contains('jack')){
            g = false;
          }
          break;

        default:
          if(!key.contains(bluffSeries)){
            g = false;
          }
          break;
      }
    });

    Future.delayed(Duration(seconds: 4),(){
      setState(() {
        opened = false;
        msg = '$turn made it!';
        if(g){
          msg = '$turn bust!!';
        }
        if(turn==name||turn=='$name (Host)'){
          msg = msg.replaceAll(turn, 'you');
        }
      });
      playerids.forEach((key, value) {
        sendM(value, {'opened':g});
      });
    });

    Future.delayed(Duration(seconds: 5),(){
      if(!g){
        if(preBluffed==name||preBluffed=='$name (Host)'){
          allBluffedC.forEach((element) {
            sendCardTo('', element, true);
          });
        }
        else{
          allBluffedC.forEach((element) {
            sendCardTo(playerids[preBluffed]! ,element, false);

          });
        }
      }
      else{
        if(turn==name||turn=='$name (Host)'){
          allBluffedC.forEach((element) {
            sendCardTo('' ,element, true);
          });
        }
        else{
          allBluffedC.forEach((element) {
            sendCardTo(playerids[turn]! ,element, false);
          });
        }
      }
      Map<String, dynamic> mhm = {};
      setState(() {
        print(preBluffed+" || "+turn);
        newStart = true;
        mhm['newStart'] = true;
        allBluffedC = [];
        bluffed = {};
        msg = '';
        tt = true;
        if(g){
          trn = players.indexOf(preBluffed);
          turn = preBluffed;
          newS = trn;
          trn = (trn+1)%players.length;
        }
      });
      mhm['turn'] = turn;
      playerids.forEach((key, value) {
        sendM(value, mhm);
      });
      checkIFwin();
      if(checkIFFinish(true)<=1){
        finishGame();
        return;
      }
    });
  }

  addItem(String element){
    selected[element]=false;
    cards.insert(1, element);
    listKey.currentState!.insertItem(0, duration: const Duration(milliseconds: 300));
  }
  removeItem(String e){
    int i = cards.indexOf(e);
    listKey.currentState!.removeItem(i, (context, animation){
      return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -4),
            end: Offset(0, 0),
          ).animate(animation),
          child: Container(
            child: Image.asset(
              "assets/cards/${cards[i]}",
            ),
          )
      );
    }, duration: const Duration(milliseconds: 1000));
    Future.delayed(const Duration(milliseconds: 1001), () async {
      selected.remove(e);
      cards.remove(e);
    });
  }

  Widget BluffBox1(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: Color.fromRGBO(1, 1, 1, 0.05),
      child: SizedBox(
        width: MediaQuery.of(context).size.height*1.3,
        height: MediaQuery.of(context).size.height*0.5,
        child: Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.red,
                  width: 1
              ),
              borderRadius: BorderRadius.circular(5)
          ),
          color: Color.fromRGBO(1, 1, 1, 0.6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Select series of cards...',
                style: GoogleFonts.langar(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.height*9,
                height: MediaQuery.of(context).size.height*0.2,
                alignment: Alignment.center,
                child: ShaderMask(
                  shaderCallback: (Rect rect){
                    return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.purple,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.purple,
                        ],
                        stops: [
                          0.0,
                          0.20,
                          0.80,
                          1
                        ]
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.dstOut,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: series.length,
                    itemBuilder: (BuildContext ctx, int i){
                      if(series[i]==''){
                        return Container(
                          margin: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.height*0.15,
                          height: MediaQuery.of(context).size.height*0.15,
                          child: Text(" "),
                        );
                      }
                      return Container(
                        margin: EdgeInsets.all(5),
                        width: MediaQuery.of(context).size.height*0.15,
                        height: MediaQuery.of(context).size.height*0.15,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom( //<-- SEE HERE
                              side: BorderSide(width: 3.0, color: Color.fromRGBO(
                                  255, 220, 220, 1.0)),
                              backgroundColor: Colors.transparent
                          ),
                          onPressed: (){

                            Navigator.of(context).pop();
                            selected.forEach((key, value) {
                              if(value){
                                removeItem(key);
                              }
                            });
                            Map<String, dynamic> msp = Map();
                            if(widget.host){
                              msp['series'] = series[i];
                              msp['newStart'] = false;
                              setState(() {
                                newStart = false;
                                bluffSeries = series[i];
                              });
                            }
                            else{
                              msp['seriesH'] = series[i];
                            }
                            playerids.forEach((key, value) {
                              sendM(value, msp);
                            });
                            bluff_Bluff1();
                          },
                          child: Text(
                            series[i],
                            style: GoogleFonts.permanentMarker(
                              color: Colors.white,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget Bluff(){
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg/bg1.png"),
                  fit: BoxFit.fill
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height*0.22),
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/bg/bg3.png',
              height: MediaQuery.of(context).size.height*0.6,
            ),
          ),
          // buttons and cards
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: (turn==name||turn=='$name (Host)')&&tt,
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          child: SizedBox(
                            child: IconButton(
                              onPressed: (){
                                bluff_open();
                              },
                              icon: Image.asset(
                                "assets/icons/open.png",
                              ),
                            ),
                            width: MediaQuery.of(context).size.width*0.15,
                            height: MediaQuery.of(context).size.width*0.08,
                          )
                      ),
                      Container(
                          child: SizedBox(
                            child: IconButton(
                              onPressed: (){
                                bluff_bluff();
                              },
                              icon: Image.asset("assets/icons/bluff.png"),
                            ),
                            width: MediaQuery.of(context).size.width*0.15,
                            height: MediaQuery.of(context).size.width*0.08,
                          )
                      ),
                      Container(
                          child: SizedBox(
                            child: IconButton(
                              onPressed: (){
                                bluff_pass();
                              },
                              icon: Image.asset("assets/icons/pass.png"),
                            ),
                            width: MediaQuery.of(context).size.width*0.15,
                            height: MediaQuery.of(context).size.width*0.08,
                          )
                      ),
                    ],
                  ),
                ),
                // Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Image.asset('assets/icons/smili.png'),
                      padding: EdgeInsets.only(left: 10,bottom: 10,right: 10),
                      height: MediaQuery.of(context).size.height*0.2,
                      width: MediaQuery.of(context).size.height*0.3,
                      alignment: Alignment.center,
                    ),
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.24,
                        padding: EdgeInsets.only(left: 10,right: 10,bottom: 5),
                        child:ShaderMask(
                          shaderCallback: (Rect rect){
                            return LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Colors.purple,
                                  Colors.transparent,
                                  Colors.transparent,
                                  Colors.purple,
                                ],
                                stops: [
                                  0.0,
                                  0.20,
                                  0.80,
                                  1
                                ]
                            ).createShader(rect);
                          },
                          blendMode: BlendMode.dstOut,
                          child: AnimatedList(
                            key: listKey,
                            scrollDirection: Axis.horizontal,
                            initialItemCount: 2,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext ctx, int i, animation){
                              if(cards[i]==''){
                                print("BLANK $i");
                                return Container(
                                  width: MediaQuery.of(context).size.height*0.25,
                                );
                              }
                              return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(0, -3),
                                    end: Offset(0, 0),
                                  ).animate(animation),
                                  child: Container(
                                    margin: EdgeInsets.only(left: 2,bottom: selected[cards[i]]!?0:3,top: selected[cards[i]]!?0:10),
                                    child: GestureDetector(
                                      child: Image.asset(
                                        "assets/cards/${cards[i]}",
                                      ),
                                      onTap: (){
                                        setState(() {
                                          selected[cards[i]]=selected[cards[i]]!?false:true;
                                        });
                                      },
                                    ),
                                  )
                              );

                            },
                          ),
                        ) ,
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: name==turn.split(' ')[0]?BoxDecoration(
                              border: Border.all(color: Colors.brown, width: 2),
                              borderRadius: BorderRadius.circular(6),
                              color: Color.fromRGBO(0, 0, 0, 0.35)
                          ):null,
                          child: Image.asset('assets/icons/avatar1.png'),
                          padding: EdgeInsets.all(10),
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.height*0.3,
                          alignment: Alignment.center,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height*0.2,
                          width: MediaQuery.of(context).size.height*0.2,
                          alignment: Alignment.bottomRight,
                          padding: EdgeInsets.all(3),
                          // color: Colors.blue,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromRGBO(254, 255, 232, 1),
                            ),
                            padding: EdgeInsets.all(3),
                            child: Text(
                              widget.host?quantity[players[0]].toString():quantity[name].toString(),
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          //   ],
                          // )
                        )
                      ],
                    )

                  ],
                )
              ],
            ),
          ),
          // players and avatar
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.23,
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 2, left: 8, right: 8),
            // height: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height*0.3,
                  child: IconButton(
                    icon: Image.asset(
                      "assets/icons/back.png",
                    ),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width*0.8,
                      minWidth: MediaQuery.of(context).size.width*0.2,
                    ),
                    height: MediaQuery.of(context).size.height*0.3,
                    child: Center(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: players.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext ctx, int i){
                          if(players[i]=="$name (Host)"||players[i]==name){
                            return Container();
                          }
                          return Container(
                            decoration: players[i]==turn?BoxDecoration(
                                border: Border.all(color: Colors.brown, width: 2),
                                borderRadius: BorderRadius.circular(6),
                                color: Color.fromRGBO(0, 0, 0, 0.35)
                            ):null,
                            height: MediaQuery.of(context).size.height*0.25,
                            width: MediaQuery.of(context).size.height*0.25,
                            alignment: Alignment.center,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height*0.11,
                                      width: MediaQuery.of(context).size.height*0.13,
                                      child: Image.asset("assets/icons/avatar1.png"),
                                    ),
                                    Text(
                                      players[i],
                                      style: GoogleFonts.langar(
                                          color: Colors.white,
                                          fontWeight: players[i]==turn?FontWeight.bold:FontWeight.normal,
                                          fontSize: 12
                                      ),
                                    ),
                                    Visibility(
                                      visible: (players[i]==_user)&&(quantity[players[i]]>0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.height*0.13,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: Colors.white
                                        ),
                                        child: Center(
                                          child: Text(
                                            _task,
                                            style: GoogleFonts.langar(
                                                color: Colors.black,
                                                backgroundColor: Colors.white,
                                                fontWeight: players[i]==turn?FontWeight.bold:FontWeight.normal,
                                                fontSize: 10
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height*0.22,
                                  width: MediaQuery.of(context).size.height*0.22,
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(right: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color.fromRGBO(254, 255, 232, 1),
                                    ),
                                    padding: EdgeInsets.all(3),
                                    child: Text(
                                      quantity[players[i]].toString(),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                  //   ],
                                  // )
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    )
                ),
                Divider(),
                Divider()
              ],
            ),
          ),
          // game status
          Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Text(
                stts,
                style: GoogleFonts.langar(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                    fontSize: 18
                ),
              )
          ),
          // game state    msg
          Visibility(
            visible: msg.isNotEmpty,
            child: Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.2),
                child: Container(
                  padding: EdgeInsets.all(7),
                  // width: MediaQuery.of(context).size.width*0.22,
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width*0.2
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color.fromRGBO(245, 241, 225, 1.0)
                  ),
                  child: Text(
                    msg,
                    style: GoogleFonts.langar(
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                  ),
                )
            ),
          ),
          // listview on card open
          Visibility(
            visible: opened,
            child: Container(
              height: MediaQuery.of(context).size.height*0.3,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.3, bottom: MediaQuery.of(context).size.height*0.3,
                  right: MediaQuery.of(context).size.height*0.44,
                  left: MediaQuery.of(context).size.height*0.44),
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(78, 44, 44, 0.5019607843137255)
              ),
              child: ListView.builder(
                itemCount: bluffed.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (BuildContext ctx, int i){
                  return Container(
                    margin: EdgeInsets.only(left: 6,bottom: 3,top: 2),
                    height: MediaQuery.of(context).size.height*0.4,
                    child: GestureDetector(
                      child: Image.asset(
                        "assets/cards/${bluffed.keys.toList()[i]}",
                        height: MediaQuery.of(context).size.height*0.4,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // animated cards

          Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.5, right: MediaQuery.of(context).size.height*0.5,
                  top: MediaQuery.of(context).size.height*0.3,
                  bottom: MediaQuery.of(context).size.height*0.3),
              child: Visibility(
                visible: centerCP,
                child: Image.asset(
                  'assets/cards/bg.png',
                  height: MediaQuery.of(context).size.height*0.2,
                ),
              )
          ),
          Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.5, right: MediaQuery.of(context).size.height*0.5,
                  top: MediaQuery.of(context).size.height*0.3,
                  bottom: MediaQuery.of(context).size.height*0.3),
              child: Visibility(
                visible: sideCP,
                child: Image.asset(
                  'assets/cards/bg.png',
                  height: MediaQuery.of(context).size.height*0.2,
                ),
              )
          ),
          AnimatedContainer(
              width: double.infinity,
              height: double.infinity,
              alignment: centerCards?Alignment.center:Alignment.bottomCenter,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.5, right: MediaQuery.of(context).size.height*0.5,
                  top: MediaQuery.of(context).size.height*0.3,
                  bottom: MediaQuery.of(context).size.height*0.3),
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: Visibility(
                visible: centerCards,
                child: Image.asset(
                  'assets/cards/bg.png',
                  height: MediaQuery.of(context).size.height*0.2,
                ),
              )
          ),
          AnimatedContainer(
              width: double.infinity,
              height: double.infinity,
              alignment: centerCards2?Alignment.center:Alignment.topCenter,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.5, right: MediaQuery.of(context).size.height*0.5,
                  top: MediaQuery.of(context).size.height*0.3,
                  bottom: MediaQuery.of(context).size.height*0.3),
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: Visibility(
                visible: centerCards2,
                child: Image.asset(
                  'assets/cards/bg.png',
                  height: MediaQuery.of(context).size.height*0.2,
                ),
              )
          ),
          AnimatedContainer(
              width: double.infinity,
              height: double.infinity,
              alignment: !sideCards?Alignment.center:Alignment.centerLeft,
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.height*0.5, right: MediaQuery.of(context).size.height*0.5,
                  top: MediaQuery.of(context).size.height*0.3,
                  bottom: MediaQuery.of(context).size.height*0.3),
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              child: Visibility(
                visible: sideCards,
                child: Image.asset(
                  'assets/cards/bg.png',
                  height: MediaQuery.of(context).size.height*0.2,
                ),
              )
          ),
        ],
      ),
    );
  }
}
