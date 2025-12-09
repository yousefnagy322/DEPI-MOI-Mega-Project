import 'package:flutter/material.dart';

class UserFiltersBar extends StatelessWidget {
  final String search;
  final String? selectedRole;
  final Function(String) onSearchChanged;
  final Function(String?) onRoleChanged;
  final VoidCallback? onNewUserPressed;

  const UserFiltersBar({
    super.key,
    required this.search,
    required this.selectedRole,
    required this.onSearchChanged,
    required this.onRoleChanged,
    this.onNewUserPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 768;

        if (isSmallScreen) {
          return Column(
            children: [
              // Search bar
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: "Search by name or email...",
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Role dropdown
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          dropdownColor: Colors.white,
                          value: selectedRole,
                          hint: const Text("Role"),
                          icon: const Icon(Icons.arrow_drop_down, size: 20),
                          isExpanded: true,
                          items: [
                            const DropdownMenuItem<String?>(
                              value: null,
                              child: Text("All Roles"),
                            ),
                            ...["Admin", "Officer", "Citizen"].map(
                              (role) => DropdownMenuItem<String?>(
                                value: role,
                                child: Text(role),
                              ),
                            ),
                          ],
                          onChanged: onRoleChanged,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Download icon
                  // Container(
                  //   height: 40,
                  //   width: 40,
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(8),
                  //     border: Border.all(color: Colors.grey[300]!),
                  //   ),
                  //   child: IconButton(
                  //     icon: const Icon(Icons.download, size: 20),
                  //     onPressed: () {},
                  //     padding: EdgeInsets.zero,
                  //   ),
                  // ),
                  const SizedBox(width: 12),
                  // add new user button for small screens
                  GestureDetector(
                    onTap: onNewUserPressed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.center,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xff5b98f2),
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'new user',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            // Search bar
            Expanded(
              flex: 3,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: "Search by name or email...",
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Role dropdown
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String?>(
                  dropdownColor: Colors.white,
                  value: selectedRole,
                  hint: const Text("Role"),
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                  isExpanded: false,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text("All Roles"),
                    ),
                    ...["Admin", "Officer", "Citizen"].map(
                      (role) => DropdownMenuItem<String?>(
                        value: role,
                        child: Text(role),
                      ),
                    ),
                  ],
                  onChanged: onRoleChanged,
                ),
              ),
            ),

            const SizedBox(width: 12),

            // add new user
            GestureDetector(
              onTap: onNewUserPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xff5b98f2),
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'new user',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
