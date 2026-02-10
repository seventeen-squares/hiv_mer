#!/usr/bin/env python3
"""
Transform NIDS CSV data to SA Indicator JSON format
"""

import csv
import json
import sys
from collections import defaultdict

def clean_value(value):
    """Clean and normalize CSV values"""
    if value is None:
        return ""
    value = str(value).strip()
    # Handle None/empty values
    if value.lower() in ['none', 'null', '']:
        return ""
    return value

def determine_status(indicator_group):
    """Determine indicator status based on group"""
    # Default to RETAINED_WITHOUT_NEW for existing indicators
    # This can be refined based on actual status information
    return "RETAINED_WITHOUT_NEW"

def parse_frequency(freq_str):
    """Parse frequency string"""
    freq = clean_value(freq_str)
    if not freq:
        return "Quarterly"
    return freq

def transform_csv_to_json(csv_path, output_path):
    """Transform CSV file to JSON format matching SAIndicator model"""
    
    indicators = []
    groups_data = defaultdict(int)
    seen_uids = set()
    
    # Try different encodings
    encodings = ['utf-8', 'latin-1', 'iso-8859-1', 'cp1252']
    csvfile = None
    
    for encoding in encodings:
        try:
            csvfile = open(csv_path, 'r', encoding=encoding, errors='replace')
            reader = csv.DictReader(csvfile)
            break
        except Exception as e:
            if csvfile:
                csvfile.close()
            continue
    
    if not csvfile:
        raise Exception("Could not open CSV file with any supported encoding")
    
    try:
        reader = csv.DictReader(csvfile)
        
        for idx, row in enumerate(reader, start=1):
            # Skip rows without indicator ID
            uid = clean_value(row.get('UID', ''))
            if not uid:
                continue
                
            # Extract and clean data
            reno = clean_value(row.get('Reno', ''))
            indicator_group = clean_value(row.get('Indicator Group', ''))
            sort_order_str = clean_value(row.get('Sort Order', ''))
            indicator_name = clean_value(row.get('Indicator Name', ''))
            numerator_desc = clean_value(row.get('Numerator Description', ''))
            numerator = clean_value(row.get('Numerator', ''))
            numerator_formula = clean_value(row.get('Numerator Formula', ''))
            denominator = clean_value(row.get('Denominator', ''))
            denominator_formula = clean_value(row.get('Denominator Formula', ''))
            definition = clean_value(row.get('Definition', ''))
            use_context = clean_value(row.get('Use and Context', ''))
            factor = clean_value(row.get('Factor', ''))
            frequency = parse_frequency(row.get('Freq', ''))
            
            # Generate group ID from indicator group name
            group_id = indicator_group.lower().replace(' ', '_').replace('/', '_')
            if not group_id:
                group_id = 'ungrouped'
            
            # Handle invalid or duplicate UIDs
            if uid.lower() in ['old', 'new'] or len(uid) < 5 or uid in seen_uids:
                # Generate a unique ID based on name and index
                uid = f"NIDS_{group_id}_{idx:03d}"
            
            seen_uids.add(uid)
            
            # Use sort order or generate sequential
            try:
                sort_order = int(sort_order_str) if sort_order_str else idx
            except ValueError:
                sort_order = idx
            
            # Count indicators per group
            if group_id:
                groups_data[group_id] += 1
            
            # Create indicator object
            indicator = {
                "renoId": reno if reno else "",
                "groupId": group_id,
                "indicatorId": uid,
                "sortOrder": sort_order,
                "name": indicator_name,
                "shortname": numerator_desc if numerator_desc else indicator_name,
                "numerator": numerator,
                "numeratorFormula": numerator_formula if numerator_formula else None,
                "denominator": denominator if denominator else "Not applicable",
                "denominatorFormula": denominator_formula if denominator_formula else None,
                "definition": definition if definition else "No definition available",
                "useContext": use_context if use_context else "",
                "factorType": factor if factor else "No",
                "frequency": frequency,
                "status": determine_status(indicator_group)
            }
            
            indicators.append(indicator)
    finally:
        if csvfile:
            csvfile.close()
    
    # Write indicators JSON
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(indicators, f, indent=2, ensure_ascii=False)
    
    print(f"✅ Transformed {len(indicators)} indicators")
    print(f"✅ Output written to: {output_path}")
    
    # Generate groups summary
    groups_summary = []
    for group_id, count in sorted(groups_data.items()):
        group_name = group_id.replace('_', ' ').title()
        groups_summary.append({
            "id": group_id,
            "name": group_name,
            "count": count
        })
    
    print(f"\n📊 Indicator Groups Summary:")
    for group in groups_summary:
        print(f"   - {group['name']}: {group['count']} indicators")
    
    return indicators, groups_summary

def create_groups_json(groups_summary, output_path):
    """Create indicator groups JSON file"""
    
    groups = []
    for idx, group_data in enumerate(groups_summary, start=1):
        group = {
            "id": group_data['id'],
            "name": group_data['name'],
            "displayOrder": idx,
            "subGroups": [],
            "indicatorCount": group_data['count']
        }
        groups.append(group)
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(groups, f, indent=2, ensure_ascii=False)
    
    print(f"\n✅ Created {len(groups)} indicator groups")
    print(f"✅ Groups written to: {output_path}")

if __name__ == '__main__':
    csv_path = '/Users/msuleman/Downloads/second.csv'
    indicators_output = '/Users/msuleman/Developer/personal/hiv_mer/assets/data/sa_indicators.json'
    groups_output = '/Users/msuleman/Developer/personal/hiv_mer/assets/data/indicator_groups.json'
    
    print("🔄 Transforming NIDS CSV data...\n")
    
    try:
        indicators, groups_summary = transform_csv_to_json(csv_path, indicators_output)
        create_groups_json(groups_summary, groups_output)
        
        print("\n✨ Data transformation complete!")
        print(f"\n📈 Statistics:")
        print(f"   Total Indicators: {len(indicators)}")
        print(f"   Total Groups: {len(groups_summary)}")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
