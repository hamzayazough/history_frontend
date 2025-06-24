import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:history_timeline/core/constants/app_constants.dart';
import 'package:history_timeline/core/theme/app_theme.dart';

class RegionTimelineView extends ConsumerStatefulWidget {
  final String regionId;

  const RegionTimelineView({
    super.key,
    required this.regionId,
  });

  @override
  ConsumerState<RegionTimelineView> createState() => _RegionTimelineViewState();
}

class _RegionTimelineViewState extends ConsumerState<RegionTimelineView> {
  // Mock timeline data - will be replaced with GraphQL data
  final List<TimelineItem> _timelineItems = [
    TimelineItem(
      id: '1',
      type: TimelineItemType.event,
      title: 'Fall of the Roman Empire',
      description:
          'The Western Roman Empire officially ended when Germanic chieftain Odoacer deposed the last Roman emperor.',
      date: DateTime(476),
      imageUrl: null,
    ),
    TimelineItem(
      id: '2',
      type: TimelineItemType.figure,
      title: 'Charlemagne',
      description:
          'King of the Franks and Lombards, later crowned Holy Roman Emperor.',
      date: DateTime(742),
      imageUrl: null,
    ),
    TimelineItem(
      id: '3',
      type: TimelineItemType.event,
      title: 'Norman Conquest of England',
      description:
          'William the Conqueror defeats King Harold II at the Battle of Hastings.',
      date: DateTime(1066),
      imageUrl: null,
    ),
  ];

  String get _regionName {
    // Mock region names - will be replaced with GraphQL data
    switch (widget.regionId) {
      case '1':
        return 'Europe';
      case '2':
        return 'Asia';
      case '3':
        return 'Africa';
      case '4':
        return 'North America';
      case '5':
        return 'South America';
      case '6':
        return 'Oceania';
      default:
        return 'Unknown Region';
    }
  }

  void _onTimelineItemTap(TimelineItem item) {
    if (item.type == TimelineItemType.event) {
      context.go('${RouteNames.eventDetail}/${item.id}');
    } else {
      context.go('${RouteNames.figureDetail}/${item.id}');
    }
  }

  void _onCreateEvent() {
    context.go('${RouteNames.createEvent}?regionId=${widget.regionId}');
  }

  void _onCreateFigure() {
    context.go(RouteNames.createFigure);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_regionName Timeline'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'create_event') {
                _onCreateEvent();
              } else if (value == 'create_figure') {
                _onCreateFigure();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'create_event',
                child: Row(
                  children: [
                    Icon(Icons.event),
                    SizedBox(width: 8),
                    Text('Create Event'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'create_figure',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Create Figure'),
                  ],
                ),
              ),
            ],
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: _timelineItems.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              itemCount: _timelineItems.length,
              itemBuilder: (context, index) {
                final item = _timelineItems[index];
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: AppDimensions.spacing16),
                  child: _TimelineItemCard(
                    item: item,
                    onTap: () => _onTimelineItemTap(item),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timeline,
            size: 64,
            color: AppColors.grey400,
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Text(
            'No events or figures yet',
            style: AppTextStyles.h4.copyWith(
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            'Be the first to add historical content for $_regionName',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacing32),
          ElevatedButton.icon(
            onPressed: _onCreateEvent,
            icon: const Icon(Icons.add),
            label: const Text('Create Event'),
          ),
        ],
      ),
    );
  }
}

class _TimelineItemCard extends StatelessWidget {
  final TimelineItem item;
  final VoidCallback onTap;

  const _TimelineItemCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type Icon
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacing8),
                decoration: BoxDecoration(
                  color: item.type == TimelineItemType.event
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.secondary.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Icon(
                  item.type == TimelineItemType.event
                      ? Icons.event
                      : Icons.person,
                  color: item.type == TimelineItemType.event
                      ? AppColors.primary
                      : AppColors.secondary,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Text(
                      '${item.date.year} CE',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.grey500,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing4),

                    // Title
                    Text(
                      item.title,
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: AppDimensions.spacing8),

                    // Description
                    Text(
                      item.description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: AppDimensions.iconSmall,
                color: AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum TimelineItemType { event, figure }

class TimelineItem {
  final String id;
  final TimelineItemType type;
  final String title;
  final String description;
  final DateTime date;
  final String? imageUrl;

  TimelineItem({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.date,
    this.imageUrl,
  });
}
