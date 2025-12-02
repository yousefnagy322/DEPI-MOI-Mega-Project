import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int startIndex;
  final int endIndex;
  final Function(int) onPageChanged;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.startIndex,
    required this.endIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            totalItems > 0
                ? "Showing ${startIndex + 1}-${endIndex} of $totalItems"
                : "No users found",
            style: const TextStyle(color: Colors.grey),
          ),
          if (totalPages > 1)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: currentPage > 1
                      ? () => onPageChanged(currentPage - 1)
                      : null,
                ),
                ..._buildPaginationButtons(),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: currentPage < totalPages
                      ? () => onPageChanged(currentPage + 1)
                      : null,
                ),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _buildPaginationButtons() {
    List<Widget> buttons = [];

    if (totalPages <= 7) {
      for (int i = 1; i <= totalPages; i++) {
        buttons.add(_buildPageButton(i));
      }
    } else {
      buttons.add(_buildPageButton(1));

      if (currentPage > 3) {
        buttons.add(const Text("..."));
      }

      int start = (currentPage - 1).clamp(2, totalPages - 1);
      int end = (currentPage + 1).clamp(2, totalPages - 1);

      for (int i = start; i <= end; i++) {
        buttons.add(_buildPageButton(i));
      }

      if (currentPage < totalPages - 2) {
        buttons.add(const Text("..."));
      }

      buttons.add(_buildPageButton(totalPages));
    }

    return buttons;
  }

  Widget _buildPageButton(int page) {
    final isActive = currentPage == page;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: () => onPageChanged(page),
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Colors.blue : Colors.transparent,
          foregroundColor: isActive ? Colors.white : Colors.black,
          minimumSize: const Size(36, 36),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: Text("$page"),
      ),
    );
  }
}

