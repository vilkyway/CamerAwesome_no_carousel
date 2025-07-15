import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AwesomeFilterSelector extends StatefulWidget {
  final PhotoCameraState state;
  final FilterListPosition filterListPosition;
  final Widget indicator;
  final EdgeInsets? filterListPadding;
  final Color? filterListBackgroundColor;

  const AwesomeFilterSelector({
    super.key,
    required this.state,
    required this.filterListPosition,
    required this.filterListPadding,
    required this.filterListBackgroundColor,
    required this.indicator,
  });

  @override
  State<AwesomeFilterSelector> createState() => _AwesomeFilterSelectorState();
}

class _AwesomeFilterSelectorState extends State<AwesomeFilterSelector> {
  int _selected = 0;
  final List<AwesomeFilter> filters = awesomePresetFiltersList;

  @override
  Widget build(BuildContext context) {
    final children = [
      widget.indicator,
      Container(
        padding: widget.filterListPadding,
        color: widget.filterListBackgroundColor,
        child: Stack(
          children: [
            SizedBox(
              height: 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.asMap().entries.map((entry) {
                    final index = entry.key;
                    final filter = entry.value;
                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selected = index;
                        });
                        widget.state.setFilter(filter);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: _FilterPreview(
                          filter: filter.preview,
                          textureId: widget.state.textureId,
                          isSelected: _selected == index,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            IgnorePointer(
              child: Center(
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    return Column(
      children: widget.filterListPosition == FilterListPosition.belowButton
          ? children
          : children.reversed.toList(),
    );
  }
}

class _FilterPreview extends StatelessWidget {
  final ColorFilter filter;
  final int? textureId;
  final bool isSelected;

  const _FilterPreview({
    required this.filter,
    required this.textureId,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(9)),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        width: 60,
        height: 60,
        child: textureId != null
            ? ColorFiltered(
                colorFilter: filter,
                child: OverflowBox(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: 60,
                      height: 60 / (9 / 16),
                      child: Texture(textureId: textureId!),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
