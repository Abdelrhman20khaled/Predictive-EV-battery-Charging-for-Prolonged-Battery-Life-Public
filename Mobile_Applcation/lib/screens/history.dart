import 'dart:convert';
import 'package:ev_logger/widgets/custom_card.dart';
import 'package:ev_logger/widgets/tip_list.dart';
import 'package:ev_logger/widgets/title_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ev_logger/mqtt_services.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  Map<String, dynamic>? lastChargingData;
  bool isLoading = true;
  String? userDeviceName;

  @override
  void initState() {
    super.initState();

    // Ensure MQTT is connected globally once
    MqttService().connect();

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final data = await supabase
          .from('ChargingData')
          .select()
          .order('id', ascending: false)
          .limit(1);

      setState(() {
        lastChargingData = data.isNotEmpty ? data.first : null;
        isLoading = false;
      });

      if (lastChargingData != null) {
        final userId = lastChargingData?['user_id'];
        await fetchDeviceName(userId);

        final soc = MqttService().liveSoC;
        if (soc >= 0.80 && soc <= 0.90) {
          sendNotification(userDeviceName ?? '');
        }
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchDeviceName(String? userId) async {
    if (userId != null) {
      try {
        final response =
            await supabase
                .from('Users')
                .select('device_id')
                .eq('user_id', userId)
                .single();

        setState(() {
          userDeviceName = response['device_id'];
        });
      } catch (e) {
        print("Error fetching device ID: $e");
      }
    }
  }

  Future<void> sendNotification(String deviceId) async {
    if (deviceId.isNotEmpty) {
      final url = Uri.parse('https://onesignal.com/api/v1/notifications');
      final headers = {
        'Authorization': 'Basic xi6u26lhveoemz3p5punsl6bh',
        'Content-Type': 'application/json',
      };

      final payload = json.encode({
        'app_id': '5b801c0d-a6d9-4e1c-9825-8bf9de1817db',
        'include_player_ids': [deviceId],
        'headings': {'en': 'Battery Charging Alert'},
        'contents': {
          'en':
              'Your battery is between 80% and 90%, consider stopping charging to preserve battery life.',
        },
        'priority': 10,
      });

      try {
        final response = await http.post(url, headers: headers, body: payload);
        if (response.statusCode == 200) {
          print('Notification sent successfully');
        } else {
          print('Failed to send notification: ${response.statusCode}');
        }
      } catch (e) {
        print('Error sending notification: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double liveSoC = context.watch<MqttService>().liveSoC;

    double containerWidth = MediaQuery.of(context).size.width * 0.3;
    double containerHeight = MediaQuery.of(context).size.height * 0.17;
    double filledHeight = containerHeight * liveSoC;

    return Scaffold(
      backgroundColor: const Color(0xFF0C1515),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Center(
                    child:
                        isLoading
                            ? const CircularProgressIndicator()
                            : lastChargingData == null
                            ? const Text(
                              "No data available",
                              style: TextStyle(fontSize: 18),
                            )
                            : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 5),
                                  CustomCard(
                                    cardWidth:
                                        MediaQuery.of(context).size.width,
                                    cardHeight:
                                        MediaQuery.of(context).size.height *
                                        0.13,
                                    cardContent: '95%',
                                    name: 'Last SoH Level',
                                    preIcon: Icons.battery_6_bar_outlined,
                                  ),

                                  const SizedBox(height: 10),
                                  CustomCard(
                                    cardWidth:
                                        MediaQuery.of(context).size.width,
                                    cardHeight:
                                        MediaQuery.of(context).size.height *
                                        0.13,
                                    cardContent: '85%',
                                    name: 'Last SoC Level',
                                    preIcon: Icons.battery_5_bar_outlined,
                                  ),

                                  const SizedBox(height: 10),
                                  TitledCard(
                                    cardWidth:
                                        MediaQuery.of(context).size.width,
                                    cardHeight:
                                        MediaQuery.of(context).size.height *
                                        0.12,
                                    name: 'Recommended Tips',
                                    preIcon: Icons.tips_and_updates_outlined,
                                    postIcon:
                                        Icons.arrow_drop_down_circle_sharp,
                                    onPostIconPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        builder:
                                            (_) => TipList(
                                              tips: [
                                                'Tip 1: Avoid overcharging.(Stop charging at 85%)',
                                                'Tip 2: Avoid undercharging.(Hurry up when it is about 30%)',
                                              ],
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
