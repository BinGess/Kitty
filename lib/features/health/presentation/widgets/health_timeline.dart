import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/health_record.dart';

class HealthTimeline extends StatelessWidget {
  final List<HealthTimelineEntry> entries;
  final void Function(HealthTimelineEntry entry)? onDelete;

  const HealthTimeline({super.key, required this.entries, this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.timeline,
                  size: 48, color: AppColors.textSecondary.withValues(alpha: 0.4)),
              const SizedBox(height: 12),
              const Text(
                '今天还没有记录\n点击右下角 + 开始记录吧',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final isLast = index == entries.length - 1;
        return Dismissible(
          key: ValueKey('${entry.type.name}_${entry.id}'),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.delete_outline,
                color: AppColors.error, size: 22),
          ),
          confirmDismiss: (_) async {
            return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('确认删除'),
                content: const Text('确定要删除这条记录吗？'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('取消'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('删除',
                        style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            );
          },
          onDismissed: (_) => onDelete?.call(entry),
          child: _TimelineItem(entry: entry, isLast: isLast),
        );
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final HealthTimelineEntry entry;
  final bool isLast;

  const _TimelineItem({required this.entry, required this.isLast});

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 50,
            child: Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Text(
                _formatTime(entry.recordedAt),
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 14),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: entry.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: entry.color.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: AppColors.divider,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: entry.isWarning
                    ? AppColors.error.withValues(alpha: 0.08)
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: entry.isWarning
                    ? Border.all(
                        color: AppColors.error.withValues(alpha: 0.3))
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onBackground.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: entry.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(entry.icon, size: 18, color: entry.color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onBackground,
                          ),
                        ),
                        if (entry.subtitle.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              entry.subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (entry.isWarning)
                    const Icon(Icons.error_outline,
                        size: 18, color: AppColors.error),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
