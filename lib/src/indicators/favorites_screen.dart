import 'package:flutter/material.dart';
import '../models/sa_indicator.dart';
import '../services/sa_indicator_service.dart';
import '../services/favorites_service.dart';
import '../utils/constants.dart';

import 'indicator_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/Favourites';

  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

enum SortOption { nameAsc, nameDesc }
enum FilterOption { all, newItems, amended, retained }

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _indicatorService = SAIndicatorService.instance;
  final _favoritesService = FavoritesService.instance;

  List<SAIndicator> _favoriteIndicators = [];
  List<SAIndicator> _filteredIndicators = [];
  
  bool _isLoading = true;
  String? _error;
  
  // Selection Mode
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};
  
  // Sort & Filter
  SortOption _sortOption = SortOption.nameAsc;
  FilterOption _filterOption = FilterOption.all;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Ensure indicators are loaded
      if (!_indicatorService.isLoaded) {
        await _indicatorService.loadIndicators();
      }

      // Get favorite IDs
      final favoriteIds = await _favoritesService.getFavoriteIds();

      // Get indicator objects
      final favorites = <SAIndicator>[];
      for (final id in favoriteIds) {
        final indicator = _indicatorService.getIndicatorById(id);
        if (indicator != null) {
          favorites.add(indicator);
        }
      }

      setState(() {
        _favoriteIndicators = favorites;
        _applySortAndFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applySortAndFilter() {
    var result = List<SAIndicator>.from(_favoriteIndicators);

    // Filter
    if (_filterOption != FilterOption.all) {
      result = result.where((i) {
        switch (_filterOption) {
          case FilterOption.newItems:
            return i.status == IndicatorStatus.newIndicator;
          case FilterOption.amended:
            return i.status == IndicatorStatus.amended;
          case FilterOption.retained:
            return i.status == IndicatorStatus.retainedWithNew || 
                   i.status == IndicatorStatus.retainedWithoutNew;
          default:
            return true;
        }
      }).toList();
    }

    // Sort
    result.sort((a, b) {
      switch (_sortOption) {
        case SortOption.nameAsc:
          return a.name.compareTo(b.name);
        case SortOption.nameDesc:
          return b.name.compareTo(a.name);
      }
    });

    _filteredIndicators = result;
  }

  Future<void> _removeFavorite(SAIndicator indicator) async {
    await _favoritesService.removeFavorite(indicator.indicatorId);
    await _loadFavorites();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${indicator.shortname} removed from Favourites'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () async {
              await _favoritesService.addFavorite(indicator.indicatorId);
              await _loadFavorites();
            },
          ),
        ),
      );
    }
  }

  Future<void> _deleteSelected() async {
    final count = _selectedIds.length;
    if (count == 0) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove $count Indicators?'),
        content: const Text(
          'Are you sure you want to remove the selected indicators from your favourites?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'REMOVE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      for (final id in _selectedIds) {
        await _favoritesService.removeFavorite(id);
      }

      setState(() {
        _isSelectionMode = false;
        _selectedIds.clear();
      });

      await _loadFavorites();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$count indicators removed from Favourites'),
          ),
        );
      }
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Custom App Bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16.0,
              right: 16.0,
              bottom: 10.0,
            ),
            decoration: BoxDecoration(
              color: _isSelectionMode ? Colors.white : saGovernmentGreen,
              boxShadow: _isSelectionMode
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : null,
            ),
            child: Row(
              children: [
                if (_isSelectionMode)
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isSelectionMode = false;
                        _selectedIds.clear();
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.black87),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                else
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isSelectionMode
                            ? '${_selectedIds.length} Selected'
                            : 'Favourites',
                        style: TextStyle(
                          color:
                              _isSelectionMode ? Colors.black87 : Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!_isSelectionMode && _favoriteIndicators.isNotEmpty)
                        Text(
                          '${_filteredIndicators.length} indicators',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),
                if (_isSelectionMode)
                  IconButton(
                    onPressed: _deleteSelected,
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    tooltip: 'Delete Selected',
                  )
                else if (_favoriteIndicators.isNotEmpty) ...[
                  PopupMenuButton<FilterOption>(
                    icon: const Icon(Icons.filter_list, color: Colors.white),
                    tooltip: 'Filter',
                    onSelected: (value) {
                      setState(() {
                        _filterOption = value;
                        _applySortAndFilter();
                      });
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: FilterOption.all,
                        child: Text('All Indicators'),
                      ),
                      const PopupMenuItem(
                        value: FilterOption.newItems,
                        child: Text('New Only'),
                      ),
                      const PopupMenuItem(
                        value: FilterOption.amended,
                        child: Text('Amended Only'),
                      ),
                      const PopupMenuItem(
                        value: FilterOption.retained,
                        child: Text('Retained Only'),
                      ),
                    ],
                  ),
                  PopupMenuButton<SortOption>(
                    icon: const Icon(Icons.sort, color: Colors.white),
                    tooltip: 'Sort',
                    onSelected: (value) {
                      setState(() {
                        _sortOption = value;
                        _applySortAndFilter();
                      });
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: SortOption.nameAsc,
                        child: Text('Name (A-Z)'),
                      ),
                      const PopupMenuItem(
                        value: SortOption.nameDesc,
                        child: Text('Name (Z-A)'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading Favourites',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadFavorites,
                child: const Text('RETRY'),
              ),
            ],
          ),
        ),
      );
    }

    if (_favoriteIndicators.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No Favourites Yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap the heart icon on any indicator to save it here for quick access.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredIndicators.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_list_off, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No indicators match the current filter',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFavorites,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _filteredIndicators.length,
        itemBuilder: (context, index) {
          final indicator = _filteredIndicators[index];
          return _buildIndicatorCard(indicator);
        },
      ),
    );
  }

  Widget _buildIndicatorCard(SAIndicator indicator) {
    final isSelected = _selectedIds.contains(indicator.indicatorId);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? saGovernmentGreen.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? saGovernmentGreen : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          if (_isSelectionMode) {
            _toggleSelection(indicator.indicatorId);
          } else {
            Navigator.of(context)
                .pushNamed(
              IndicatorDetailScreen.routeName,
              arguments: indicator,
            )
                .then((_) {
              // Refresh favorites when returning from detail screen
              _loadFavorites();
            });
          }
        },
        onLongPress: () {
          if (!_isSelectionMode) {
            setState(() {
              _isSelectionMode = true;
            });
            _toggleSelection(indicator.indicatorId);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStatusBadge(indicator.status),
                  const Spacer(),
                  if (_isSelectionMode)
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? saGovernmentGreen : Colors.grey,
                    )
                  else
                    IconButton(
                      onPressed: () => _removeFavorite(indicator),
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 20,
                      ),
                      tooltip: 'Remove from Favourites',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minHeight: 24,
                        minWidth: 24,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                indicator.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              if (indicator.shortname.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  indicator.shortname,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    'Freq: ${indicator.frequency}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.science_outlined,
                      size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(
                    'Unit: ${indicator.factorType}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(IndicatorStatus status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case IndicatorStatus.newIndicator:
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF166534);
        label = 'NEW';
        break;
      case IndicatorStatus.amended:
        bgColor = const Color(0xFFDBEAFE);
        textColor = const Color(0xFF1E40AF);
        label = 'AMENDED';
        break;
      case IndicatorStatus.retainedWithNew:
        bgColor = const Color(0xFFFED7AA);
        textColor = const Color(0xFF9A3412);
        label = 'RETAINED+';
        break;
      case IndicatorStatus.retainedWithoutNew:
        bgColor = const Color(0xFFF3F4F6);
        textColor = const Color(0xFF4B5563);
        label = 'RETAINED';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
