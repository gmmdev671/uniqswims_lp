import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HideableAppBar extends StatefulWidget implements PreferredSizeWidget {
  final ScrollController scrollController;
  final String title;
  final List<Widget>? actions;
  final double height;
  final Duration duration;

  const HideableAppBar({
    Key? key,
    required this.scrollController,
    required this.title,
    this.actions,
    this.height = kToolbarHeight,
    this.duration = const Duration(milliseconds: 200),
  }) : super(key: key);

  @override
  State<HideableAppBar> createState() => _HideableAppBarState();

  // preferredSize expõe a altura "atual" estimada — o getter usa a controller.value
  // (o Scaffold atualiza quando o widget rebuilda).
  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _HideableAppBarState extends State<HideableAppBar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _lastOffset = 0.0;

  @override
  void initState() {
    super.initState();
    // value = 1.0 -> fully visible; 0.0 -> hidden
    _controller = AnimationController(vsync: this, duration: widget.duration, value: 1.0);
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant HideableAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scrollController != widget.scrollController) {
      oldWidget.scrollController.removeListener(_onScroll);
      widget.scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    // usa a direção do scroll para esconder/mostrar
    final sc = widget.scrollController;
    if (!sc.hasClients) return;

    final offset = sc.position.pixels;
    final direction = sc.position.userScrollDirection;

    // se scroll para baixo (conteúdo sobe), esconder
    if (direction == ScrollDirection.reverse) {
      _controller.animateTo(0.0, curve: Curves.easeInOut);
    } else if (direction == ScrollDirection.forward) {
      // se scroll para cima (conteúdo desce), mostrar
      _controller.animateTo(1.0, curve: Curves.easeInOut);
    }

    _lastOffset = offset;
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.colorScheme.surface;
    final fullHeight = widget.height;

    // AnimatedBuilder atualiza conforme _controller anima.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // altura atualizada (0..fullHeight)
        final currentHeight = fullHeight * _controller.value;

        // Quando height é 0, retornamos SizedBox.shrink() dentro do material para evitar
        // deixar espaço / "retângulo preto".
        return SizedBox(
          height: currentHeight,
          child: Material(
            color: background,
            elevation: 4.0 * _controller.value, // reduz elevação quando escondido
            child: ClipRect(
              // ClipRect evita que conteúdo interno "vaze" ao animar a altura
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: (_controller.value == 0.0) ? 0.0 : 1.0,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: fullHeight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 16),
                        // TÍTULO
                        Text(
                          widget.title,
                          style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w700) ??
                              TextStyle(color: theme.colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        // ACTIONS
                        if (widget.actions != null) ...widget.actions!,
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}