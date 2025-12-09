import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/user_data_list/cubit.dart';
import 'package:migaproject/Logic/user_data_list/state.dart';
import 'package:migaproject/Logic/user_role_change/cubit.dart';
import 'package:migaproject/Logic/signup/cubit.dart';
import 'package:migaproject/presentation/admin/widgets/badges/role_badge.dart';
import 'package:migaproject/presentation/admin/widgets/users/user_filters_bar.dart';
import 'package:migaproject/presentation/admin/widgets/users/user_action_menu.dart';
import 'package:migaproject/presentation/admin/widgets/dialogs/edit_user_dialog.dart';
import 'package:migaproject/presentation/admin/widgets/dialogs/delete_user_dialog.dart';
import 'package:migaproject/presentation/admin/widgets/dialogs/create_user_dialog.dart';
import 'package:migaproject/presentation/admin/widgets/users/pagination_widget.dart';
import 'package:migaproject/presentation/admin/utils/date_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_profile_page.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  // Backing list for the table; filled from UserDataCubit
  List<Map<String, dynamic>> users = [];

  String search = "";
  String? selectedRole;
  bool selectAll = false;
  Map<int, bool> selectedUsers = {};
  int currentPage = 1;
  final int itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataCubit, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserDataErrorState) {
          return Center(child: Text(state.error));
        }

        if (state is UserDataSuccessState) {
          // Map API UserModel objects into the structure expected by the table/UI
          users = state.users
              .map(
                (u) => {
                  "name": u.userId, // using userId as display name
                  "email": u.email,
                  // Normalize backend role strings to match UI roles (Admin/Officer/Citizen)
                  "role": _mapRoleFromApi(u.role),
                  "dateAdded": u.createdAt.toIso8601String(),
                },
              )
              .toList();
        }

        final filteredUsers = _getFilteredUsers();
        final paginationData = _calculatePagination(filteredUsers);
        final paginatedUsers =
            paginationData['paginatedUsers'] as List<Map<String, dynamic>>;
        final totalItems = paginationData['totalItems'] as int;
        final totalPages = paginationData['totalPages'] as int;
        final startIndex = paginationData['startIndex'] as int;
        final endIndex = paginationData['endIndex'] as int;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters row
            UserFiltersBar(
              search: search,
              selectedRole: selectedRole,
              onSearchChanged: (value) => setState(() {
                search = value;
                currentPage = 1;
              }),
              onRoleChanged: (value) => setState(() {
                selectedRole = value;
                currentPage = 1;
              }),
              onNewUserPressed: () => _showCreateUserDialog(context),
            ),

            const SizedBox(height: 20),

            // Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Table
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: constraints.maxWidth > 0
                                    ? constraints.maxWidth
                                    : 800,
                              ),
                              child: DataTable(
                                headingRowHeight: 48,
                                dataRowMinHeight: 64,
                                dataRowMaxHeight: 72,
                                headingRowColor: MaterialStateProperty.all(
                                  Colors.grey[50],
                                ),
                                columnSpacing: 24,
                                columns: _buildTableColumns(),
                                rows: _buildTableRows(paginatedUsers),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Pagination
                    PaginationWidget(
                      currentPage: currentPage,
                      totalPages: totalPages,
                      totalItems: totalItems,
                      startIndex: startIndex,
                      endIndex: endIndex,
                      onPageChanged: (page) => setState(() {
                        currentPage = page;
                        selectAll = false;
                      }),
                      itemLabelPlural: 'users',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Map backend role values (e.g. "admin", "officer") into the
  /// display roles used by filters and RoleBadge ("Admin", "Officer", "Citizen").
  String _mapRoleFromApi(String apiRole) {
    final lower = apiRole.toLowerCase();
    if (lower == 'admin') return 'Admin';
    if (lower == 'officer') return 'Officer';
    if (lower == 'citizen') return 'Citizen';
    return apiRole;
  }

  List<Map<String, dynamic>> _getFilteredUsers() {
    return users.where((u) {
      final matchesSearch =
          search.isEmpty ||
          u["name"].toLowerCase().contains(search.toLowerCase()) ||
          u["email"].toLowerCase().contains(search.toLowerCase());
      final matchesRole = selectedRole == null || u["role"] == selectedRole;
      return matchesSearch && matchesRole;
    }).toList();
  }

  Map<String, dynamic> _calculatePagination(
    List<Map<String, dynamic>> filteredUsers,
  ) {
    final totalItems = filteredUsers.length;
    final totalPages = totalItems > 0 ? (totalItems / itemsPerPage).ceil() : 1;

    // Reset to page 1 if current page is out of bounds
    if (currentPage > totalPages && totalPages > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() => currentPage = 1);
        }
      });
    }

    final startIndex = totalItems > 0 ? (currentPage - 1) * itemsPerPage : 0;
    final endIndex = (startIndex + itemsPerPage).clamp(0, totalItems);
    final paginatedUsers = totalItems > 0
        ? filteredUsers.sublist(startIndex.clamp(0, totalItems), endIndex)
        : <Map<String, dynamic>>[];

    // Update selectAll state
    if (paginatedUsers.isNotEmpty) {
      final allSelected = paginatedUsers.every(
        (user) => selectedUsers[users.indexOf(user)] == true,
      );
      if (selectAll != allSelected) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() => selectAll = allSelected);
          }
        });
      }
    }

    return {
      'paginatedUsers': paginatedUsers,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'startIndex': startIndex,
      'endIndex': endIndex,
    };
  }

  List<DataColumn> _buildTableColumns() {
    return [
      // DataColumn(
      //   label: Padding(
      //     padding: const EdgeInsets.only(left: 16),
      //     child: Builder(
      //       builder: (context) {
      //         final paginationData = _calculatePagination(_getFilteredUsers());
      //         final paginatedUsers =
      //             paginationData['paginatedUsers']
      //                 as List<Map<String, dynamic>>;
      //         final allSelected =
      //             paginatedUsers.isNotEmpty &&
      //             paginatedUsers.every(
      //               (user) => selectedUsers[users.indexOf(user)] == true,
      //             );
      //         return Checkbox(
      //           value: allSelected && paginatedUsers.isNotEmpty,
      //           onChanged: paginatedUsers.isEmpty
      //               ? null
      //               : (value) {
      //                   setState(() {
      //                     selectAll = value ?? false;
      //                     for (var user in paginatedUsers) {
      //                       final index = users.indexOf(user);
      //                       selectedUsers[index] = selectAll;
      //                     }
      //                   });
      //                 },
      //         );
      //       },
      //     ),
      //   ),
      // ),
      const DataColumn(
        label: Text(
          "NAME",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "EMAIL",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "ROLE",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: Colors.blue,
            letterSpacing: 0.5,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "DATE ADDED",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),
      ),
      DataColumn(
        label: Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text(
            "ACTIONS",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.grey[700],
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    ];
  }

  List<DataRow> _buildTableRows(List<Map<String, dynamic>> paginatedUsers) {
    return paginatedUsers.map((u) {
      final dateAdded =
          DateTime.tryParse(u["dateAdded"] as String) ?? DateTime.now();
      return DataRow(
        cells: [
          // DataCell(
          //   Padding(
          //     padding: const EdgeInsets.only(left: 16),
          //     child: Checkbox(
          //       value: selectedUsers[userIndex] ?? false,
          //       onChanged: (value) {
          //         setState(() {
          //           selectedUsers[userIndex] = value ?? false;
          //           selectAll = paginatedUsers.every(
          //             (user) => selectedUsers[users.indexOf(user)] == true,
          //           );
          //         });
          //       },
          //     ),
          //   ),
          // ),
          DataCell(
            SelectableText(
              u["name"],
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
          DataCell(
            SelectableText(
              u["email"],
              style: TextStyle(color: Colors.grey[700], fontSize: 13),
            ),
          ),
          DataCell(RoleBadge(role: u["role"])),
          DataCell(
            Text(
              DateFormatter.formatDate(dateAdded),
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
          ),
          DataCell(
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: UserActionMenu(
                onActionSelected: (action) => _handleAction(context, action, u),
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  void _handleAction(
    BuildContext context,
    String action,
    Map<String, dynamic> user,
  ) {
    switch (action) {
      case 'view':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => UserProfilePage(userData: user)),
        );
        break;

      case 'edit':
        _showEditDialog(context, user);
        break;

      case 'delete':
        _showDeleteConfirmation(context, user);
        break;
    }
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> user) async {
    // Get access token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');

    if (accessToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot change role: not authenticated.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // userId is stored in "name" field (from the mapping we did earlier)
    final userId = user["name"] as String;

    // Provide UserRoleCubit for the dialog
    final roleCubit = UserRoleCubit();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: roleCubit,
          child: EditUserDialog(
            user: user,
            userId: userId,
            accessToken: accessToken,
            onSuccess: () async {
              // Refresh user list after successful role change

              context.read<UserDataCubit>().fetchUserData();
            },
          ),
        );
      },
    ).then((_) {
      roleCubit.close();
    });
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Map<String, dynamic> user,
  ) {
    showDialog(
      context: context,
      builder: (context) => DeleteUserDialog(
        userName: user["name"],
        onConfirm: () {
          setState(() {
            users.remove(user);
            final index = users.indexOf(user);
            if (index != -1) {
              selectedUsers.remove(index);
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${user["name"]} has been deleted'),
              backgroundColor: Colors.red,
            ),
          );
        },
      ),
    );
  }

  void _showCreateUserDialog(BuildContext context) {
    final signUpCubit = SignUpCubit();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: signUpCubit,
          child: CreateUserDialog(
            onSuccess: () async {
              // Refresh user list after successful user creation
              context.read<UserDataCubit>().fetchUserData();
            },
          ),
        );
      },
    ).then((_) {
      signUpCubit.close();
    });
  }
}
