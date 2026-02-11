#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script to import data elements from CSV to JSON format
/// Usage: dart scripts/import_data_elements.dart <csv_file_path>

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print(
        'Usage: dart scripts/import_data_elements.dart <elements_csv_path> [groups_csv_path]');
    exit(1);
  }

  final elementsCsvPath = arguments[0];
  final groupsCsvPath = arguments.length > 1 ? arguments[1] : null;

  print('📂 Reading Elements CSV: $elementsCsvPath');
  if (groupsCsvPath != null) {
    print('📂 Reading Groups CSV: $groupsCsvPath');
  }

  try {
    // Load Groups if provided
    Map<String, Map<String, dynamic>> groupsMap = {};
    if (groupsCsvPath != null) {
      final groupsContent = await readFileContent(groupsCsvPath);
      groupsMap = parseGroupsCSV(groupsContent);
      print('✅ Parsed ${groupsMap.length} groups definitions');
    }

    final elementsContent = await readFileContent(elementsCsvPath);
    final dataElements = parseElementsCSV(elementsContent, groupsMap);

    print('✅ Parsed ${dataElements.length} data elements');

    // Generate data elements JSON
    await writeDataElements(dataElements);

    // Generate categories JSON
    await writeCategories(dataElements, groupsMap);

    print('🎉 Import completed successfully!');
    print('📊 Generated files:');
    print('   - assets/data/data_elements.json');
    print('   - assets/data/data_element_categories.json');
  } catch (e) {
    print('❌ Error importing data: $e');
    // Print stack trace if available
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

/// Robust CSV Parser that handles newlines in quotes and escaped quotes
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
          i++; // Skip escaped quote
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
        currentLine.add(buffer.toString()); // Trim later to preserve exact content if needed
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
  
  // Add last line if pending
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
  // Expect headers like: Group ID, Group Name, Group Description, ...
  
  final headerMap = <String, int>{};
  for (int i = 0; i < header.length; i++) {
    headerMap[header[i]] = i;
  }

  final groups = <String, Map<String, dynamic>>{};

  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];
    if (row.isEmpty) continue;
    
    // Helper to safely get value
    String v(String key) {
       final idx = headerMap[key];
       if (idx == null || idx >= row.length) return '';
       return row[idx].trim();
    }

    final groupName = v('Group Name');
    final groupId = v('Group ID');
    
    if (groupName.isEmpty) continue;

    // We key by Group Name because Elements CSV uses Name in DEGroup column
    groups[groupName] = {
      'id': groupId.isNotEmpty ? groupId : groupName.toLowerCase().replaceAll(' ', '_'),
      'name': groupName,
      'description': v('Group Description'),
      'icon': v('Suggested Icon'),
      'color': v('Colour'),
      'sortOrder': int.tryParse(v('Group Sort Order')) ?? 999,
    };
  }
  return groups;
}

List<Map<String, dynamic>> parseElementsCSV(String csvContent, Map<String, Map<String, dynamic>> groupsMap) {
  final rows = parseCSVRaw(csvContent);
  if (rows.isEmpty) throw Exception('Elements CSV is empty');

  // Parse header
  final header = rows[0].map((e) => e.trim()).toList();
  print('📋 CSV Headers: ${header.join(', ')}');

  final headerMap = <String, int>{};
  for (int i = 0; i < header.length; i++) {
    headerMap[header[i]] = i;
  }

  final dataElements = <Map<String, dynamic>>[];

  for (int i = 1; i < rows.length; i++) {
    final row = rows[i];
    if (row.isEmpty) continue;

    // Helper to get value
    String v(String key) {
       final idx = headerMap[key];
       if (idx == null || idx >= row.length) return '';
       return row[idx].trim();
    }

    // Skip rows where DEGroup is empty
    final deGroup = v('DEGroup');
    if (deGroup.isEmpty) continue;

    final uid = v('UID');
    final shortname = v('Shortname');
    final dataElementName = v('DataElementName');

    // Validation
    if ((uid.isEmpty && shortname.isEmpty) || (uid.isEmpty && dataElementName.isEmpty)) {
      // Just warn and skip
      if (row.length > 5) { // Only warn if it looks like a real row
         print('⚠️  Skipping line ${i + 1}: Missing critical data');
      }
      continue;
    }

    // Determine Status
    String status = 'retained';
    final text = '$shortname $dataElementName'.toLowerCase();
    if (text.contains('new ') || shortname.toUpperCase().startsWith('NEW')) status = 'new';
    else if (text.contains('amended') || text.contains('updated')) status = 'amended';

    // Map DEGroup Name to Group ID if available
    // The DEGroup in Elements file usually matches 'Group Name' in Groups file
    String categoryId = deGroup;
    if (groupsMap.containsKey(deGroup)) {
       categoryId = groupsMap[deGroup]!['id'];
    } else {
       // Fallback: Check if it matches ID directly? Or normalize
       // Search case-insensitive
       final match = groupsMap.values.firstWhere(
          (g) => g['name'].toString().toLowerCase() == deGroup.toLowerCase(),
          orElse: () => {},
       );
       if (match.isNotEmpty) {
         categoryId = match['id'];
       }
    }

    // Construct Element
    final id = uid.isNotEmpty ? uid : shortname.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');

    dataElements.add({
      'id': id,
      'name': dataElementName,
      'shortname': shortname.isNotEmpty ? shortname : dataElementName,
      'definition': v('Definition'),
      // Store the ID of the category, not the Display Name, for consistency
      // The app likely joins this ID with categories.json
      'category': categoryId, 
      // Also store the original group name for display fallback if needed? 
      // 'categoryName': deGroup, 
      'dataType': 'Number',
      'aggregationType': 'Sum',
      'status': status,
      'definitionExtended': v('Definition_Extended'),
      'useAndContext': v('Use and Context'),
      'inclusions': v('Inclusions'),
      'exclusions': v('Exclusions'),
      'frequency': v('Freq'),
      'collectedBy': v('Collected By'),
      'collectionPoints': v('Collection Points'),
      'tools': v('Tools'),
    });
  }

  return dataElements;
}

Future<void> writeCategories(List<Map<String, dynamic>> dataElements, Map<String, Map<String, dynamic>> groupsMap) async {
  final outputFile = File('assets/data/data_element_categories.json');
  
  // Identify all unique categories used in the elements
  final usedCategoryIds = dataElements.map((e) => e['category'] as String).toSet();
  
  // Build final category list
  final categories = <Map<String, dynamic>>[];
  
  // First, add categories from Groups file if they are used OR if we want to show empty ones (let's show only used for now to be safe, or user might want all)
  // Let's iterate through usedCategoryIds
  
  for (final catId in usedCategoryIds) {
     Map<String, dynamic> catData;
     
     // Find in groupsMap (keyed by Name, but values have ID)
     final groupMatch = groupsMap.values.firstWhere((g) => g['id'] == catId, orElse: () => {});
     
     if (groupMatch.isNotEmpty) {
        catData = {
           'id': groupMatch['id'],
           'name': groupMatch['name'],
           'description': groupMatch['description'],
           'icon': groupMatch['icon'], // The app might not use this yet, but good to have
           'displayOrder': groupMatch['sortOrder'],
        };
     } else {
        // Fallback for categories not in Groups file
        // (This handles the case where deGroup didn't match any Group Name)
        catData = {
           'id': catId,
           'name': catId, // Or try to format it?
           'displayOrder': 999,
        };
     }
     
     // Count elements
     final count = dataElements.where((e) => e['category'] == catId).length;
     catData['elementCount'] = count;
     
     categories.add(catData);
  }

  // Sort by display order then name
  categories.sort((a, b) {
     final orderA = (a['displayOrder'] as int?) ?? 999;
     final orderB = (b['displayOrder'] as int?) ?? 999;
     if (orderA != orderB) return orderA.compareTo(orderB);
     return (a['name'] as String).compareTo(b['name'] as String);
  });

  final jsonString = JsonEncoder.withIndent('  ').convert(categories);
  await outputFile.writeAsString(jsonString);
  print('📁 Written ${categories.length} categories to assets/data/data_element_categories.json');
}

Future<void> writeDataElements(List<Map<String, dynamic>> dataElements) async {
  final outputFile = File('assets/data/data_elements.json');
  final jsonString = JsonEncoder.withIndent('  ').convert(dataElements);
  await outputFile.writeAsString(jsonString);
  print('📁 Written ${dataElements.length} elements to assets/data/data_elements.json');
}


