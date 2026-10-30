import 'package:flutter/material.dart';

import '../core/theme.dart';
import '../core/navigation.dart';

class Brand extends StatelessWidget {
  const Brand({super.key, this.vertical = false});
  final bool vertical;
  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/images/logo-metalhub.png',
      width: vertical ? 58 : 36,
      height: vertical ? 58 : 36,
      filterQuality: FilterQuality.high,
    );
    final words = Column(
      crossAxisAlignment: vertical
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'MetalHub',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: green,
            fontSize: vertical ? 24 : 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          'Sistema de Gestão de Sucatas',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: muted, fontSize: 11),
        ),
      ],
    );
    return vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [logo, const SizedBox(height: 12), words],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [logo, const SizedBox(width: 10), Flexible(child: words)],
          );
  }
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.title, this.subtitle, {super.key, this.action});
  final String title;
  final String subtitle;
  final Widget? action;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final text = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: box.maxWidth < 550 ? 21 : 24,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      );
      return Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: box.maxWidth < 550
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  text,
                  if (action != null) ...[const SizedBox(height: 16), action!],
                ],
              )
            : Row(
                children: [
                  Expanded(child: text),
                  if (action != null) ...[const SizedBox(width: 20), action!],
                ],
              ),
      );
    },
  );
}

class Panel extends StatelessWidget {
  const Panel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: outline),
      borderRadius: BorderRadius.circular(10),
    ),
    child: child,
  );
}

class AdaptiveGrid extends StatelessWidget {
  const AdaptiveGrid({
    super.key,
    required this.children,
    this.columns = 3,
    this.minWidth = 260,
    this.gap = 20,
  });
  final List<Widget> children;
  final int columns;
  final double minWidth;
  final double gap;
  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final count = ((constraints.maxWidth + gap) / (minWidth + gap))
          .floor()
          .clamp(1, columns);
      final width = (constraints.maxWidth - gap * (count - 1)) / count;
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: children
            .map((child) => SizedBox(width: width, child: child))
            .toList(),
      );
    },
  );
}

class Detail extends StatelessWidget {
  const Detail(this.icon, this.text, {super.key, this.color = green});
  final IconData icon;
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    ),
  );
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.text, {super.key, this.color = green});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: color.withValues(alpha: .09),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      text,
      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600),
    ),
  );
}

class ActionButton extends StatelessWidget {
  const ActionButton(
    this.label, {
    super.key,
    this.icon,
    this.color = green,
    this.soft = false,
    this.onPressed,
  });
  final String label;
  final IconData? icon;
  final Color color;
  final bool soft;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) => FilledButton(
    style: FilledButton.styleFrom(
      backgroundColor: soft ? color.withValues(alpha: .09) : color,
      foregroundColor: soft ? color : Colors.white,
    ),
    onPressed: onPressed ?? () => showFeatureUnavailable(context),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16),
          if (label.isNotEmpty) const SizedBox(width: 6),
        ],
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    ),
  );
}

class BannerImage extends StatelessWidget {
  const BannerImage(this.name, {super.key});
  final String name;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 24),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset(
        'assets/images/$name.jpg',
        width: double.infinity,
        height: MediaQuery.sizeOf(context).width < 600 ? 110 : 150,
        fit: BoxFit.cover,
        semanticLabel: 'Equipe de profissionais',
      ),
    ),
  );
}

class SearchableCards extends StatefulWidget {
  const SearchableCards({
    super.key,
    required this.hint,
    required this.items,
    required this.builder,
    this.columns = 3,
    this.minWidth = 260,
  });
  final String hint;
  final List<String> items;
  final Widget Function(int) builder;
  final int columns;
  final double minWidth;
  @override
  State<SearchableCards> createState() => _SearchableCardsState();
}

class _SearchableCardsState extends State<SearchableCards> {
  String query = '';
  String normalize(String value) {
    var result = value.toLowerCase();
    const replacements = {
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'é': 'e',
      'ê': 'e',
      'í': 'i',
      'ó': 'o',
      'ô': 'o',
      'õ': 'o',
      'ú': 'u',
      'ç': 'c',
    };
    replacements.forEach((key, value) {
      result = result.replaceAll(key, value);
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final indexes = [
      for (var i = 0; i < widget.items.length; i++)
        if (normalize(widget.items[i]).contains(normalize(query.trim()))) i,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) => setState(() => query = value),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  prefixIcon: const Icon(Icons.search, size: 19),
                  labelText: 'Buscar',
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.outlined(
              onPressed: () => showFeatureUnavailable(context),
              icon: const Icon(Icons.filter_alt_outlined, size: 20),
              tooltip: 'Filtros',
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (indexes.isEmpty)
          const Panel(child: Text('Nenhum resultado encontrado.'))
        else
          AdaptiveGrid(
            columns: widget.columns,
            minWidth: widget.minWidth,
            children: indexes.map(widget.builder).toList(),
          ),
      ],
    );
  }
}
