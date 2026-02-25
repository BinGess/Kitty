import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/l10n/app_localizations.dart';

class HealthFab extends StatefulWidget {
  final VoidCallback onDiet;
  final VoidCallback onWater;
  final VoidCallback onWeight;
  final VoidCallback onExcretion;

  const HealthFab({
    super.key,
    required this.onDiet,
    required this.onWater,
    required this.onWeight,
    required this.onExcretion,
  });

  @override
  State<HealthFab> createState() => _HealthFabState();
}

class _HealthFabState extends State<HealthFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _open = false;

  List<_FabItem> _buildItems(AppLocalizations l10n) => [
    _FabItem(icon: Icons.restaurant, label: l10n.healthDiet, color: AppColors.primary),
    _FabItem(icon: Icons.water_drop_outlined, label: l10n.healthWater, color: AppColors.info),
    _FabItem(icon: Icons.monitor_weight_outlined, label: l10n.healthWeight, color: const Color(0xFFAB47BC)),
    _FabItem(icon: Icons.pets, label: l10n.healthExcretion, color: AppColors.success),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    HapticFeedback.lightImpact();
    setState(() => _open = !_open);
    _open ? _ctrl.forward() : _ctrl.reverse();
  }

  void _onSelect(int index) {
    _toggle();
    switch (index) {
      case 0:
        widget.onDiet();
      case 1:
        widget.onWater();
      case 2:
        widget.onWeight();
      case 3:
        widget.onExcretion();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = _buildItems(l10n);
    // 使用 Column 垂直布局，每个按钮间距 12px，避免重叠
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 展开的子按钮 (从上到下: 排泄, 体重, 饮水, 饮食)
        ...items.reversed.toList().asMap().entries.map((e) {
          final reversedIndex = items.length - 1 - e.key;
          final item = e.value;
          return _AnimatedFabChild(
            controller: _ctrl,
            index: e.key,
            item: item,
            onTap: () => _onSelect(reversedIndex),
          );
        }),

        // 主按钮
        FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: AppColors.primary,
          elevation: 6,
          shape: const CircleBorder(),
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) => Transform.rotate(
              angle: _ctrl.value * pi / 4,
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ),
      ],
    );
  }
}

class _AnimatedFabChild extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final _FabItem item;
  final VoidCallback onTap;

  const _AnimatedFabChild({
    required this.controller,
    required this.index,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final interval = Interval(
      index * 0.08,
      0.5 + index * 0.1,
      curve: Curves.easeOutBack,
    );
    final animation = CurvedAnimation(parent: controller, curve: interval);

    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        final t = animation.value;
        if (t < 0.01) return const SizedBox.shrink();
        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - t)),
            child: Transform.scale(
              scale: t,
              child: child,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: item.color,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 圆形按钮
            Material(
              color: AppColors.surface,
              shape: const CircleBorder(),
              elevation: 3,
              shadowColor: item.color.withValues(alpha: 0.3),
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: item.color.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(item.icon, color: item.color, size: 22),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FabItem {
  final IconData icon;
  final String label;
  final Color color;
  const _FabItem(
      {required this.icon, required this.label, required this.color});
}
