import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:history_timeline/core/constants/app_constants.dart';
import 'package:history_timeline/core/theme/app_theme.dart';

class FigureDetailView extends ConsumerStatefulWidget {
  final String figureId;

  const FigureDetailView({
    super.key,
    required this.figureId,
  });

  @override
  ConsumerState<FigureDetailView> createState() => _FigureDetailViewState();
}

class _FigureDetailViewState extends ConsumerState<FigureDetailView> {
  bool _isLiked = false;
  bool _isDisliked = false;
  int _likesCount = 28;
  int _dislikesCount = 1;

  // Mock figure data - will be replaced with GraphQL data
  final FigureDetailData _figure = FigureDetailData(
    id: '2',
    name: 'Charlemagne',
    description:
        '''Charlemagne (742-814 CE), also known as Charles the Great, was King of the Franks from 768, King of the Lombards from 774, and Holy Roman Emperor from 800 until his death.

He united much of Western and Central Europe during the Early Middle Ages. He was the first recognized emperor to rule from western Europe since the fall of the Western Roman Empire around three centuries earlier.

Key achievements:
• Expanded the Frankish kingdom into an empire
• Promoted the Carolingian Renaissance
• Established the Holy Roman Empire
• Promoted Christianity throughout his empire
• Created a unified legal system

Charlemagne's reign marked the beginning of a new era in European history, bridging the gap between the ancient world and medieval Europe.''',
    imageUrl: 'https://example.com/charlemagne.jpg',
    sourceUrl: 'https://example.com/source',
    creator: 'MedievalExpert',
    createdAt: DateTime.now().subtract(const Duration(days: 45)),
    relatedEvents: [
      RelatedEventData(
        id: '1',
        title: 'Coronation as Holy Roman Emperor',
        description:
            'Charlemagne was crowned by Pope Leo III on Christmas Day, 800 CE',
        date: DateTime(800),
        relationDescription: 'Major milestone in his reign',
      ),
      RelatedEventData(
        id: '2',
        title: 'Battle of Roncevaux Pass',
        description:
            'Frankish rearguard defeated by Basques while retreating from Spain',
        date: DateTime(778),
        relationDescription: 'Led the campaign personally',
      ),
    ],
  );

  final List<CommentData> _comments = [
    CommentData(
      id: '1',
      text: 'One of the most influential rulers in European history!',
      author: 'HistoryBuff',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Figure Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'report') {
                // TODO: Implement report functionality
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
                  if (_figure.imageUrl != null)
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusLarge),
                      child: CachedNetworkImage(
                        imageUrl: _figure.imageUrl!,
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
                  if (_figure.imageUrl != null)
                    const SizedBox(height: AppDimensions.spacing16),

                  // Name
                  Text(
                    _figure.name,
                    style: AppTextStyles.h2,
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
                        'Created by ${_figure.creator}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing24),

                  // Description
                  Text(
                    _figure.description,
                    style: AppTextStyles.bodyLarge,
                  ),
                  const SizedBox(height: AppDimensions.spacing32),

                  // Related Events
                  if (_figure.relatedEvents.isNotEmpty) ...[
                    Text(
                      'Related Events',
                      style: AppTextStyles.h4,
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _figure.relatedEvents.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppDimensions.spacing12),
                      itemBuilder: (context, index) {
                        final event = _figure.relatedEvents[index];
                        return _RelatedEventCard(event: event);
                      },
                    ),
                    const SizedBox(height: AppDimensions.spacing32),
                  ],

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
                if (_figure.sourceUrl != null)
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

class _RelatedEventCard extends StatelessWidget {
  final RelatedEventData event;

  const _RelatedEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    event.title,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  '${event.date.year} CE',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              event.relationDescription,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.secondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              event.description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ],
        ),
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

class FigureDetailData {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final String? sourceUrl;
  final String creator;
  final DateTime createdAt;
  final List<RelatedEventData> relatedEvents;

  FigureDetailData({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.sourceUrl,
    required this.creator,
    required this.createdAt,
    required this.relatedEvents,
  });
}

class RelatedEventData {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String relationDescription;

  RelatedEventData({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.relationDescription,
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
