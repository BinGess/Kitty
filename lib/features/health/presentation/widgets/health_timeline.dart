import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../data/models/health_record.dart';

class HealthTimeline extends StatelessWidget {
  final List<HealthTimelineEntry> entries;
  final void Function(HealthTimelineEntry entry)? onDelete;

  const HealthTimeline({super.key, required this.entries, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.timeline,
                  size: 48, color: AppColors.textSecondary.withValues(alpha: 0.4)),
              const SizedBox(height: 12),
              Text(
                l10n.healthTimelineEmpty,
                textAlign: TextAlign.center,
                style: const TextStyle(
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
              builder: (ctx) {
                final dl10n = AppLocalizations.of(ctx)!;
                return AlertDialog(
                  title: Text(dl10n.healthTimelineDeleteTitle),
                  content: Text(dl10n.healthTimelineDeleteContent),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: Text(dl10n.commonCancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: Text(dl10n.commonDelete,
                          style: const TextStyle(color: AppColors.error)),
                    ),
                  ],
                );
              },
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

  String _buildTitle(AppLocalizations l10n) {
    final v = entry.numericValue;
    switch (entry.type) {
      case HealthRecordType.weight:
        return v != null ? l10n.healthTimelineWeight(v.toStringAsFixed(2)) : l10n.healthWeight;
      case HealthRecordType.diet:
        return v != null ? l10n.healthTimelineDiet(v.toStringAsFixed(0)) : l10n.healthDiet;
      case HealthRecordType.water:
        return v != null ? l10n.healthTimelineWater(v.toStringAsFixed(0)) : l10n.healthWater;
      case HealthRecordType.excretion:
        return entry.subtype == 'poop' ? l10n.healthTimelinePoop : l10n.healthTimelineUrine;
    }
  }

  String _buildSubtitle(AppLocalizations l10n) {
    if (entry.subtitle.isNotEmpty) return entry.subtitle;
    if (entry.type == HealthRecordType.excretion) {
      final scale = entry.numericValue?.toInt();
      if (entry.subtype == 'poop' && scale != null) {
        switch (scale) {
          case 1: return l10n.excretionPoop1Name;
          case 2: return l10n.excretionPoop2Name;
          case 3: return l10n.excretionPoop3Name;
          case 4: return l10n.excretionPoop4Name;
        }
      } else if (entry.subtype == 'urine' && scale != null) {
        switch (scale) {
          case 1: return l10n.excretionUrineSmall;
          case 2: return l10n.excretionUrineMedium;
          case 3: return l10n.excretionUrineLarge;
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _buildTitle(l10n);
    final subtitle = _buildSubtitle(l10n);
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
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onBackground,
                          ),
                        ),
                        if (subtitle.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              subtitle,
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
