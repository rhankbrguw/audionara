import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/constants/artist_strings.dart';
import '../../../player/domain/entities/album_meta.dart';
import '../widgets/artist_discography_views.dart';
import '../../../../core/widgets/responsive_wrapper.dart';

class ArtistDiscographyPage extends StatefulWidget {
  final String artistName;
  final List<AlbumMeta> albums;
  final int initialTabIndex;

  const ArtistDiscographyPage({
    super.key,
    required this.artistName,
    required this.albums,
    this.initialTabIndex = 0,
  });

  @override
  State<ArtistDiscographyPage> createState() => _ArtistDiscographyPageState();
}

class _ArtistDiscographyPageState extends State<ArtistDiscographyPage> {
  late int _tabIndex;

  final List<String> _tabs = [
    ArtistStrings.allReleases,
    ArtistStrings.albums,
    ArtistStrings.singlesAndEPs,
    ArtistStrings.compilations,
  ];

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTabIndex;
  }

  List<AlbumMeta> _getFiltered() {
    final list = widget.albums;
    if (_tabIndex == 1) {
      return list.where((a) {
        final t = a.recordType.toLowerCase();
        final isSingleOrEp = t == 'single' || t == 'ep' || (a.trackCount > 0 && a.trackCount <= 3);
        final isCompile = t == 'compile' || a.title.toLowerCase().contains('compilation');
        return (t == 'album' || (t.isEmpty && !isSingleOrEp)) && !isSingleOrEp && !isCompile;
      }).toList();
    }
    if (_tabIndex == 2) {
      return list.where((a) {
        final t = a.recordType.toLowerCase();
        return t == 'single' || t == 'ep' || (a.trackCount > 0 && a.trackCount <= 6) || a.title.toLowerCase().contains('single') || a.title.toLowerCase().contains('ep');
      }).toList();
    }
    if (_tabIndex == 3) {
      return list.where((a) {
        final t = a.recordType.toLowerCase();
        final title = a.title.toLowerCase();
        return t == 'compile' || title.contains('hits') || title.contains('best of') || title.contains('compilation') || title.contains('anthology');
      }).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFiltered();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.artistName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text(ArtistStrings.discography, style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
      body: ResponsiveWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTabs(),
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text(ArtistStrings.noAlbums, style: TextStyle(color: AppColors.textSecondary)))
                  : SingleChildScrollView(child: ArtistDiscographyViews.buildGrid(filtered)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, idx) {
          final isSelected = _tabIndex == idx;
          return ChoiceChip(
            label: Text(_tabs[idx]),
            labelStyle: TextStyle(
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            selected: isSelected,
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.chip),
              side: BorderSide(color: isSelected ? AppColors.primary : AppColors.surfaceVariant),
            ),
            onSelected: (_) => setState(() => _tabIndex = idx),
          );
        },
      ),
    );
  }
}
