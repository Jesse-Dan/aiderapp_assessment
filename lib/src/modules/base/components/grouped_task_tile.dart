import 'package:do_it_now/src/modules/base/components/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../resources/models/task.dart';

class ExpandableSection extends ConsumerStatefulWidget {
  final String title;
  final List<Task> items;
  final bool initiallyExpanded;

  const ExpandableSection({
    super.key,
    required this.title,
    required this.items,
    this.initiallyExpanded = false,
  });

  @override
  ConsumerState<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends ConsumerState<ExpandableSection> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();
    isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: ExpansionTile(
        collapsedBackgroundColor: Colors.black.withOpacity(.1),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.black.withOpacity(.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        title:
            Text(widget.title, style: Theme.of(context).textTheme.labelLarge),
        children: widget.items.isNotEmpty
            ? widget.items
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TaskTile(task: item),
                    ))
                .toList()
            : [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'No tasks available.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
      ),
    );
  }
}
