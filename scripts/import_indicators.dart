#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script to import indicators from CSV to JSON format
/// Usage: dart scripts/import_indicators.dart <indicators_csv_path> <groups_csv_path>

void main(List<String> arguments) async {
  if (arguments.length < 2) {
    print(
        'Usage: dart scripts/import_indicators.dart <indicators_csv_path> <groups_csv_path>');
    exit(1);
  }

  final indicatorsCsvPath = arguments[0];
  final groupsCsvPath = arguments[1];

  print('📂 Reading Indicators CSV: $indicatorsCsvPath');
  print('📂 Reading Groups CSV: $groupsCsvPath');

  try {
    // 1. Parse Groups
    final groupsContent = await readFileContent(groupsCsvPath);
    final groupsMap = parseGroupsCSV(groupsContent);
    print('✅ Parsed ${groupsMap.length} groups definitions');

    // 2. Parse Indicators
    final indicatorsContent = await readFileContent(indicatorsCsvPath);
    final indicators = parseIndicatorsCSV(indicatorsContent, groupsMap);
    print('✅ Parsed ${indicators.length} indicators');

    // 3. Generate JSON files
    await writeIndicators(indicators);
    await writeIndicatorGroups(indicators, groupsMap);

    print('🎉 Import completed successfully!');
    print('📊 Generated files:');
    print('   - assets/data/sa_indicators.json');
    print('   - assets/data/indicator_groups.json');
  } catch (e) {
    print('❌ Error importing data: $e');
    if (e is Error) {
      print(e.stackTrace);
    }
    exit(1);
  }
}

Future<String> readFileContent(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    throw Exception('File not found: $path');
  }
  try {
    return await file.readAsString(encoding: utf8);
  } catch (e) {
    print('⚠️  UTF-8 failed for $path, trying Latin-1...');
    return await file.readAsString(encoding: latin1);
  }
}

/// Robust CSV Parser
List<List<String>> parseCSVRaw(String content) {
  final result = <List<String>>[];
  var currentLine = <String>[];
  var buffer = StringBuffer();
  var inQuotes = false;

  for (int i = 0; i < content.length; i++) {
    final char = content[i];

    if (inQuotes) {
      if (char == '"') {
        if (i + 1 < content.length && content[i + 1] == '"') {
          buffer.write('"');
          i++; 
        } else {
          inQuotes = false;
        }
      } else {
        buffer.write(char);
      }
    } else {
      if (char == '"') {
        inQuotes = true;
      } else if (char == ',') {
        currentLine.add(buffer.toString());
        buffer.clear();
      } else if (char == '\n' || char == '\r') {
        if (char == '\r' && i + 1 < content.length && content[i + 1] == '\n') {
          i++;
        }
        currentLine.add(buffer.toString());
        buffer.clear();
        if (currentLine.isNotEmpty) {
           result.add(currentLine);
        }
        currentLine = [];
      } else {
        buffer.write(char);
      }
    }
  }
  
  if (buffer.isNotEmpty || currentLine.isNotEmpty) {
    currentLine.add(buffer.toString());
    result.add(currentLine);
  }
  
  return result;
}

Map<String, Map<String, dynamic>> parseGroupsCSV(String csvContent) {
  final rows = parseCSVRaw(csvContent);
  if (rows.isEmpty) return {};

  final header = rows[0].map((e) => e.trim()).toList();
  final headerMap = <String, int>{};
  for (int i = 0; i < header.length; i++) {
    headerMap[header[i]] = i;
  }

  final groups = <String, Map<String, dynamic>>{};

  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];
    if (row.isEmpty) continue;
    
    String v(String key) {
       final idx = headerMap[key];
       if (idx == null || idx >= row.length) return '';
       return row[idx].trim();
    }

    final groupName = v('Group Name');
    final groupId = v('Group ID');
    
    if (groupName.isEmpty) continue;

    groups[groupName] = {
      'id': groupId.isNotEmpty ? groupId : groupName.toLowerCase().replaceAll(' ', '_'),
      'name': groupName,
      'description': v('Group Description'),
      'reportingFocus': v('Reporting Focus'),
      'icon': v('Suggested Icon'),
      'color': v('Colour'),
      'sortOrder': int.tryParse(v('Group Sort Order')) ?? 999,
    };
  }
  return groups;
}

List<Map<String, dynamic>> parseIndicatorsCSV(String csvContent, Map<String, Map<String, dynamic>> groupsMap) {
  final rows = parseCSVRaw(csvContent);
  if (rows.isEmpty) throw Exception('Indicators CSV is empty');

  final header = rows[0].map((e) => e.trim()).toList();
  print('📋 CSV Headers: ${header.join(', ')}');

  final headerMap = <String, int>{};
  for (int i = 0; i < header.length; i++) {
    headerMap[header[i]] = i;
  }

  final indicators = <Map<String, dynamic>>[];

  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];
    if (row.isEmpty) continue;

    String v(String key) {
       final idx = headerMap[key];
       if (idx == null || idx >= row.length) return '';
       return row[idx].trim();
    }

    final indicatorGroup = v('Indicator Group');
    final indicatorName = v('Indicator Name');
    final uid = v('UID');
    
    // Skip if basically empty
    if (indicatorName.isEmpty && uid.isEmpty) continue;

    // Resolve Category/Group ID
    String groupId = 'ungrouped';
    if (groupsMap.containsKey(indicatorGroup)) {
       groupId = groupsMap[indicatorGroup]!['id'];
    } else {
       // Fallback search
       final match = groupsMap.values.firstWhere(
          (g) => g['name'].toString().toLowerCase() == indicatorGroup.toLowerCase(),
          orElse: () => {},
       );
       if (match.isNotEmpty) {
         groupId = match['id'];
       } else {
         // Create fallback ID from name if not found?
         if (indicatorGroup.isNotEmpty) {
            groupId = indicatorGroup.toLowerCase().replaceAll(' ', '_');
         }
       }
    }

    // sort order
    int sortOrder = 999;
    try {
      sortOrder = int.parse(v('Sort Order'));
    } catch (_) {}

    indicators.add({
      'renoId': v('Reno'),
      'groupId': groupId,
      'indicatorId': uid,
      'sortOrder': sortOrder,
      'name': indicatorName,
      'shortname': indicatorName, // Default to name
      'numerator': v('Numerator'),
      'numeratorFormula': v('Numerator Formula'),
      'denominator': v('Denominator'),
      'denominatorFormula': v('Denominator Formula'),
      'definition': v('Definition'),
      'useContext': v('Use and Context'),
      'factorType': v('Factor'),
      'frequency': v('Freq').isNotEmpty ? v('Freq') : 'Quarterly',
      'status': 'RETAINED_WITHOUT_NEW', // Default as per previous logic
    });
  }

  return indicators;
}

Future<void> writeIndicators(List<Map<String, dynamic>> indicators) async {
  final outputFile = File('assets/data/sa_indicators.json');
  final jsonString = JsonEncoder.withIndent('  ').convert(indicators);
  await outputFile.writeAsString(jsonString);
  print('📁 Written ${indicators.length} indicators to assets/data/sa_indicators.json');
}

Future<void> writeIndicatorGroups(List<Map<String, dynamic>> indicators, Map<String, Map<String, dynamic>> groupsMap) async {
  final outputFile = File('assets/data/indicator_groups.json');
  
  final usedGroupIds = indicators.map((e) => e['groupId'] as String).toSet();
  
  final groupsList = <Map<String, dynamic>>[];
  
  for (final grpId in usedGroupIds) {
     Map<String, dynamic> grpData;
     
     final groupMatch = groupsMap.values.firstWhere((g) => g['id'] == grpId, orElse: () => {});
     
     if (groupMatch.isNotEmpty) {
        grpData = {
           'id': groupMatch['id'],
           'name': groupMatch['name'],
           'displayOrder': groupMatch['sortOrder'],
           'subGroups': [], // Legacy support
           // Additional metadata
           'description': groupMatch['description'],
           'icon': groupMatch['icon'],
           'color': groupMatch['color'],
        };
     } else {
        grpData = {
           'id': grpId,
           'name': grpId, // Or prettier format
           'displayOrder': 999,
           'subGroups': [],
        };
     }
     
     final count = indicators.where((e) => e['groupId'] == grpId).length;
     grpData['indicatorCount'] = count;
     
     groupsList.add(grpData);
  }

  // Sort
  groupsList.sort((a, b) {
     final orderA = (a['displayOrder'] as int?) ?? 999;
     final orderB = (b['displayOrder'] as int?) ?? 999;
     if (orderA != orderB) return orderA.compareTo(orderB);
     return (a['name'] as String).compareTo(b['name'] as String);
  });

  final jsonString = JsonEncoder.withIndent('  ').convert(groupsList);
  await outputFile.writeAsString(jsonString);
  print('📁 Written ${groupsList.length} groups to assets/data/indicator_groups.json');
}
