import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:selfdep/features/home/data/models/hive/photo_hive_model.dart';

class CacheDebugWidget extends StatefulWidget {
  @override
  _CacheDebugWidgetState createState() => _CacheDebugWidgetState();
}

class _CacheDebugWidgetState extends State<CacheDebugWidget> {
  Map<String, int> cacheInfo = {};

  @override
  void initState() {
    super.initState();
    _loadCacheInfo();
  }

  Future<void> _loadCacheInfo() async {
    try {
      final box = await Hive.openBox<List<PhotoHiveModel>>('photos_box');
      final info = <String, int>{};
      
      for (final key in box.keys) {
        final photos = box.get(key);
        info[key.toString()] = photos?.length ?? 0;
      }
      
      setState(() {
        cacheInfo = info;
      });
    } catch (e) {
      print('Error loading cache info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cache Debug Info', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            if (cacheInfo.isEmpty)
              Text('No cached data found')
            else
              ...cacheInfo.entries.map((entry) => 
                Text('${entry.key}: ${entry.value} photos')),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadCacheInfo,
              child: Text('Refresh Cache Info'),
            ),
          ],
        ),
      ),
    );
  }
}