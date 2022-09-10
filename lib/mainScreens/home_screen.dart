import 'package:flutter/material.dart';
import 'package:foodie_riders/global/global.dart';
import 'package:foodie_riders/authentication/auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient( //const linearGradient
              colors: [
                Colors.pink.shade400,
                Colors.red.shade400,
              ],
              begin: const FractionalOffset(0.0, 0.5),
              end: const FractionalOffset(1.0, 0.5),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
          ),
        ),
        title: Text(
          "Welcome " + sharedPreferences!.getString("name")! +"!",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          onPressed: (){
            firebaseAuth.signOut().then((value){
              Navigator.push(context, MaterialPageRoute(builder: (c)=> AuthScreen()));
            });
            
          },
        )
      )
    );
  }
}