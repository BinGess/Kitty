import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';

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

  static const _items = <_FabItem>[
    _FabItem(icon: Icons.restaurant, label: '饮食', color: AppColors.primary),
    _FabItem(
        icon: Icons.water_drop_outlined, label: '饮水', color: AppColors.info),
    _FabItem(
        icon: Icons.monitor_weight_outlined,
        label: '体重',
        color: Color(0xFFAB47BC)),
    _FabItem(
        icon: Icons.pets, label: '排泄', color: AppColors.success),
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
    return SizedBox(
      width: 200,
      height: 300,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (_open)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _toggle,
                child: const SizedBox.expand(),
              ),
            ),
          ..._items.asMap().entries.map((e) {
            final i = e.key;
            final item = e.value;
            final angle = (pi / 2) * (i / (_items.length - 1));
            final distance = 70.0;
            final dx = -cos(angle) * distance * (i < 2 ? 1.0 : 0.6);
            final dy = -sin(angle) * distance * (i < 2 ? 0.6 : 1.0);
            final offsetX = dx - (i == 0 ? 20 : (i == 3 ? -20 : 0));
            final offsetY = dy - 20;
            return _AnimatedFabChild(
              controller: _ctrl,
              index: i,
              offset: Offset(offsetX, offsetY),
              item: item,
              onTap: () => _onSelect(i),
            );
          }),
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
      ),
    );
  }
}

class _AnimatedFabChild extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final Offset offset;
  final _FabItem item;
  final VoidCallback onTap;

  const _AnimatedFabChild({
    required this.controller,
    required this.index,
    required this.offset,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final interval = Interval(
      index * 0.1,
      0.6 + index * 0.1,
      curve: Curves.easeOutBack,
    );
    final animation = CurvedAnimation(parent: controller, curve: interval);

    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        final t = animation.value;
        return Positioned(
          right: 8 + (-offset.dx * t),
          bottom: 8 + (-offset.dy * t),
          child: Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: t,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: item.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Material(
                    color: item.color.withValues(alpha: 0.12),
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: onTap,
                      customBorder: const CircleBorder(),
                      child: Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        child: Icon(item.icon, color: item.color, size: 22),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
