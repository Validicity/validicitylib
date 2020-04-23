import 'dart:convert';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:logging/logging.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_buffers.dart';

export 'package:mqtt_client/mqtt_client.dart';
export 'package:typed_data/typed_buffers.dart';

part 'mqtt.g.dart';

/// A service wrapping the MQTT client for convenience and using safe_config.
class MqttService {
  MqttService(this.config);

  MqttServerClient client;
  MqttConfiguration config;

  Logger get logger => Logger(config.application);

  /// Connect to MQTT
  Future<bool> connect() async {
    var clientID = config.clientID ??
        config.application +
            '_' +
            Random().nextInt(100000000).toRadixString(36);

    client = MqttServerClient(config.host, clientID);
    client
      ..keepAlivePeriod = 7
      ..setProtocolV311()
      ..useWebSocket = config.websocket
      ..secure = config.secure
      ..port = config.port
      ..logging(on: config.logging);
    logger.info("Connecting to ${config.host}");
    try {
      var message = MqttConnectMessage();
      if (config.willMessage != null) {
        message
          ..withWillMessage(config.willMessage)
          ..withWillQos(MqttQos.atLeastOnce)
          ..withWillTopic(config.willTopic);
        if (config.willRetain) {
          message.withWillRetain();
        }
      }
      await client.connect(config.username, config.password);
    } catch (e, s) {
      logger.severe("Failed to connect to MQTT: $e stack: $s config: $config");
      client.disconnect();
      return false;
    }

    // Check if we are not connected
    if (client.connectionStatus.state != MqttConnectionState.connected) {
      logger.severe("Failed to connect to MQTT");
      client.disconnect();
      return false;
    }

    logger.info("Connected");
    return true;
  }

  bool isConnected() {
    if (client == null) {
      return false;
    }
    return client.connectionStatus.state == MqttConnectionState.connected;
  }

  int publishJSONMessage(
      String topic, MqttQos qualityOfService, Map<String, dynamic> map,
      {bool retain: false}) {
    final payload = json.encode(map);
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(payload);
    return client.publishMessage(topic, qualityOfService, builder.payload,
        retain: retain);
  }

  int publishMessage(String topic, MqttQos qos, Uint8Buffer data,
      {bool retain: false}) {
    return client.publishMessage(topic, qos, data, retain: retain);
  }

  /// Publishing en empty retained message will remove the existing retained message
  int unpublishMessage(String topic, MqttQos qos) {
    return client.publishMessage(topic, qos, Uint8Buffer(0), retain: true);
  }

  void unsubscribe(String topic) {
    client.unsubscribe(topic);
  }

  void subscribe(
      String topic, MqttQos qos, Function(String, MqttPublishMessage) handler) {
    client.subscribe(topic, qos);
    var filter = MqttClientTopicFilter(topic, client.updates);
    filter.updates.listen((List<MqttReceivedMessage> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final topic = c[0].topic;
      handler(topic, message);
    });
  }
}

/// A Configuration to represent an MQTT service. anyMap: true makes this work for YAML too.
@JsonSerializable(
  anyMap: true,
  checked: true,
  disallowUnrecognizedKeys: true,
  nullable: false,
)
class MqttConfiguration {
  /// Is MQTT enabled?
  @JsonKey(nullable: true, required: false, defaultValue: true)
  bool enabled;

  /// Which server host to connect to.
  @JsonKey(required: true)
  String host;

  /// The username to connect as.
  @JsonKey(required: true)
  String username;

  /// The password for the user.
  @JsonKey(required: true)
  String password;

  /// Which application name to use.
  @JsonKey(required: true)
  String application;

  /// Will message.
  @JsonKey(required: false)
  String willMessage;

  /// Will topic.
  @JsonKey(required: false)
  String willTopic;

  /// Will retain.
  @JsonKey(nullable: true, required: false, defaultValue: true)
  bool willRetain;

  /// Will QoS.
  // This goofs YAMl parsing!
  // @JsonKey(required: false)
  // MqttQos willQoS = MqttQos.atLeastOnce;

  /// The client ID.
  @JsonKey(required: false)
  String clientID;

  /// If logging is turned on.
  @JsonKey(nullable: true, required: false, defaultValue: false)
  bool logging;

  /// If we connect using SSL.
  @JsonKey(nullable: true, required: false, defaultValue: false)
  bool secure;

  /// If we connect using a websocket.
  @JsonKey(nullable: true, required: false, defaultValue: false)
  bool websocket;

  /// Which port to use.
  @JsonKey(nullable: true, required: false, defaultValue: 1883)
  int port;

  MqttConfiguration();

  factory MqttConfiguration.fromJson(Map json) =>
      _$MqttConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$MqttConfigurationToJson(this);

  @override
  String toString() => 'MqttConfiguration: ${toJson()}';
}
