#!/usr/bin/env python3
"""
Validate NIDS indicator data integrity
"""

import json
from collections import Counter

def validate_data():
    """Validate indicators and groups data"""
    
    print("🔍 Validating NIDS Data Integrity...\n")
    
    # Load data
    with open('/Users/msuleman/Developer/personal/hiv_mer/assets/data/sa_indicators.json', 'r') as f:
        indicators = json.load(f)
    
    with open('/Users/msuleman/Developer/personal/hiv_mer/assets/data/indicator_groups.json', 'r') as f:
        groups = json.load(f)
    
    # Validate indicators
    print(f"📊 Total Indicators: {len(indicators)}")
    
    # Check required fields
    required_fields = ['renoId', 'groupId', 'indicatorId', 'sortOrder', 'name', 
                      'shortname', 'numerator', 'denominator', 'definition', 
                      'useContext', 'factorType', 'frequency', 'status']
    
    missing_fields = []
    for idx, indicator in enumerate(indicators):
        for field in required_fields:
            if field not in indicator:
                missing_fields.append((idx, field))
    
    if missing_fields:
        print(f"❌ Missing fields: {len(missing_fields)}")
        for idx, field in missing_fields[:5]:
            print(f"   - Indicator {idx}: missing '{field}'")
    else:
        print("✅ All required fields present")
    
    # Check for duplicate indicator IDs
    indicator_ids = [i['indicatorId'] for i in indicators]
    duplicates = [k for k, v in Counter(indicator_ids).items() if v > 1]
    
    if duplicates:
        print(f"⚠️  Duplicate indicator IDs: {len(duplicates)}")
        for dup_id in duplicates[:5]:
            print(f"   - {dup_id}")
    else:
        print("✅ No duplicate indicator IDs")
    
    # Validate groups
    print(f"\n📁 Total Groups: {len(groups)}")
    
    # Check group counts match
    indicator_counts = Counter([i['groupId'] for i in indicators])
    group_counts = {g['id']: g['indicatorCount'] for g in groups}
    
    mismatches = []
    for group_id, count in indicator_counts.items():
        if group_id not in group_counts:
            mismatches.append(f"Group '{group_id}' has {count} indicators but not in groups file")
        elif group_counts[group_id] != count:
            mismatches.append(f"Group '{group_id}': indicators={count}, group file={group_counts[group_id]}")
    
    if mismatches:
        print(f"⚠️  Count mismatches: {len(mismatches)}")
        for mismatch in mismatches[:5]:
            print(f"   - {mismatch}")
    else:
        print("✅ All group counts match")
    
    # Frequency distribution
    frequencies = Counter([i['frequency'] for i in indicators])
    print(f"\n📅 Frequency Distribution:")
    for freq, count in sorted(frequencies.items()):
        print(f"   - {freq}: {count} indicators")
    
    # Status distribution
    statuses = Counter([i['status'] for i in indicators])
    print(f"\n🏷️  Status Distribution:")
    for status, count in sorted(statuses.items()):
        print(f"   - {status}: {count} indicators")
    
    # Factor type distribution
    factors = Counter([i['factorType'] for i in indicators])
    print(f"\n🔢 Factor Type Distribution:")
    for factor, count in sorted(factors.items()):
        print(f"   - {factor}: {count} indicators")
    
    # Top 5 groups by indicator count
    print(f"\n📈 Top 5 Indicator Groups:")
    top_groups = sorted(indicator_counts.items(), key=lambda x: x[1], reverse=True)[:5]
    for group_id, count in top_groups:
        group_name = next((g['name'] for g in groups if g['id'] == group_id), group_id)
        print(f"   - {group_name}: {count} indicators")
    
    print("\n✨ Validation complete!")

if __name__ == '__main__':
    validate_data()
