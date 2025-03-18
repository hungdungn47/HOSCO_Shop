import 'package:flutter/material.dart';

class CategoryFilterBottomSheet extends StatefulWidget {
  final List<String> availableCategories;
  final List<String> selectedCategories;
  final Function(List<String>) onApplyFilters;

  const CategoryFilterBottomSheet({
    Key? key,
    required this.availableCategories,
    required this.selectedCategories,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _CategoryFilterBottomSheetState createState() => _CategoryFilterBottomSheetState();
}

class _CategoryFilterBottomSheetState extends State<CategoryFilterBottomSheet> {
  late List<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories = List.from(widget.selectedCategories);
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter by Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.availableCategories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => _toggleCategory(category),
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedCategories = [];
                  });
                },
                child: const Text('Clear All'),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.onApplyFilters(_selectedCategories);
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Extension to show the bottom sheet from anywhere in the app
extension CategoryFilterExtension on BuildContext {
  Future<void> showCategoryFilterBottomSheet({
    required List<String> availableCategories,
    required List<String> selectedCategories,
    required Function(List<String>) onApplyFilters,
  }) {
    return showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CategoryFilterBottomSheet(
          availableCategories: availableCategories,
          selectedCategories: selectedCategories,
          onApplyFilters: onApplyFilters,
        ),
      ),
    );
  }
}