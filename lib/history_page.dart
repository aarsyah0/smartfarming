import 'package:flutter/material.dart';

class HistoryEntry {
  final DateTime time;
  final double temperature;
  final double humidity;
  final bool fanOn;
  final bool pumpOn;
  HistoryEntry({
    required this.time,
    required this.temperature,
    required this.humidity,
    required this.fanOn,
    required this.pumpOn,
  });
}

class HistoryPage extends StatelessWidget {
  final List<HistoryEntry> history;
  const HistoryPage({Key? key, required this.history}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF6FFF9),
      body: Column(
        children: [
          // Modern header dengan background gambar dan overlay gradient
          Container(
            width: double.infinity,
            height: 110,
            decoration: BoxDecoration(
              image: DecorationImage(
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
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, color: Colors.white, size: 32),
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
              child:
                  history.isEmpty
                      ? Center(
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
                              dataRowColor: MaterialStateProperty.resolveWith<
                                Color?
                              >((Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.green.withOpacity(0.15);
                                }
                                return null;
                              }),
                              columns: const [
                                DataColumn(label: Text('Waktu')),
                                DataColumn(label: Text('Temperature')),
                                DataColumn(label: Text('Humidity')),
                                DataColumn(label: Text('Kipas')),
                                DataColumn(label: Text('Pompa')),
                              ],
                              rows: List.generate(history.length, (i) {
                                final h = history[history.length - 1 - i];
                                final isEven = i % 2 == 0;
                                return DataRow(
                                  color: MaterialStateProperty.all(
                                    isEven
                                        ? Colors.white
                                        : const Color(0xFFF1F8E9),
                                  ),
                                  cells: [
                                    DataCell(
                                      Text(
                                        '${h.time.hour.toString().padLeft(2, '0')}:${h.time.minute.toString().padLeft(2, '0')}:${h.time.second.toString().padLeft(2, '0')}\n${h.time.day}/${h.time.month}/${h.time.year}',
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.thermostat,
                                            color: Color(0xFF4FC3F7),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${h.temperature.toStringAsFixed(1)} °C',
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
                                          Icon(
                                            Icons.water_drop,
                                            color: Color(0xFF0288D1),
                                            size: 18,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${h.humidity.toStringAsFixed(1)} %',
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
                                          color:
                                              h.fanOn
                                                  ? const Color(0xFFB9F6CA)
                                                  : const Color(0xFFFFCDD2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          h.fanOn ? 'ON' : 'OFF',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                h.fanOn
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
                                          color:
                                              h.pumpOn
                                                  ? const Color(0xFFB9F6CA)
                                                  : const Color(0xFFFFCDD2),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          h.pumpOn ? 'ON' : 'OFF',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                h.pumpOn
                                                    ? Colors.green[800]
                                                    : Colors.red[800],
                                          ),
                                        ),
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
        ],
      ),
    );
  }
}
