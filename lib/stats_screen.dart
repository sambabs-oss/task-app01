import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  
  final int doneCount;
  final int pendingCount;
  final int totalCount;

  const StatsScreen({

    super.key,
    required this.doneCount,
    required this.pendingCount,
    required this.totalCount,
  });

  @override

  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text('Statistics',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: screenWidth * 0.9,
            child:          Card(
            child: Container(
              
              padding: EdgeInsets.all(32),
              margin: EdgeInsets.zero,
              child:Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 48),
                  Expanded(
                    child: Text('Done', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Text('$doneCount', style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
          ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: screenWidth * 0.9,
            child:          Card(
            child: Container(
              
              padding: EdgeInsets.all(32),
              margin: EdgeInsets.zero,
              child:Row(
                children: [
                  Icon(Icons.access_time, color: Colors.blue, size: 48),
                  Expanded(
                    child: Text('Pending', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Text('$pendingCount', style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
            ),
          ),
          ),

          const SizedBox(height: 16),
          SizedBox(
            width: screenWidth * 0.9,
            child:          Card(
            child: Container(
              
              padding: EdgeInsets.all(32),
              margin: EdgeInsets.zero,
              child:Row(
                children: [
                  
                  Icon(Icons.list, color: Colors.orange, size: 48),
                  Expanded(
                    child: Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: Text('$totalCount', style: TextStyle(fontSize: 24)),
                  ),
                ],
            
              ),
            ),
          ),
          ),
        ],
      ),
      ),
    );
  }
}