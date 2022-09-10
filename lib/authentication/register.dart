import 'package:flutter/material.dart';
import 'package:foodie_riders/widgets/custom_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; //for adding the file
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:foodie_riders/widgets/error_dialog.dart'; //1
import 'package:foodie_riders/widgets/loading_dialog.dart'; //2
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodie_riders/mainScreens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodie_riders/global/global.dart'; //3

//errors
// 1. register with a simple password, fials but profile pic already loaded
// 2. at deleting the user authentication in the firebase, storage and firestore doesnt get delete

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}): super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();


  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String riderImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async{
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  LocationPermission? permission;

  getCurrentLocation() async{ //add geocoidng and geolocator packages
    permission = await Geolocator.requestPermission();

    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMarks![0];
    completeAddress = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';
    locationController.text = completeAddress;
  }

  Future<void> formValidation() async{
    if (imageXFile == null){
      showDialog(
        context: context,
        builder: (c){
          return ErrorDialog(
            message: "Please select an image",
          );
        }
      );
    }
    else{
      if(passwordController.text == confirmPasswordController.text){

        if(confirmPasswordController.text.isNotEmpty && emailController.text.isNotEmpty && 
        nameController.text.isNotEmpty && phoneController.text.isNotEmpty && 
        locationController.text.isNotEmpty){
          showDialog(
            context: context,
            builder: (c){
              return LoadingDialog(
                message: "Registering Account",
              );
            }
          );

          
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("riders").child(fileName);
          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            riderImageUrl = url;
            // finished the signup and proceed to mainScreen
            authenticateRiderAndSignUp();
          });
        }
        
        else{
          showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Please complete your information in every field",
              );
            }
          );
        }
      }
      else
      {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Password does not match, please try again",
            );
          }
        );
      }
    }
  }

  void authenticateRiderAndSignUp() async{
    User? currentUser; 
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
    
    await firebaseAuth.createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth) {
      currentUser = auth.user;
    });
    }  on FirebaseAuthException catch (error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: error.message.toString(),
          );
         }
      );
    };

    if(currentUser !=null){
      saveDataToFirestore(currentUser!).then((value){
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (c) => const HomeScreen());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async{
    FirebaseFirestore.instance.collection("riders").doc(currentUser.uid).set({
      "riderUID": currentUser.uid,
      "riderEmail": currentUser.email,
      "riderName": nameController.text.trim(),
      "riderAvatarUrl": riderImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "aproved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "long": position!.longitude,
    });

    //Saving the data locally on the user's phone
    SharedPreferences? sharedPreferences = await SharedPreferences.getInstance();
    //sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("uid", currentUser.uid);
    await sharedPreferences.setString("email", currentUser.email.toString());
    await sharedPreferences.setString("name", nameController.text.trim());
    await sharedPreferences.setString("photoUrl", riderImageUrl);
  }

  @override
  Widget build(BuildContext context){
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10,),
            InkWell( //add image on the profile icon
              onTap: (){
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.2,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile==null ? null: FileImage(File(imageXFile!.path)),
                child: imageXFile == null ? 
                Icon(
                  Icons.add_photo_alternate,
                  size: MediaQuery.of(context).size.width * 0.20,
                  color: Colors.grey,
                ) : null,
              ),
            ),
            const SizedBox(height: 10,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    data: Icons.person,
                    controller: nameController,
                    hintText: "Name",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.email,
                    controller: emailController,
                    hintText: "Email",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: passwordController,
                    hintText: "Password",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.lock,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    isObsecre: true,
                  ),
                  CustomTextField(
                    data: Icons.phone,
                    controller: phoneController,
                    hintText: "Phone",
                    isObsecre: false,
                  ),
                  CustomTextField(
                    data: Icons.my_location,
                    controller: locationController,
                    hintText: "My current address", //change this
                    isObsecre: false,
                    enabled: true,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        "Get my current Location",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      onPressed: (){
                        getCurrentLocation();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey, //red.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30,),
            // ElevatedButton(
            //   child: const Text(
            //     "Sign up",
            //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.red,
            //     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            //   ),
            //   onPressed: () {
            //     formValidation();
            //   },
            // ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.pink.shade300,
                    Colors.red.shade300,
                  ],
                  begin: const FractionalOffset(0.0, 0.5),
                  end: const FractionalOffset(1.0, 0.5),
                  stops: const [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child:ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    //onSurface: Colors.transparent,
                ),
                onPressed: (){
                  formValidation();
                }, 
                child: const Padding(
                  // padding:EdgeInsets.only(
                  //   top: 1,
                  //   bottom: 1,
                  // ),
                  padding: EdgeInsets.symmetric(horizontal: 30,
                    vertical: 10),
                  child: Text(
                    "Sign up",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),  
            ),
            const SizedBox(height: 30,),
          ]
        )
      )
    );
  }
}