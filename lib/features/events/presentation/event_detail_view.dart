import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:history_timeline/core/constants/app_constants.dart';
import 'package:history_timeline/core/theme/app_theme.dart';

class EventDetailView extends ConsumerStatefulWidget {
  final String eventId;

  const EventDetailView({
    super.key,
    required this.eventId,
  });

  @override
  ConsumerState<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends ConsumerState<EventDetailView> {
  bool _isLiked = false;
  bool _isDisliked = false;
  int _likesCount = 42;
  int _dislikesCount = 3;
  bool _isLoading = false;

  // Mock event data - will be replaced with GraphQL data
  final EventDetailData _event = EventDetailData(
    id: '1',
    title: 'Fall of the Roman Empire',
    description:
        '''The Western Roman Empire officially ended when Germanic chieftain Odoacer deposed the last Roman emperor of the west, Romulus Augustulus, in 476 CE. This event marked the end of over 1000 years of Roman rule in Western Europe.

The fall was not sudden but rather a gradual decline over several centuries. Factors contributing to the fall included:

• Political instability and civil wars
• Economic troubles and inflation
• Barbarian invasions and migrations
• Military challenges and recruitment issues
• Administrative difficulties in governing such a vast territory

The Eastern Roman Empire, later known as the Byzantine Empire, continued to exist for another thousand years until the fall of Constantinople in 1453.''',
    startDate: DateTime(476),
    endDate: null,
    imageUrl: 'https://example.com/roman-empire.jpg',
    sourceUrl: 'https://example.com/source',
    region: 'Europe',
    creator: 'HistoryExpert42',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
  );

  final List<CommentData> _comments = [
    CommentData(
      id: '1',
      text:
          'Very informative! The decline of Rome is such a fascinating topic.',
      author: 'HistoryLover',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    CommentData(
      id: '2',
      text:
          'I would argue that the eastern empire\'s continuation shows Rome didn\'t truly "fall" in 476.',
      author: 'ByzantineScholar',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  void _toggleLike() {
    setState(() {
      if (_isLiked) {
        _isLiked = false;
        _likesCount--;
      } else {
        _isLiked = true;
        _likesCount++;
        if (_isDisliked) {
          _isDisliked = false;
          _dislikesCount--;
        }
      }
    });
    // TODO: Call GraphQL mutation
  }

  void _toggleDislike() {
    setState(() {
      if (_isDisliked) {
        _isDisliked = false;
        _dislikesCount--;
      } else {
        _isDisliked = true;
        _dislikesCount++;
        if (_isLiked) {
          _isLiked = false;
          _likesCount--;
        }
      }
    });
    // TODO: Call GraphQL mutation
  }

  void _showCommentDialog() {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Comment'),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: 'Enter your comment...',
          ),
          maxLines: 3,
          maxLength: AppConstants.maxCommentLength,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (commentController.text.trim().isNotEmpty) {
                _addComment(commentController.text.trim());
                Navigator.of(context).pop();
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _addComment(String text) {
    setState(() {
      _comments.insert(
        0,
        CommentData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: text,
          author: 'You',
          createdAt: DateTime.now(),
        ),
      );
    });
    // TODO: Call GraphQL mutation
  }

  void _reportContent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Content'),
        content: const Text('Are you sure you want to report this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement report functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report submitted')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Report'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                _reportContent();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag, color: AppColors.error),
                    SizedBox(width: 8),
                    Text('Report'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image (if available)
                  if (_event.imageUrl != null)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLarge),
                      child: CachedNetworkImage(
                        imageUrl: _event.imageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 200,
                          color: AppColors.grey200,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          color: AppColors.grey200,
                          child: const Icon(Icons.error),
                        ),
                      ),
                    ),
                  if (_event.imageUrl != null)
                    const SizedBox(height: AppDimensions.spacing16),

                  // Title
                  Text(
                    _event.title,
                    style: AppTextStyles.h2,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),

                  // Metadata
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: AppDimensions.iconSmall,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(width: AppDimensions.spacing4),
                      Text(
                        '${_event.startDate.year} CE',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacing16),
                      Icon(
                        Icons.location_on,
                        size: AppDimensions.iconSmall,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(width: AppDimensions.spacing4),
                      Text(
                        _event.region,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing8),

                  // Creator info
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: AppDimensions.iconSmall,
                        color: AppColors.grey500,
                      ),
                      const SizedBox(width: AppDimensions.spacing4),
                      Text(
                        'Created by ${_event.creator}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing24),

                  // Description
                  Text(
                    _event.description,
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: AppDimensions.spacing32),

                  // Comments Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Comments (${_comments.length})',
                        style: AppTextStyles.h4,
                      ),
                      TextButton.icon(
                        onPressed: _showCommentDialog,
                        icon: const Icon(Icons.add_comment),
                        label: const Text('Add Comment'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing16),

                  // Comments List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: AppDimensions.spacing12),
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return _CommentCard(comment: comment);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Like/Dislike Bar
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.grey200),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _toggleLike,
                        icon: Icon(
                          _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                          color: _isLiked ? AppColors.like : AppColors.grey500,
                        ),
                      ),
                      Text('$_likesCount'),
                      const SizedBox(width: AppDimensions.spacing16),
                      IconButton(
                        onPressed: _toggleDislike,
                        icon: Icon(
                          _isDisliked
                              ? Icons.thumb_down
                              : Icons.thumb_down_outlined,
                          color: _isDisliked
                              ? AppColors.dislike
                              : AppColors.grey500,
                        ),
                      ),
                      Text('$_dislikesCount'),
                    ],
                  ),
                ),
                if (_event.sourceUrl != null)
                  OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Open URL
                    },
                    icon: const Icon(Icons.link),
                    label: const Text('Source'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final CommentData comment;

  const _CommentCard({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                comment.author,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                _formatDate(comment.createdAt),
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            comment.text,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
  }
}

class EventDetailData {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate;
  final String? imageUrl;
  final String? sourceUrl;
  final String region;
  final String creator;
  final DateTime createdAt;

  EventDetailData({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    this.imageUrl,
    this.sourceUrl,
    required this.region,
    required this.creator,
    required this.createdAt,
  });
}

class CommentData {
  final String id;
  final String text;
  final String author;
  final DateTime createdAt;

  CommentData({
    required this.id,
    required this.text,
    required this.author,
    required this.createdAt,
  });
}
