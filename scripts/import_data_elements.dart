#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script to import data elements from CSV to JSON format
/// Usage: dart scripts/import_data_elements.dart <csv_file_path>

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Usage: dart scripts/import_data_elements.dart <csv_file_path>');
    print(
        'Example: dart scripts/import_data_elements.dart ~/Downloads/data_elements.csv');
    exit(1);
  }

  final csvFilePath = arguments[0];
  final csvFile = File(csvFilePath);

  if (!await csvFile.exists()) {
    print('Error: CSV file not found at $csvFilePath');
    exit(1);
  }

  print('📂 Reading CSV file: $csvFilePath');

  try {
    String csvContent;

    // Try different encodings
    try {
      csvContent = await csvFile.readAsString(encoding: utf8);
    } catch (e) {
      print('⚠️  UTF-8 failed, trying Latin-1 encoding...');
      try {
        csvContent = await csvFile.readAsString(encoding: latin1);
      } catch (e2) {
        print('⚠️  Latin-1 failed, trying system encoding...');
        csvContent = await csvFile.readAsString();
      }
    }

    final dataElements = parseCSV(csvContent);

    print('✅ Parsed ${dataElements.length} data elements');

    // Generate data elements JSON
    await writeDataElements(dataElements);

    // Generate categories JSON
    await writeCategories(dataElements);

    print('🎉 Import completed successfully!');
    print('📊 Generated files:');
    print('   - assets/data/data_elements.json');
    print('   - assets/data/data_element_categories.json');
  } catch (e) {
    print('❌ Error importing data: $e');
    exit(1);
  }
}

List<Map<String, dynamic>> parseCSV(String csvContent) {
  final lines = csvContent.split('\n');
  if (lines.isEmpty) {
    throw Exception('CSV file is empty');
  }

  // Parse header
  final header = parseCSVLine(lines[0]);
  print('📋 CSV Headers: ${header.join(', ')}');

  // Map header indices
  final headerMap = <String, int>{};
  for (int i = 0; i < header.length; i++) {
    headerMap[header[i]] = i;
  }

  final dataElements = <Map<String, dynamic>>[];

  for (int i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;

    final values = parseCSVLine(line);
    
    // Pad values if they are shorter than header
    if (values.length < header.length) {
      final missing = header.length - values.length;
      if (values.length < 10) { // arbitrary threshold to avoid totally broken lines
         print('⚠️  Warning: Line ${i + 1} has ${values.length} values but expected ${header.length}');
         // Don't skip, just warn if very short, but we will pad anyway
      }
      for (int k = 0; k < missing; k++) {
        values.add('');
      }
    }

    // Skip rows where DEGroup is empty or just a comma
    final deGroup = getValue(values, headerMap, 'DEGroup');
    if (deGroup.isEmpty) continue;

    final uid = getValue(values, headerMap, 'UID');
    final shortname = getValue(values, headerMap, 'Shortname');
    final dataElementName = getValue(values, headerMap, 'DataElementName');

    // Skip rows with missing critical data
    if (uid.isEmpty || shortname.isEmpty || dataElementName.isEmpty) {
      print(
          '⚠️  Skipping line ${i + 1}: Missing critical data (UID, Shortname, or DataElementName)');
      continue;
    }

    final dataElement = {
      'id': uid,
      'name': dataElementName,
      'shortname': shortname,
      'definition': getValue(values, headerMap, 'Definition'),
      'category': deGroup,
      'dataType': 'Number', // Default value
      'aggregationType': 'Sum', // Default value
      'status': determineStatus(
          shortname, dataElementName), // Determine based on content
      'definitionExtended': getValue(values, headerMap, 'Definition_Extended'),
      'useAndContext': getValue(values, headerMap, 'Use and Context'),
      'inclusions': getValue(values, headerMap, 'Inclusions'),
      'exclusions': getValue(values, headerMap, 'Exclusions'),
      'frequency': getValue(values, headerMap, 'Freq'),
      'collectedBy': getValue(values, headerMap, 'Collected By'),
      'collectionPoints': getValue(values, headerMap, 'Collection Points'),
      'tools': getValue(values, headerMap, 'Tools'),
    };

    dataElements.add(dataElement);
  }

  return dataElements;
}

List<String> parseCSVLine(String line) {
  final values = <String>[];
  final buffer = StringBuffer();
  bool inQuotes = false;

  for (int i = 0; i < line.length; i++) {
    final char = line[i];

    if (char == '"') {
      inQuotes = !inQuotes;
    } else if (char == ',' && !inQuotes) {
      values.add(buffer.toString().trim());
      buffer.clear();
    } else {
      buffer.write(char);
    }
  }

  values.add(buffer.toString().trim());
  return values;
}

String getValue(
    List<String> values, Map<String, int> headerMap, String header) {
  final index = headerMap[header];
  if (index == null || index >= values.length) {
    return '';
  }

  String value = values[index].trim();

  // Remove surrounding quotes if present
  if (value.startsWith('"') && value.endsWith('"')) {
    value = value.substring(1, value.length - 1);
  }

  // Clean up common problematic values
  if (value.toLowerCase() == 'none' || value.isEmpty) {
    return '';
  }

  return value;
}

String determineStatus(String shortname, String dataElementName) {
  final text = '$shortname $dataElementName'.toLowerCase();

  if (text.contains('new ') || shortname.toUpperCase().startsWith('NEW')) {
    return 'new';
  } else if (text.contains('amended') || text.contains('updated')) {
    return 'amended';
  } else {
    return 'retained';
  }
}

Future<void> writeDataElements(List<Map<String, dynamic>> dataElements) async {
  final outputFile = File('assets/data/data_elements.json');

  // Ensure directory exists
  await outputFile.parent.create(recursive: true);

  // Sort by category and then by name for better organization
  dataElements.sort((a, b) {
    final categoryCompare =
        (a['category'] as String).compareTo(b['category'] as String);
    if (categoryCompare != 0) return categoryCompare;
    return (a['name'] as String).compareTo(b['name'] as String);
  });

  final jsonString = JsonEncoder.withIndent('  ').convert(dataElements);
  await outputFile.writeAsString(jsonString);

  print(
      '📝 Written ${dataElements.length} data elements to ${outputFile.path}');
}

Future<void> writeCategories(List<Map<String, dynamic>> dataElements) async {
  final outputFile = File('assets/data/data_element_categories.json');

  // Count elements by category
  final categoryCount = <String, int>{};
  for (final element in dataElements) {
    final category = element['category'] as String;
    categoryCount[category] = (categoryCount[category] ?? 0) + 1;
  }

  // Create category objects
  final categories = <Map<String, dynamic>>[];
  int displayOrder = 1;

  // Sort categories alphabetically
  final sortedCategories = categoryCount.keys.toList()..sort();

  for (final categoryId in sortedCategories) {
    final count = categoryCount[categoryId]!;

    categories.add({
      'id': categoryId,
      'name': formatCategoryName(categoryId),
      'elementCount': count,
      'displayOrder': displayOrder++,
    });
  }

  final jsonString = JsonEncoder.withIndent('  ').convert(categories);
  await outputFile.writeAsString(jsonString);

  print('📁 Written ${categories.length} categories to ${outputFile.path}');

  // Print summary
  print('\n📊 Category Summary:');
  for (final category in categories) {
    print('   ${category['name']}: ${category['elementCount']} elements');
  }
}

String formatCategoryName(String categoryId) {
  // Convert category ID to a proper display name
  switch (categoryId.toLowerCase()) {
    case 'art baseline':
      return 'ART Baseline';
    case 'art monthly':
      return 'ART Monthly';
    case 'art outcome':
      return 'ART Outcome';
    case 'ccmdd':
      return 'Central Chronic Medicines Dispensing and Distribution (CCMDD)';
    case 'child and nutrition':
      return 'Child and Nutrition';
    case 'adolescent health':
      return 'Adolescent Health';
    case 'chronic medicine':
      return 'Chronic Medicine';
    case 'communicable':
      return 'Communicable Diseases';
    case 'emergency':
      return 'Emergency Services';
    case 'environmental':
      return 'Environmental Health';
    case 'epi':
      return 'Epidemiology and Immunization';
    case 'epi campaign':
      return 'EPI Campaign';
    case 'eye':
      return 'Eye Care Services';
    case 'hiv':
      return 'HIV Prevention and Care';
    case 'hpv campaign':
      return 'HPV Campaign';
    case 'malaria':
      return 'Malaria Prevention and Treatment';
    case 'inpatient':
      return 'Inpatient Services';
    case 'phc':
      return 'Primary Health Care';
    case 'mental':
      return 'Mental Health Services';
    case 'oral':
      return 'Oral Health Services';
    default:
      // Capitalize first letter of each word
      return categoryId
          .split(' ')
          .map((word) => word.isEmpty
              ? word
              : word[0].toUpperCase() + word.substring(1).toLowerCase())
          .join(' ');
  }
}
