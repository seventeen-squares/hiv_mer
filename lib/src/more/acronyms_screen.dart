import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AcronymsScreen extends StatelessWidget {
  static const routeName = '/acronyms';

  const AcronymsScreen({super.key});

  // Comprehensive health-related acronyms for NIDS
  static const List<Map<String, String>> acronyms = [
    {'acronym': 'ANC', 'definition': 'Antenatal care'},
    {'acronym': 'ART', 'definition': 'Antiretroviral therapy'},
    {'acronym': 'BCG', 'definition': 'Bacille Calmette-Guérin'},
    {
      'acronym': 'CCMDD',
      'definition': 'Central Chronic Medicines Dispensing and Distribution'
    },
    {'acronym': 'CDC', 'definition': 'Community day centre'},
    {'acronym': 'CD4', 'definition': 'Cluster of differentiation 4'},
    {'acronym': 'CHC', 'definition': 'Community health centre'},
    {'acronym': 'CPT', 'definition': 'Co-trimoxazole prevention therapy'},
    {
      'acronym': 'DTaP-IPV-Hib-HBV',
      'definition':
          'Diphtheria, tetanus, inactivated polio vaccine, haemophilus influenza B, hepatitis vaccine'
    },
    {'acronym': 'EH', 'definition': 'Environmental health'},
    {'acronym': 'EMS', 'definition': 'Emergency medical services'},
    {'acronym': 'EXP', 'definition': 'Experienced'},
    {'acronym': 'HIV', 'definition': 'Human Immunodeficiency Virus'},
    {'acronym': 'IC', 'definition': 'Ideal Clinic'},
    {
      'acronym': 'ICD',
      'definition': 'International Classification of Diseases'
    },
    {'acronym': 'ICU', 'definition': 'Intensive care unit'},
    {'acronym': 'IPT', 'definition': 'Isoniazid Preventive Therapy'},
    {'acronym': 'ISHP', 'definition': 'Integrated School Health Programme'},
    {'acronym': 'IUCD', 'definition': 'Intra-uterine contraceptive device'},
    {'acronym': 'LTF', 'definition': 'Loss/lost to follow-up'},
    {'acronym': 'MAM', 'definition': 'Moderate acute malnutrition'},
    {'acronym': 'MDR', 'definition': 'Multidrug-resistant'},
    {'acronym': 'MUS', 'definition': 'Male urethritis syndrome'},
    {'acronym': 'NAM', 'definition': 'No acute malnutrition'},
    {'acronym': 'NCS', 'definition': 'National Core Standards'},
    {'acronym': 'OHH', 'definition': 'Outreach households'},
    {'acronym': 'OPD', 'definition': 'Outpatient department'},
    {'acronym': 'OPV', 'definition': 'Oral polio vaccine'},
    {'acronym': 'PCR', 'definition': 'Polymerase chain reaction'},
    {'acronym': 'PCV', 'definition': 'Pneumococcal conjugated vaccine'},
    {'acronym': 'PDE', 'definition': 'Patient-day equivalent'},
    {'acronym': 'PHC', 'definition': 'Primary health care'},
    {
      'acronym': 'PPTICRM',
      'definition':
          'Perfect Permanent Team for Ideal Clinic Realisation and Maintenance'
    },
    {'acronym': 'PrEP', 'definition': 'Pre-exposure prophylaxis'},
    {'acronym': 'PSI', 'definition': 'Patient safety incident'},
    {'acronym': 'RIC', 'definition': 'Remaining in care'},
    {'acronym': 'RIP', 'definition': 'Died [rest in peace]'},
    {'acronym': 'RV', 'definition': 'Rotavirus'},
    {'acronym': 'SAC', 'definition': 'Severity assessment code'},
    {'acronym': 'SAM', 'definition': 'Severe acute malnutrition'},
    {'acronym': 'SD', 'definition': 'Standard deviation'},
    {'acronym': 'SLR', 'definition': 'Second-line regimen'},
    {'acronym': 'StatsSA', 'definition': 'Statistics South Africa'},
    {'acronym': 'STH', 'definition': 'Soil-transmitted helminths'},
    {'acronym': 'STI', 'definition': 'Sexually transmitted infections'},
    {'acronym': 'TB', 'definition': 'Tuberculosis'},
    {'acronym': 'Td', 'definition': 'Tetanus and diphtheria'},
    {'acronym': 'TFI', 'definition': 'Transferred in'},
    {'acronym': 'TFO', 'definition': 'Transferred out'},
    {'acronym': 'TLR', 'definition': 'Third-line regimen'},
    {'acronym': 'TROA', 'definition': 'Total remaining on ART'},
    {'acronym': 'VDS', 'definition': 'Vaginal discharge syndrome'},
    {'acronym': 'Vit A', 'definition': 'Vitamin A'},
    {'acronym': 'VLD', 'definition': 'Viral load'},
    {'acronym': 'VLS', 'definition': 'Suppressed viral load'},
    {'acronym': 'XDR', 'definition': 'Extensively drug-resistant'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Custom App Bar - compact version
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16.0,
              right: 16.0,
              bottom: 10.0,
            ),
            decoration: const BoxDecoration(
              color: saGovernmentGreen,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Acronyms',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: acronyms.length,
              itemBuilder: (context, index) {
                final item = acronyms[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: saGovernmentGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['acronym']!,
                        style: const TextStyle(
                          color: saGovernmentGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    title: Text(
                      item['definition']!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
