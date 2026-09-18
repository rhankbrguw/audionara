import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_prefs_keys.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../player/domain/entities/multi_search_result.dart';
import '../../../player/presentation/bloc/player_bloc.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/mini_player.dart';
import '../widgets/search_page_body.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class SearchPage extends StatefulWidget {
  final String query;

  const SearchPage({super.key, this.query = ''});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  MultiSearchResult? _results;
  List<String> _recentSearches = [];
  bool _isLoading = false;
  String _error = '';
  Timer? _debounce;
  String _selectedFilter = 'All'; // 'All', 'Songs', 'Artists', 'Albums'

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
    if (widget.query.isNotEmpty) {
      _searchController.text = widget.query;
      _commitSearch(widget.query);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _recentSearches = prefs.getStringList(AppPrefsKeys.recentSearches) ?? []);
  }

  Future<void> _saveRecentSearch(String query) async {
    final prefs = await SharedPreferences.getInstance();
    final searches = prefs.getStringList(AppPrefsKeys.recentSearches) ?? [];
    searches..remove(query)..insert(0, query);
    if (searches.length > 10) searches.removeLast();
    await prefs.setStringList(AppPrefsKeys.recentSearches, searches);
    if (!mounted) return;
    setState(() => _recentSearches = searches);
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppPrefsKeys.recentSearches);
    if (!mounted) return;
    setState(() => _recentSearches = []);
  }

  Future<void> _executeSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      setState(() { _results = null; _error = ''; });
      return;
    }
    setState(() { _isLoading = true; _error = ''; });
    try {
      final repo = context.read<PlayerBloc>().searchByVibeUseCase.repository;
      final results = await repo.searchMulti(trimmed);
      if (!mounted) return;
      setState(() { _results = results; _isLoading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() { _error = 'Search failed. Please try again.'; _isLoading = false; });
    }
  }

  Future<void> _commitSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isNotEmpty) {
      _saveRecentSearch(trimmed);
    }
    await _executeSearch(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SearchAppBar(
        searchController: _searchController,
        autofocus: widget.query.isEmpty,
        onSubmitted: _commitSearch,
        onClear: () {
          _searchController.clear();
          setState(() => _results = null);
        },
        onChanged: (val) {
          setState(() {});
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 400), () {
            _executeSearch(val);
          });
        },
      ),
      body: ResponsiveWrapper(
        child: Stack(
          children: [
            Positioned.fill(
              child: SearchPageBody(
                isLoading: _isLoading,
                error: _error,
                results: _results,
                searchQuery: _searchController.text,
                recentSearches: _recentSearches,
                selectedFilter: _selectedFilter,
                onClearRecent: _clearRecentSearches,
                onRecordHistory: _saveRecentSearch,
                onSearch: (q) {
                  _searchController.text = q;
                  _commitSearch(q);
                },
                onFilterSelected: (filter) {
                  setState(() => _selectedFilter = filter);
                },
              ),
            ),
            const Positioned(left: 0, right: 0, bottom: 0, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }
}
