import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/presentation/widgets/add_user_dialog.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/presentation/widgets/loading_column.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() {
    context.read<AuthCubit>().getUsersHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return const AddUserDialog();
                });
          },
          label: const Text("Add User"),
        ),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                  ),
                ),
              );
            } else if (state is AuthUserCreatedActionState) {
              //when user is created succeed we want to fetch again
              Navigator.of(context).pop();
              getUsers();
            }
          },
          builder: (context, state) {
            if (state is AuthGettingUsersActionState) {
              return const LoadingColumn(message: "Fetching Users");
            } else if (state is AuthLoaded) {
              return Center(
                child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    return ListTile(
                      leading: Image.network(
                        user.avatar,
                        errorBuilder: (context, exception, stackTrace) {
                          return const Text('Error');
                        },
                      ),
                      title: Text(user.name),
                      subtitle: Text(
                        user.createdAt,
                      ),
                    );
                  },
                ),
              );
            } else if (state is AuthCreateUserActionState) {
              return const LoadingColumn(message: "Creating User");
            } else {
              return const SizedBox.shrink();
            }
          },
        ));
  }
}
