import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ev_logger/widgets/custom_card.dart';
import 'package:ev_logger/mqtt_services.dart';

class SoCScreen extends StatefulWidget {
  const SoCScreen({super.key});

  @override
  State<SoCScreen> createState() => _SoCScreenState();
}

class _SoCScreenState extends State<SoCScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  Map<String, dynamic>? lastChargingData;
  bool isLoading = true;
  String? userDeviceName;

  @override
  void initState() {
    super.initState();

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
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CustomCard(
                                        cardWidth:
                                            MediaQuery.of(context).size.width *
                                            0.41,
                                        cardHeight:
                                            MediaQuery.of(context).size.height *
                                            0.12,
                                        cardContent:
                                            '${(liveSoC).toStringAsFixed(1)}%',
                                        name: 'SOC',
                                        preIcon: Icons.electric_bolt_sharp,
                                      ),
                                      const SizedBox(width: 10),
                                      CustomCard(
                                        cardWidth:
                                            MediaQuery.of(context).size.width *
                                            0.41,
                                        cardHeight:
                                            MediaQuery.of(context).size.height *
                                            0.12,
                                        cardContent:
                                            '${(100 - liveSoC).toStringAsFixed(1)}%',
                                        name: 'DOD',
                                        preIcon: Icons.battery_6_bar_outlined,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  CustomCard(
                                    cardWidth:
                                        MediaQuery.of(context).size.width,
                                    cardHeight:
                                        MediaQuery.of(context).size.height *
                                        0.13,
                                    cardContent:
                                        lastChargingData?['from'] ?? 'N/A',
                                    name: 'Charge Time',
                                    preIcon: Icons.date_range,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomCard(
                                    cardWidth:
                                        MediaQuery.of(context).size.width,
                                    cardHeight:
                                        MediaQuery.of(context).size.height *
                                        0.13,
                                    cardContent:
                                        lastChargingData?['to'] ?? 'N/A',
                                    name: 'Discharge Time',
                                    preIcon: Icons.date_range,
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
