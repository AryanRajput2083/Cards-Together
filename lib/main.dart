import 'dart:async';

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
    // if(widget.host){
    //   stts = 'Setting up room, please wait...';
    //   isloading = true;
    //   advertise();
    // }
    // else{
    //   stts = 'searching rooms...';
    //   isloading = true;
    //   discover();
    // }
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
      // return Bluff();
    }
    return Room();
  }


  startBluff(){
    FullScreen.enterFullScreen(FullScreenMode.EMERSIVE_STICKY);
    // if(widget.host) {
    //   playerids.forEach((key, value) {
    //     sendM(value, {'start': 'bluff'});
    //   });
    // }
    // setState(() {
    //   isloading = true;
    //   stts = 'starting game..';
    // });
    // Future.delayed(const Duration(milliseconds: 1000), () async {
    //   setState(() {
    //     isloading = false;
    //     gameStarted = true;
    //     stts = '';
    //   });
    //   if(widget.host){
    //     host_shuffle();
    //   }
    // });
  }

}
