import 'package:ev_logger/mqtt_services.dart';
import 'package:flutter/material.dart';
import 'package:ev_logger/widgets/custom_card.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SoHScreen extends StatefulWidget {
  const SoHScreen({super.key});

  @override
  State<SoHScreen> createState() => _SoHScreenState();
}

class _SoHScreenState extends State<SoHScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  String? vehicleBatteryName;

  @override
  void initState() {
    super.initState();

    MqttService().connect();

    final userId = supabase.auth.currentUser?.id;
    fetchBatteryName(userId);
  }

  Future<void> fetchBatteryName(String? userId) async {
    if (userId != null) {
      try {
        final response =
            await supabase
                .from('Users')
                .select('battery_name')
                .eq('user_id', userId)
                .single();

        setState(() {
          vehicleBatteryName = response['battery_name'];
        });
      } catch (e) {
        print("Error fetching battery name: $e");
      }
    } else {
      print("User ID is null, cannot fetch battery name.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double liveSoH = context.watch<MqttService>().liveSoH;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCard(
                      cardWidth:
                          MediaQuery.of(context).size.width *
                          0.41, // Adjusted width
                      cardHeight:
                          MediaQuery.of(context).size.height *
                          0.12, // Fixed typo
                      cardContent: '$liveSoH%',
                      name: 'SOH',
                      preIcon: Icons.monitor_heart_outlined,
                    ),
                    SizedBox(width: 10),
                    CustomCard(
                      cardWidth: MediaQuery.of(context).size.width * 0.41,
                      cardHeight: MediaQuery.of(context).size.height * 0.12,
                      cardContent: '$vehicleBatteryName',
                      name: 'Battery Name',
                      preIcon: Icons.battery_std_outlined,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCard(
                      cardWidth: MediaQuery.of(context).size.width * 0.41,
                      cardHeight: MediaQuery.of(context).size.height * 0.12,
                      cardContent: '20',
                      name: 'Temperature (°C)',
                      preIcon: Icons.thermostat_outlined,
                    ),
                    SizedBox(width: 10),
                    CustomCard(
                      cardWidth: MediaQuery.of(context).size.width * 0.41,
                      cardHeight:
                          MediaQuery.of(context).size.height *
                          0.12, // Fixed typo
                      cardContent: '10000',
                      name: 'Life Cycle',
                      preIcon: Icons.run_circle,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            textAlign: TextAlign.justify,
                            'Emergency',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF01D5A2),
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.09,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            textAlign: TextAlign.justify,
                            'Malfunction Center',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF01D5A2),
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
