import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kalakalikasan/provider/url_provider.dart';
import 'package:kalakalikasan/provider/user_store_provider.dart';

class TopPurchasesChart extends ConsumerStatefulWidget {
  const TopPurchasesChart({super.key});

  @override
  ConsumerState<TopPurchasesChart> createState() => _TopPurchasesChartState();
}

class _TopPurchasesChartState extends ConsumerState<TopPurchasesChart> {
  bool isLoading = true;
  bool hasError = false;
  List<Map<String, dynamic>> topPurchases = [];

  @override
  void initState() {
    super.initState();
    fetchTopPurchases();
  }

  Future<void> fetchTopPurchases() async {
    try {
      final storeId = ref.read(userStoreProvider)[UserStore.id];
      final url = Uri.http(ref.read(urlProvider), 'fetch-store-top-purchases/$storeId');
      final response = await http.get(url);

      if (response.statusCode >= 400) {
        throw Exception("Failed to load top purchases");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          topPurchases = List<Map<String, dynamic>>.from(data["products"]);
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching top purchases: $e");
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              Text("Top 5 Purchased Products", style: theme.textTheme.headlineMedium),

              // Loading & Error States
              if (isLoading) Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),
              if (hasError)
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Error fetching data", style: TextStyle(color: Colors.red)),
                ),

              // Bar Chart
              if (!isLoading && !hasError)
                SizedBox(
                  height: 400,
                  child: BarChart(
                    BarChartData(
                      backgroundColor: theme.cardTheme.color,
                      barGroups: topPurchases.asMap().entries.map((entry) {
                        final index = entry.key;
                        final product = entry.value;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: product["total_quantity"].toDouble(),
                              width: 20,
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(5),
                              backDrawRodData: BackgroundBarChartRodData(
                                show: true,
                                toY: 0, 
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 && value.toInt() < topPurchases.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    topPurchases[value.toInt()]["product_name"],
                                    style: TextStyle(color: theme.colorScheme.primary, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              }
                              return Text("");
                            },
                            reservedSize: 60, // ✅ Ensures enough space for text below
                            interval: 1,
                          ),
                        ),
                      ),
                      gridData: FlGridData(show: true),
                      borderData: FlBorderData(show: true),

                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          tooltipBgColor: Colors.black.withOpacity(0.8), 
                          tooltipPadding: EdgeInsets.all(8),
                          tooltipRoundedRadius: 8,
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              "${rod.toY.toInt()}",
                              TextStyle(
                                color: Colors.white, 
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
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