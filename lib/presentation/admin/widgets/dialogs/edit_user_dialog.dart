import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:migaproject/Logic/user_role_change/cubit.dart';
import 'package:migaproject/Logic/user_role_change/state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditUserDialog extends StatefulWidget {
  final Map<String, dynamic> user;
  final String userId;
  final String accessToken;
  final VoidCallback onSuccess;

  const EditUserDialog({
    super.key,
    required this.user,
    required this.userId,
    required this.accessToken,
    required this.onSuccess,
  });

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.user["role"];
  }

  /// Map display role ("Admin", "Officer", "Citizen") back to API format.
  /// API expects: "admin", "officer", "citizen"
  String _mapRoleToApi(String displayRole) {
    switch (displayRole.toLowerCase()) {
      case 'admin':
        return 'admin';
      case 'officer':
        return 'officer';
      case 'citizen':
        return 'citizen';
      default:
        return displayRole.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserRoleCubit, UserRoleState>(
      listener: (context, state) {
        if (state is UserRoleSuccessState) {
          Navigator.pop(context);
          widget.onSuccess(); // Refresh user list
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Role updated to ${selectedRole}'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is UserRoleErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.error}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: BlocBuilder<UserRoleCubit, UserRoleState>(
        builder: (context, state) {
          final isLoading = state is UserRoleLoadingState;

          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Change User Role',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'User: ${widget.user["name"]}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Email: ${widget.user["email"]}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  DropdownButtonFormField<String>(
                    value: selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.badge, color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                    ),
                    items: ["Admin", "Officer", "Citizen"].map((role) {
                      return DropdownMenuItem(value: role, child: Text(role));
                    }).toList(),
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              selectedRole = value!;
                            });
                          },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        final apiRole = _mapRoleToApi(selectedRole);
                        print(
                          "apiRole: $apiRole ---- selectedRole: $selectedRole ---- widget.userId: ${widget.userId} ---- widget.accessToken: ${widget.accessToken} ",
                        );

                        // Call API to change role

                        context.read<UserRoleCubit>().changeUserRole(
                          userId: widget.userId,
                          role: apiRole,
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save Changes'),
              ),
            ],
          );
        },
      ),
    );
  }
}
