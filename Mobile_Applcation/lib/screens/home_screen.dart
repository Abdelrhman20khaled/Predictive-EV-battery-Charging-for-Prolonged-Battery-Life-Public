import 'package:ev_logger/screens/history.dart';
import 'package:flutter/material.dart';
import 'package:ev_logger/screens/soc_screen.dart';
import 'package:ev_logger/screens/soh_screen.dart';
import 'package:ev_logger/screens/user_profile.dart';
import 'package:ev_logger/widgets/custom_button.dart';
import 'package:ev_logger/widgets/my_custom_button.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ev_logger/mqtt_services.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final SupabaseClient supabase = Supabase.instance.client;
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserData();
    MqttService().connect();
  }

  Future<void> fetchCurrentUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        print("No user signed in");
        return;
      }

      print("Fetching data for user ID: ${user.id}");

      final data =
          await supabase
              .from('Users')
              .select()
              .eq('user_id', user.id.toString())
              .single();

      setState(() {
        userData = data;
        isLoading = false;
      });

      print("User data loaded: $userData");
    } catch (e, stackTrace) {
      print("Error fetching user data: $e");
      print(stackTrace);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onButtonTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _selectScreen() {
    switch (_currentIndex) {
      case 0:
        return const SoHScreen();
      case 1:
        return const SoCScreen();
      case 2:
        return const HistoryScreen();
      default:
        return const Center(
          child: Text(
            "Unknown Screen",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        );
    }
  }


  @override
  Widget build(BuildContext context) {
    final double liveSoC = context.watch<MqttService>().liveSoC / 100;

    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0C1515),
        body: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                          carBrand: userData?['vehicle_name'] ?? 'Unknown Car',
                          driverName: userData?['driver_name'] ?? 'Driver Name',
                          avatar: userData?['profile_image'] ?? '',
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserProfile(),
                              ),
                            );
                          },
                        ),
                    const SizedBox(height: 20),
                    Container(
                      width: MediaQuery.of(context).size.height * 0.24,
                      height: MediaQuery.of(context).size.height * 0.24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF01D5A2).withOpacity(0.4),
                          width: 1.2,
                        ),
                      ),
                      child: CircularPercentIndicator(
                        radius: constraints.maxWidth * 0.2,
                        lineWidth: 13.0,
                        animation: true,
                        animateFromLastPercent: true,
                        animationDuration: 1200,
                        percent: liveSoC,
                        center: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.electric_bolt,
                              size: constraints.maxHeight * 0.07,
                              color: const Color(0xFF01D5A2).withOpacity(0.4),
                            ),
                            Text(
                              "304Km",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: constraints.maxWidth * 0.06,
                                color: const Color(0xffFAFFFE),
                              ),
                            ),
                          ],
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: const Color(0xFF01D5A2).withOpacity(0.7),
                        backgroundColor: const Color(
                          0xFF01D5A2,
                        ).withOpacity(0.1),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Total Charge',
                      style: TextStyle(
                        color: const Color(0xFF01D5A2).withOpacity(0.7),
                        fontSize: constraints.maxWidth * 0.05,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MyCustomButton(
                          text: "SOH",
                          isSelected: _currentIndex == 0,
                          onTap: () => _onButtonTap(0),
                        ),
                        MyCustomButton(
                          text: "SOC",
                          isSelected: _currentIndex == 1,
                          onTap: () => _onButtonTap(1),
                        ),
                        MyCustomButton(
                          text: "History",
                          isSelected: _currentIndex == 2,
                          onTap: () => _onButtonTap(2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Expanded(child: _selectScreen()),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
