import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodie_riders/assistantMethods/get_current_location.dart';
import 'package:foodie_riders/authentication/auth_screen.dart';
import 'package:foodie_riders/global/global.dart';
import 'package:foodie_riders/mainScreens/earnings_screen.dart';
import 'package:foodie_riders/mainScreens/history_screen.dart';
import 'package:foodie_riders/mainScreens/new_orders_screen.dart';
import 'package:foodie_riders/mainScreens/not_yet_delivered_screen.dart';
import 'package:foodie_riders/mainScreens/parcel_in_progress_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}



class _HomeScreenState extends State<HomeScreen>
{
  Card makeDashboardItem(String title, IconData iconData, int index)
  {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade50,
                Colors.blue.shade100,
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        )
            : BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black26,
                Colors.black12,
              ],
              begin:  FractionalOffset(0.0, 0.0),
              end:  FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            )
        ),
        child: InkWell(
          onTap: ()
          {
            if(index == 0)
            {
              //New Available Orders
              Navigator.push(context, MaterialPageRoute(builder: (c)=> NewOrdersScreen()));
            }
            if(index == 1)
            {
              //Parcels in Progress
              Navigator.push(context, MaterialPageRoute(builder: (c)=> ParcelInProgressScreen()));
            }
            if(index == 2)
            {
              //Not Yet Delivered
              Navigator.push(context, MaterialPageRoute(builder: (c)=> NotYetDeliveredScreen()));
            }
            if(index == 3)
            {
              //History
              Navigator.push(context, MaterialPageRoute(builder: (c)=> HistoryScreen()));
            }
            if(index == 4)
            {
              //Total Earnings
              Navigator.push(context, MaterialPageRoute(builder: (c)=> EarningsScreen()));
            }
            if(index == 5)
            {
              //Logout
              firebaseAuth.signOut().then((value){
                Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50.0),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();
    getPerParcelDeliveryAmount();
    getRiderPreviousEarnings();
  }


  getRiderPreviousEarnings()
  {
    FirebaseFirestore.instance
        .collection("riders")
        .doc(sharedPreferences!.getString("uid"))
        .get().then((snap)
    {
      previousRiderEarnings = snap.data()!["earnings"].toString();
    });
  }
  
  getPerParcelDeliveryAmount()
  {
    FirebaseFirestore.instance
        .collection("perDelivery")
        .doc("rateforaride") // GO TO DOCUMENT IN perDelivery Colleciton in the firebase
        .get().then((snap)
    {
       perParcelDeliveryAmount = snap.data()!["amount"].toString();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade400,
                  Colors.red.shade400,
                ],
                begin:  FractionalOffset(0.0, 0.0),
                end:  FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        title: Text(
          "Welcome " +
          sharedPreferences!.getString("name")!,
          style: const TextStyle(
            fontSize: 25.0,
            color: Colors.black,
            fontFamily: "Signatra",
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("1. New Available Orders", Icons.assignment, 0),
            makeDashboardItem("2. Parcels in Progress", Icons.airport_shuttle, 1),
            makeDashboardItem("3. Not Yet Delivered", Icons.location_history, 2),
            makeDashboardItem("4. History", Icons.done_all, 3),
            makeDashboardItem("5. Total Earnings", Icons.monetization_on, 4),
            makeDashboardItem("6. Logout", Icons.logout, 5),
          ],
        ),
      ),
    );
  }
}
