# Foddie Riders Mobile App for IOS and Android

This app has the following features:

- Login/Register Screen
- Firebase databse integration
- Google maps navigation
- Dashboard to manage menu orders
- System administration of payments


## Result of the project
The final result of this project belong to the [`ver-1.2`](https://github.com/jatolentino/Flutter-Foodie-Rider/tree/v1.2) and it possess a login/register panel a dashboard to manage the shipping workflow and a google-maps integration that draws the route from the seller's store to the end customer.

<p align="center">
 <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.1/sources/step11-test-1-4.png" width="195">  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.1/sources/step11-test-1-5.png" width="195">
</p><br/>
<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.2/sources/step12-test-1.jpeg" width="500">
</p><br/>
<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.2/sources/step12-test-2-1.jpeg" width="500">
</p><br/>
<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.2/sources/step12-test-4.jpeg" width="500">
</p>

<!-- <p align="center">
    	<img src="https://github.com/jatolentino/Foodie/.../file.png" width="400">
</p>

<br> -->
## Pushing to github
Once created a VS code folder project
- Create the repository on Github
- Select the option `Source Control`, select `Initialize Repository`
- Add a commit message, and select the check mark
- Go to the option View > Command Palette and seravh for `Git Add Remote`
- Provide the repository URL and enter, then give a Remote name with the same name as the github repo, finalize with Enter
- Go to the synchronize button belove and click it (Next to the master branch icon)
- In the future, only commit with a new message and push the changes

## How to run the project?

Clone the repository and open the terminal and navigate to the `ios` folder, then run:

    ```bash
    flutter pub add firebase_auth
    flutter pub add firebase_core
    //sudo gem install cocoapods
    flutter pub get
    pod install
    ```

- Configure the firebase database, following the link [`Step 9.1: Create a firebase project`](https://github.com/jatolentino/Flutter-Foodie#configure_firebase)

- Enjoy!


## Follow along

### 1. Getting Started

- Create the project, in the terminal run:
    ```bash
    flutter create --org com.app foodie_riders
    ```
  > Bundle ID will be: `com.app.foodie_riders`, the name of the project is added by default at the end of `com.app`

- Add the `assets` and `images` folder to the root of the project (`/foodie_riders/`)
- Configure the pubspec.yaml file as:
    ```yaml
    name: foodie
    description: A new Flutter project.
    version: 1.0.0+1
    environment:
    sdk: ">=2.17.5 <3.0.0"

    dependencies:
        flutter:
            sdk: flutter

    cupertino_icons: ^1.0.2
    image_picker: ^0.8.5+3

    dev_dependencies:
        flutter_test:
            sdk: flutter
        flutter_lints: ^2.0.0

    flutter:
        uses-material-design: true
        assets:
            - images/
        fonts:
            - family: Bebas
                fonts:
                    - asset: assets/fonts/BebasNeue-Regular.ttf
            - family: Lobster
                fonts:
                    - asset: assets/fonts/Lobster-Regular.ttf
            - family: Signatra
                fonts:
                    - asset: assets/fonts/Signatra.ttf
            - family: Varela
                fonts:
                    - asset: assets/fonts/VarelaRound-Regular.ttf 
    ```

### 2. Edit the lib/main.dart file

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'splashScreen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global/global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riders App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MySplashScreen(), //const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

```

### 3. Add the splashcreen
- Create a splashScreen folder in lib/ and inside the file splash_screen.dart
```dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:foodie_riders/authentication/auth_screen.dart';
import 'package:foodie_riders/mainScreens/home_screen.dart';
//import 'package:foodie_riders/global/global.dart';
import 'package:foodie_riders/global/global.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}): super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTimer(){
    Timer(const Duration(seconds: 4), () async {
      //if rider is logged in
      if(firebaseAuth.currentUser != null){
        Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
      //if rider is not logged in
      else{
        Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/logo.png"),
              const SizedBox(height: 10,),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  "World's Largest Online Food App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 25,
                    fontFamily: "Signatra",
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```
### 4 Add the glogal folder
- Create a lib/global folder and add the globar.dart
```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
```

### 5 Configure build.gradle
- Go to android/app/build.gradle and edit it
```gradle
def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

def flutterRoot = localProperties.getProperty('flutter.sdk')
if (flutterRoot == null) {
    throw new GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")
}

def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
if (flutterVersionCode == null) {
    flutterVersionCode = '1'
}

def flutterVersionName = localProperties.getProperty('flutter.versionName')
if (flutterVersionName == null) {
    flutterVersionName = '1.0'
}

apply plugin: 'com.android.application'
apply plugin: 'kotlin-android'
apply from: "$flutterRoot/packages/flutter_tools/gradle/flutter.gradle"
apply plugin: 'com.google.gms.google-services'

android {
    compileSdkVersion 33 //flutter.compileSdkVersion
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    sourceSets {
        main.java.srcDirs += 'src/main/kotlin'
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "com.app.foodie_riders"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-build-configuration.
        minSdkVersion 19 //flutter.minSdkVersion
        targetSdkVersion flutter.targetSdkVersion
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
}
```
### 6 Add a new app in Firebase
- Go to Project Overview > Project settings
- In Your apps, click on `Add app`
- Name it with the Bundle ID configure in the Step 1 as `com.app.foodie_riders` and a nickname of Riders App, and click on `Register app`
- Download the config file `google-services.json` and paste it on the android/app folder
- Click on `Next` and copy/paste the config lines to android/build.gradle as below and on android/app/build.gradle as already modified above
    ```gradle
    buildscript {
        ext.kotlin_version = '1.6.10'
        repositories {
            google()
            mavenCentral()
        }

        dependencies {
            classpath 'com.google.gms:google-services:4.3.13'
            classpath 'com.android.tools.build:gradle:7.1.2'
            classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        }
    }

    allprojects {
        repositories {
            google()
            mavenCentral()
        }
    }

    rootProject.buildDir = '../build'
    subprojects {
        project.buildDir = "${rootProject.buildDir}/${project.name}"
    }
    subprojects {
        project.evaluationDependsOn(':app')
    }

    task clean(type: Delete) {
        delete rootProject.buildDir
    }
    ```
### 7 Add the widgets
- Add the widgets folder and include the files: custom_text_field.dart, error_dialog.dart, loading_dialog.dart and progress_bar.dart from the foddie previous app, but edit it as
- loading_dialog.dart
    ```dart
    import 'package:flutter/material.dart';
    import 'progress_bar.dart';

    class LoadingDialog extends StatelessWidget{
    final String? message;
    :
    ```

### 8 Add the authentication
- Copy the authentication from the Foodie previous app and edit it
- Edit auth_scree.dart
    ```dart
    import 'package:flutter/material.dart';
    import 'login.dart';
    import 'register.dart';


    class AuthScreen extends StatefulWidget {
    const AuthScreen({Key? key}): super(key: key);

    @override
    _AuthScreenState createState() => _AuthScreenState();
    }

    class _AuthScreenState extends State<AuthScreen> {
    @override
    Widget build(BuildContext context) {
        return DefaultTabController(
        length: 2,
        child: Scaffold(
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
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp,
                )
                ),
            ),
            automaticallyImplyLeading: false,
            title: const Text(
                "Foodie",
                style: TextStyle(
                fontSize: 40,
                color: Colors.white,
                fontFamily: "Signatra", //changed
                letterSpacing: 6
                ),
            ),
            centerTitle: true,
            bottom: const TabBar(
                tabs: [
                Tab(
                    icon: Icon(Icons.lock, color: Colors.white,),
                    text: "Login",
                ),
                Tab(
                    icon: Icon(Icons.person, color: Colors.white,),
                    text: "Register",
                ),
                ],
                indicatorColor: Colors.white38,
                indicatorWeight: 7,
            )
            ),
            body: Container( // ADDED THIS 23:49
            child: const TabBarView(
                children: [
                LoginScreen(),
                RegisterScreen(),
                ],
            ),
            )
        ),
        );
    }
    }
    ```
- Edit the login.dart
    ```dart
    import 'package:flutter/material.dart';
    import 'package:foodie_riders/widgets/custom_text_field.dart';
    import 'package:foodie_riders/widgets/error_dialog.dart';
    import 'package:foodie_riders/widgets/loading_dialog.dart';
    import 'package:firebase_auth/firebase_auth.dart';
    import 'package:foodie_riders/global/global.dart';
    import 'package:cloud_firestore/cloud_firestore.dart';
    import 'package:foodie_riders/mainScreens/home_screen.dart';
    import 'package:foodie_riders/authentication/auth_screen.dart';

    class LoginScreen extends StatefulWidget {
    const LoginScreen({Key? key}): super(key: key);

    @override
    _LoginScreenState createState() => _LoginScreenState();
    }

    class _LoginScreenState extends State<LoginScreen> {

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();  

    formValidation(){
        if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
        //login
        loginNow();
        }
        else
        {
        showDialog(
            context: context,
            builder: (c){
            return ErrorDialog( 
                message: "Please write email/password.",
            );
            }
        );
        }
    }

    loginNow() async{
        showDialog(
        context: context,
        builder: (c){
            return LoadingDialog(
            message: "Checking Credentials",
            );
        }
        );

        User? currentUser;
        try {
        await firebaseAuth.signInWithEmailAndPassword(
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


        if(currentUser != null){
        readDataAndSetDataLocally(currentUser!);
        }
    }
    
    Future readDataAndSetDataLocally(User currentUser) async{
        await FirebaseFirestore.instance.collection("riders") //add firebase cloud package
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
            if(snapshot.exists)
            {
            await sharedPreferences!.setString("uid", currentUser.uid);
            await sharedPreferences!.setString("email", snapshot.data()!["riderEmail"]);
            await sharedPreferences!.setString("name", snapshot.data()!["riderName"]);
            await sharedPreferences!.setString("photoUrl", snapshot.data()!["riderAvatarUrl"]);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
            }
            else
            {
            firebaseAuth.signOut();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
            showDialog(
                context: context,
                builder: (c) {
                return ErrorDialog(
                    message: "User not identified"
                );
                }
            );
            }
        });
    }
    @override
    Widget build(BuildContext context){
        return SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
            Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                padding: EdgeInsets.all(15),
                child: Image.asset(
                    "images/signup.png", //changed
                    height: 270,
                ),
                ),
            ),
            Form(
                key: _formKey,
                child: Column(
                children: [
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
                ],
                )
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
                child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
                ),
                style: ElevatedButton.styleFrom(
                primary: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                onPressed: (){
                formValidation();
                },
            ),
            const SizedBox(height: 30,),
            ],
        ),
        );
    }
    }
    ```
- Edit the register.dart
    ```dart
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
                            primary: Colors.grey, //red.shade400,
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
                DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                    colors: [
                        Colors.pink.shade400,
                        Colors.red.shade400,
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
    ```

### 9 Add the geolocation permission
- Go to android/app/src/main and open the AndroidManifest.xml file and edit the first lines
    ```xml
    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
        package="com.app.foodie_riders">

        <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
        <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    ```

### 10 Add the main screen
- Copy from the previous Foddie app the folder mainScreens and edit the file home_screen.dart
    ```dart
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
    ```

### 11 Login only to user of the foodie_riders app not from the foodie app
- In login.dart edit the configuration of login, it has already been modified above
    ```dart
    Future readDataAndSetDataLocally(User currentUser) async{
        await FirebaseFirestore.instance.collection("riders") //checking if the user that is login is the riders collection //add firebase cloud package
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
            if(snapshot.exists)
            {
            await sharedPreferences!.setString("uid", currentUser.uid);
            await sharedPreferences!.setString("email", snapshot.data()!["riderEmail"]);
            await sharedPreferences!.setString("name", snapshot.data()!["riderName"]);
            await sharedPreferences!.setString("photoUrl", snapshot.data()!["riderAvatarUrl"]);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
            }
            else
            {
            firebaseAuth.signOut();
            sharedPreferences!.clear(); //added this, once you logout, sharedpreferences or cache data will be deleted
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const AuthScreen()));
            showDialog(
                context: context,
                builder: (c) {
                return ErrorDialog(
                    message: "User not identified"
                );
                }
            );
            }
        });
    }
    ```
Test 11.1: Compiled @ the branch of [`ver-1.1`](https://github.com/jatolentino/Flutter-Foodie-Rider/tree/v1.1)

<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.1/sources/step11-test-1-1.png" width="195">  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.1/sources/step11-test-1-2.png" width="195">     <br><br>
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.1/sources/step11-test-1-3.png" width="700">
</p>

Note that when a user like Jose that is not registered to the rider's app (although registered to the seller's app), he will not be granted permission to access because he does not belong to the risers collection on Firestore
<p align="center">
 <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.1/sources/step11-test-1-4.png" width="195">  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.1/sources/step11-test-1-5.png" width="195">
</p>

## 12. Edit the home screen view
In the mainScreens.dart, add the home_screen.dart that will contain the info about the process of shipping of a determined product from a seller to an end-point user. <br/>

- It's neccesary to create a new collection in the database that will hold the price per delivery.
<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.2/sources/step12-test-0.jpeg" width="500">
</p>

- First the riders checks if there are new avalible orders.
<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.2/sources/step12-test-1.jpeg" width="500">
</p>

- Then he/she will decide whether to confirm the order or not. Also, he/she can check where the seller is located through the option `Show Cafe/Restaurant location` that will open the google maps and display a route.
<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.2/sources/step12-test-2.jpeg" width="500">
</p><br/>
<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.2/sources/step12-test-2-1.jpeg" width="500">
</p>

- After accepting the order, he/she proceeds to go and pick the product from the seller's store location, where he will set the status of the product as picked. 
<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.2/sources/step12-test-3.jpeg" width="500">
</p>

- Then he/she goes to location where the customer is to give him/her the product; the moment the product is delivered, he changes the status of the product to delivered. 

- Finally, the earnings are distributed to both the sellers and riders, and the database shows the amount for each one.

<p align="center">
  <img src="https://github.com/jatolentino/Flutter-Foodie-Rider/blob/v1.2/sources/step12-test-4.jpeg" width="500">
</p>
