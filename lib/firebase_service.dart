import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Stream untuk mendapatkan data sensor DHT11
  Stream<Map<String, dynamic>> getSensorData() {
    return _database.child('dht11').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return {};
      
      return {
        'temperature': data['suhu']?.toDouble() ?? 0.0,
        'humidity': data['humidity']?.toDouble() ?? 0.0,
      };
    });
  }

  // Stream untuk mendapatkan status kipas dari status/kipas
  Stream<bool> getFanStatus() {
    return _database.child('status/kipas').onValue.map((event) {
      final data = event.snapshot.value as bool?;
      return data ?? false;
    });
  }

  // Stream untuk mendapatkan status pompa dari status/pompa
  Stream<bool> getPumpStatus() {
    return _database.child('status/pompa').onValue.map((event) {
      final data = event.snapshot.value as bool?;
      return data ?? false;
    });
  }

  // Update status kipas langsung ke status/kipas dengan boolean
  Future<void> updateFanStatus(bool status) async {
    await _database.child('status/kipas').set(status);
  }

  // Update status pompa langsung ke status/pompa dengan boolean
  Future<void> updatePumpStatus(bool status) async {
    await _database.child('status/pompa').set(status);
  }

  // Stream untuk mendapatkan riwayat
  Stream<List<Map<String, dynamic>>> getHistory() {
    return _database.child('riwayat').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      List<Map<String, dynamic>> historyList = [];
      data.forEach((key, value) {
        if (value is Map) {
          historyList.add({
            'id': key,
            'temperature': value['temperature']?.toDouble() ?? 0.0,
            'humidity': value['humidity']?.toDouble() ?? 0.0,
            'fanOn': value['fanOn'] ?? false,
            'pumpOn': value['pumpOn'] ?? false,
            'timestamp': value['timestamp'] ?? 0,
          });
        }
      });

      // Sort by timestamp descending (newest first)
      historyList.sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
      return historyList;
    });
  }

  // Tambah riwayat
  Future<void> addHistory(Map<String, dynamic> data) async {
    await _database.child('riwayat').push().set({
      ...data,
      'timestamp': ServerValue.timestamp,
    });
  }
} 