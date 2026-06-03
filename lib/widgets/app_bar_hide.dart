import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HideableAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final List<Widget> actions;
  final String title;

  const HideableAppBar({
    super.key,
    required this.scrollController,
    required this.actions,
    required this.title,
  });

  @override
  State<HideableAppBar> createState() => _HideableAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HideableAppBarState extends State<HideableAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    widget.scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _animationController.forward();
    } else if (widget.scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    widget.scrollController.removeListener(_handleScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -kToolbarHeight * (1 - _animation.value)),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: AppBar(
        title: Text(widget.title),
        actions: widget.actions,
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 2,
      ),
    );
  }
}