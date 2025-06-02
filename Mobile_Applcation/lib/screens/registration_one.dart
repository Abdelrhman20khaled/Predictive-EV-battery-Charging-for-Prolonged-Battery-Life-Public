import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ev_logger/screens/home_screen.dart';
import 'package:ev_logger/widgets/textfield.dart';
import 'package:ev_logger/widgets/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  Uint8List? _image;
  TextEditingController driverName = TextEditingController();
  TextEditingController vehicleName = TextEditingController();
  TextEditingController batteryName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController confirmpass = TextEditingController();
  TextEditingController phone = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscureTextPass = true;
  bool _obscureTextConfirmPass = true;

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> selectImage() async {
    try {
      Uint8List? img = await pickImage(ImageSource.gallery);
      setState(() {
        _image = img;
      });
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String?> uploadImageToSupabase(
    Uint8List imageData,
    String userId,
  ) async {
    try {
      final fileName = 'user_profiles/$userId.jpg';
      await supabase.storage
          .from('profileimages')
          .uploadBinary(
            fileName,
            imageData,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );
      return supabase.storage.from('profileimages').getPublicUrl(fileName);
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }

  Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String deviceName = "Unknown Device";

    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceName = androidInfo.model ?? "Unknown Android Device";
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceName = iosInfo.utsname.machine ?? "Unknown iOS Device";
    }

    return deviceName;
  }

  Future<void> insertUserData(
    String userId,
    String email,
    String? imageUrl,
  ) async {
    try {
      await supabase.from('Users').upsert({
        'user_id': userId,
        'driver_name': driverName.text.trim(),
        'vehicle_name': vehicleName.text.trim(),
        'battery_name': batteryName.text.trim(),
        'email': email,
        'phone': phone.text.trim(),
        'profile_image': imageUrl,
      });
    } catch (e) {
      print("Supabase DB error: $e");
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Error',
        desc: 'Failed to save user data. Please try again.',
      ).show();
    }
  }

  Future<void> registerUser() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      if (pass.text != confirmpass.text) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'Passwords do not match.',
        ).show();
        return;
      }

      try {
        final AuthResponse response = await supabase.auth.signUp(
          email: email.text.trim(),
          password: pass.text.trim(),
        );
        final User? user = response.user;

        if (user == null) {
          AwesomeDialog(
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,
            title: 'Verify Email',
            desc: 'Please verify your email before proceeding.',
          ).show();
          return;
        }

        String? imageUrl;
        if (_image != null) {
          imageUrl = await uploadImageToSupabase(_image!, user.id);
        }

        // Insert main user data
        await insertUserData(user.id, email.text.trim(), imageUrl);

        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.rightSlide,
          title: 'Welcome',
          desc: 'Registration completed successfully!',
          btnOkOnPress: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ).show();
      } catch (e) {
        print("Unexpected error: $e");
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'An unexpected error occurred. Please try again.',
        ).show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C1515),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 100),
              Lottie.asset('images/animations/Animation - 1741792368675.json'),
              const SizedBox(height: 10),
              const Text(
                'Registration',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 70),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(_image!),
                      )
                      : const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'images/profiles/user_profile.png',
                        ),
                      ),
                  Positioned(
                    bottom: -10,
                    left: 65,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                        color: Color.fromARGB(255, 60, 105, 220),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              MyTextField(
                icon: Icons.person,
                obscure: false,
                text: 'Driver Name',
                val: 'enter your name',
                mycontroller: driverName,
                validator: (val) => val == "" ? "Required field" : null,
              ),
              const SizedBox(height: 20),
              MyTextField(
                icon: Icons.electric_car,
                obscure: false,
                text: 'Vehicle Name',
                val: 'enter your vehicle name',
                mycontroller: vehicleName,
                validator: (val) => val == "" ? "Required field" : null,
              ),
              const SizedBox(height: 20),
              MyTextField(
                icon: Icons.battery_charging_full,
                obscure: false,
                text: 'Battery Name',
                val: 'enter your vehicle battery name',
                mycontroller: batteryName,
                validator: (val) => val == "" ? "Required field" : null,
              ),
              const SizedBox(height: 20),
              MyTextField(
                icon: Icons.email,
                obscure: false,
                text: 'Email',
                val: 'Enter your e-mail',
                mycontroller: email,
                validator: (val) => val == "" ? "Required field" : null,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF01D5A2).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: pass,
                  obscureText: _obscureTextPass,
                  decoration: InputDecoration(
                    hintText: 'Enter a password',
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: const Color(0xFF01D5A2).withOpacity(0.4),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextPass
                            ? Icons.visibility_off
                            : Icons.remove_red_eye_rounded,
                        color: const Color(0xFF01D5A2).withOpacity(0.4),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextPass = !_obscureTextPass;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(
                          255,
                          229,
                          229,
                          229,
                        ).withOpacity(0.5),
                        width: 1,
                      ), // Border styling
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 1,
                      ), // Border styling
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 1,
                      ), // Border styling
                    ),
                  ),
                  validator: (val) => val == "" ? "Required field" : null,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF01D5A2).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: confirmpass,
                  obscureText: _obscureTextConfirmPass,
                  decoration: InputDecoration(
                    hintText: 'Enter the same password',
                    hintStyle: TextStyle(color: Colors.white),
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: const Color(0xFF01D5A2).withOpacity(0.4),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureTextConfirmPass
                            ? Icons.visibility_off
                            : Icons.remove_red_eye_rounded,
                        color: const Color(0xFF01D5A2).withOpacity(0.4),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureTextConfirmPass = !_obscureTextConfirmPass;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 1,
                      ), // Border styling
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 1,
                      ), // Border styling
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Colors.blueGrey,
                        width: 1,
                      ), // Border styling
                    ),
                  ),
                  validator: (val) => val == "" ? "Required field" : null,
                ),
              ),
              const SizedBox(height: 20),
              MyTextField(
                icon: Icons.phone,
                obscure: false,
                text: 'Phone Number',
                val: 'Enter your phone number',
                mycontroller: phone,
                validator: (val) => val == "" ? "Required field" : null,
              ),
              TextButton(
                onPressed: registerUser,
                child: Container(
                  margin: const EdgeInsets.all(25),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Register Now',
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.arrow_circle_right_sharp,
                        color: Colors.white,
                        size: 32,
                      ),
                    ],
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

class InfiniteUniqueRandom {
  final Set<int> _seen = {};
  final Random _random = Random();

  int next() {
    int candidate;
    do {
      candidate = _random.nextInt(1 << 31); // 2^31 range
    } while (_seen.contains(candidate));
    _seen.add(candidate);
    return candidate;
  }
}
