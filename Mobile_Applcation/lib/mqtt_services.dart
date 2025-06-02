import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService extends ChangeNotifier {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;
  MqttService._internal();

  late MqttServerClient client;
  bool _isConnected = false;
  double _liveSoC = 85.0;
  double _liveSoH = 90.0;

  double get liveSoC => _liveSoC;
  double get liveSoH => _liveSoH;

  Future<void> connect() async {
    if (_isConnected) return;

    client = MqttServerClient.withPort(
      '4e8d18504a6a43b399cef98d05854c71.s1.eu.hivemq.cloud',
      'flutter_client',
      8883,
    );

    client.secure = true;
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.onBadCertificate = (dynamic cert) {
      print("Accepting bad certificate (for dev only)");
      return true;
    };

    client.connectionMessage =
        MqttConnectMessage()
            .withClientIdentifier('flutter_client')
            .authenticateAs('Usef_Ashraf_2', '1234567Aa')
            .startClean();

    try {
      await client.connect();

      if (client.connectionStatus!.state == MqttConnectionState.connected) {
        _isConnected = true;

        client.subscribe('raspberrypi/soc', MqttQos.atMostOnce);
        client.subscribe('raspberrypi/soh', MqttQos.atMostOnce);

        client.updates?.listen((
          List<MqttReceivedMessage<MqttMessage>> messages,
        ) {
          final recMessage = messages[0].payload as MqttPublishMessage;
          final topic = messages[0].topic;
          final payload = MqttPublishPayload.bytesToStringAsString(
            recMessage.payload.message,
          );

          final parsedValue = double.tryParse(payload);
          if (parsedValue != null) {
            if (topic == 'raspberrypi/soc') {
              _liveSoC = parsedValue;
            } else if (topic == 'raspberrypi/soh') {
              _liveSoH = parsedValue;
            }
            notifyListeners();
          }
        });
      } else {
        print('MQTT Connection failed: ${client.connectionStatus}');
        disconnect();
      }
    } catch (e) {
      print('MQTT Connect error: $e');
      disconnect();
    }
  }

  void disconnect() {
    if (_isConnected) {
      client.disconnect();
      _isConnected = false;
    }
  }
}
