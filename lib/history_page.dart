import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'firebase_service.dart';

class HistoryPage extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  const HistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> _deleteHistory(String id) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus data ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _firebaseService.deleteHistory(id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Sort history by timestamp descending (newest first)
    final sortedHistory = List<Map<String, dynamic>>.from(widget.history)
      ..sort((a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF9),
      body: Column(
        children: [
          // Modern header dengan background gambar dan overlay gradient
          Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/greenhouse.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.2),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_rounded, color: Colors.white, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'Riwayat Data',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: widget.history.isEmpty
                  ? const Center(
                      child: Text(
                        'Belum ada riwayat data',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: MaterialStateProperty.all(
                                const Color(0xFFE8F5E9),
                              ),
                              headingTextStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1CB56B),
                                fontSize: 15,
                              ),
                              dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.selected)) {
                                    return Colors.green.withOpacity(0.15);
                                  }
                                  return null;
                                },
                              ),
                              columns: const [
                                DataColumn(label: Text('Waktu')),
                                DataColumn(label: Text('Temperature')),
                                DataColumn(label: Text('Humidity')),
                                DataColumn(label: Text('Kipas')),
                                DataColumn(label: Text('Pompa')),
                                DataColumn(label: Text('Aksi')),
                              ],
                              rows: List.generate(sortedHistory.length, (i) {
                                final h = sortedHistory[i];
                                final timestamp = h['timestamp'] as int;
                                final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
                                final formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(date);
                                final isEven = i % 2 == 0;

                                return DataRow(
                                  color: MaterialStateProperty.all(
                                    isEven ? Colors.white : const Color(0xFFF1F8E9),
                                  ),
                                  cells: [
                                    DataCell(
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.thermostat,
                                            color: Color(0xFF4FC3F7),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${(h['temperature'] as num).toStringAsFixed(1)} °C',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.water_drop,
                                            color: Color(0xFF0288D1),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${(h['humidity'] as num).toStringAsFixed(1)} %',
                                            style: const TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: h['fanOn'] == true
                                              ? const Color(0xFFB9F6CA)
                                              : const Color(0xFFFFCDD2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          h['fanOn'] == true ? 'ON' : 'OFF',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: h['fanOn'] == true
                                                ? Colors.green[800]
                                                : Colors.red[800],
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: h['pumpOn'] == true
                                              ? const Color(0xFFB9F6CA)
                                              : const Color(0xFFFFCDD2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          h['pumpOn'] == true ? 'ON' : 'OFF',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: h['pumpOn'] == true
                                                ? Colors.green[800]
                                                : Colors.red[800],
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () => _deleteHistory(h['id'] as String),
                                        tooltip: 'Hapus data',
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
