import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';
import 'package:kalakalikasan/widgets/loading_lg.dart';

class SalesTrend extends ConsumerStatefulWidget {
  const SalesTrend({super.key});

  @override
  ConsumerState<SalesTrend> createState() {
    return _SalesTrendState();
  }
}

class _SalesTrendState extends ConsumerState<SalesTrend> {
  bool isLoading = true;
  bool hasError = false;
  int selectedYear = DateTime.now().year;
  List<int> availableYears = [];
  List<Map<String, dynamic>> salesData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      await _loadAvailableYears();
      await _loadSalesTrend();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _loadSalesTrend() async {
    try {
      final storeId = ref.read(userStoreProvider)[UserStore.id];
      final url = Uri.http(ref.read(urlProvider), 'fetch-store-sales-trend/$storeId');
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        throw Exception("Failed to load sales trend data");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          salesData = List<Map<String, dynamic>>.from(data["salesTrend"]);
        });
      }
    } catch (e) {
      print("Error fetching sales trend: $e");
      throw Exception(e);
    }
  }

  Future<void> _loadAvailableYears() async {
    try {
      final storeId = ref.read(userStoreProvider)[UserStore.id];
      final url = Uri.http(ref.read(urlProvider), 'fetch-available-sales-years/$storeId');
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        throw Exception("Failed to load available years");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          availableYears = List<int>.from(data["availableYears"]);
        });
      }
    } catch (e) {
      print("Error fetching available years: $e");
      throw Exception(e);
    }
  }

  List<FlSpot> getFilteredData() {
    if (salesData.isEmpty) return [];

    List<FlSpot> dataPoints = [];

    for (int i = 0; i < 12; i++) {
      double totalSales = salesData
          .where((data) {
            DateTime date = DateTime.parse(data["date"]);
            return date.month == (i + 1);
          })
          .fold(0.0, (sum, data) => sum + (data["sales"] as int).toDouble());

      dataPoints.add(FlSpot(i.toDouble(), totalSales));
    }

    return dataPoints;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Fetch the app theme

    return Container(
      width: double.infinity,
      child: Card(
        color: theme.cardTheme.color,
        elevation: theme.cardTheme.elevation,
        shape: theme.cardTheme.shape,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Title
              Text("Sales Trend", style: theme.textTheme.headlineMedium),

              // Year Dropdown
              if (availableYears.isNotEmpty)
                DropdownButton<int>(
                  value: selectedYear,
                  style: TextStyle(color: theme.colorScheme.primary),
                  icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
                  items: availableYears.map((year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString(), style: TextStyle(color: theme.colorScheme.primary)),
                    );
                  }).toList(),
                  onChanged: (year) {
                    setState(() {
                      selectedYear = year!;
                      fetchData();
                    });
                  },
                ),

              // Loading & Error States
              if (isLoading) Padding(padding: EdgeInsets.all(20), child: LoadingLg(50)),
              if (hasError)
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Error fetching data", style: TextStyle(color: Colors.red)),
                ),

              // Line Chart
              if (!isLoading && !hasError)
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LineChart(
                      LineChartData(
                        backgroundColor: theme.cardTheme.color,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, interval: 100),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                List<String> labels = [
                                  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
                                ];
                                return Text(labels[value.toInt()], style: TextStyle(color: theme.colorScheme.primary));
                              },
                            ),
                          ),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: getFilteredData(),
                            isCurved: false,
                            color: theme.colorScheme.primary,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              color: theme.colorScheme.primary.withOpacity(0.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}