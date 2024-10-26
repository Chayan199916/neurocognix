import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final String iqGroup;

  ProfileScreen({Key? key, required this.username, required this.iqGroup})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

FlLine getDrawingHorizontalLine(value) {
  return const FlLine(
    color: Colors.grey,
    strokeWidth: 0.5,
  );
}

FlLine getDrawingVerticalLine(value) {
  return const FlLine(
    color: Colors.grey,
    strokeWidth: 0.5,
  );
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<int>? scores;
  Map<String, List<int>>? trainedGroupScores;
  Map<String, List<int>>? untrainedGroupScores;

  @override
  void initState() {
    super.initState();
    fetchScores();
  }

  Future<void> fetchScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Bypass logic: hardcode scores array for debugging
    bool bypass =
        true; // Set to true to activate bypass, false for regular logic
    if (bypass) {
      List<int> defaultScores = [75, 82, 87, 90, 92];
      setState(() {
        scores = defaultScores;
      });
    } else {
      List<int>? fetchedScores = prefs
          .getStringList('${widget.username}_scores')
          ?.map((score) => int.parse(score))
          .toList();

      setState(() {
        scores = fetchedScores;
      });
    }

    // Simulated data for trained and untrained groups with curvy patterns
    trainedGroupScores = {
      'trainedPlayer1': [55, 60, 68, 75, 82],
      'trainedPlayer2': [50, 58, 67, 72, 85],
      'trainedPlayer3': [58, 65, 70, 80, 90],
      'trainedPlayer4': [60, 68, 75, 83, 88],
      'trainedPlayer5': [63, 55, 67, 60, 80],
      'trainedPlayer6': [60, 58, 75, 83, 88],
    };

    untrainedGroupScores = {
      'untrainedPlayer1': [45, 47, 49, 50, 52],
      'untrainedPlayer2': [50, 52, 53, 54, 55],
      'untrainedPlayer3': [50, 52, 47, 55, 57],
      'untrainedPlayer4': [50, 53, 53, 55, 60],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Username: ${widget.username}',
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'IQ Group: ',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    widget.iqGroup,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Performance:',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            _buildPerformanceChart(),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildPerformanceChart() {
    if (scores == null || scores!.isEmpty) {
      return const Text('No performance data available.',
          style: TextStyle(color: Colors.white));
    } else {
      // Calculate average score
      double averageScore = scores!.reduce((a, b) => a + b) / scores!.length;

      // Create data points for the user's performance
      List<FlSpot> dataPoints = [];
      for (int i = 0; i < scores!.length; i++) {
        dataPoints.add(FlSpot(i.toDouble(), scores![i].toDouble()));
      }

      // Create data points for trained and untrained groups
      List<LineChartBarData> lineBarsData = [
        LineChartBarData(
          spots: dataPoints,
          isCurved: true,
          color: Colors.blue,
          barWidth: 2,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.withOpacity(0.3),
          ),
          dotData: const FlDotData(show: true),
        ),
      ];

      // Add trained group data
      trainedGroupScores?.forEach((player, scores) {
        List<FlSpot> playerDataPoints = [];
        for (int i = 0; i < scores.length; i++) {
          playerDataPoints.add(FlSpot(i.toDouble(), scores[i].toDouble()));
        }
        lineBarsData.add(
          LineChartBarData(
            spots: playerDataPoints,
            isCurved: true,
            color: Colors.green, // Use green for trained group
            barWidth: 1.5,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: false,
            ),
            dotData: const FlDotData(show: false),
          ),
        );
      });

      // Add untrained group data
      untrainedGroupScores?.forEach((player, scores) {
        List<FlSpot> playerDataPoints = [];
        for (int i = 0; i < scores.length; i++) {
          playerDataPoints.add(FlSpot(i.toDouble(), scores[i].toDouble()));
        }
        lineBarsData.add(
          LineChartBarData(
            spots: playerDataPoints,
            isCurved: true,
            color: Colors.red, // Use red for untrained group
            barWidth: 1.5,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: false,
            ),
            dotData: const FlDotData(show: false),
          ),
        );
      });

      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Average Score: ${averageScore.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, color: Colors.amberAccent),
            ),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    getDrawingHorizontalLine: getDrawingHorizontalLine,
                    getDrawingVerticalLine: getDrawingVerticalLine,
                  ),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  lineBarsData: lineBarsData,
                  minX: 0,
                  maxX: scores!.length.toDouble() - 1,
                  minY: 0,
                  maxY: 100,
                  lineTouchData: LineTouchData(
                    touchTooltipData: const LineTouchTooltipData(),
                    touchCallback:
                        (FlTouchEvent event, LineTouchResponse? touchResponse) {
                      // Handle touch events if needed
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Wrap(
              children: [
                _LegendIndicator(color: Colors.blue, text: 'Your Score'),
                SizedBox(width: 10),
                _LegendIndicator(color: Colors.green, text: 'Trained Group'),
                SizedBox(width: 10),
                _LegendIndicator(color: Colors.red, text: 'Untrained Group'),
              ],
            ),
          ],
        ),
      );
    }
  }
}

// Custom widget to display legend indicators
class _LegendIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendIndicator({Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          color: color,
        ),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
