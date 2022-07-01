import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/app/home/pages/cubit/home_cubit.dart';
import 'package:to_do_list/app/features/auth/pages/user_profile.dart';
import 'package:to_do_list/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userID = FirebaseAuth.instance.currentUser?.uid;
    if (userID == null) {
      throw Exception('Uzytkownik jest niezalogowany');
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('To do list'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const UserProfile(),
                ),
              );
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('users')
              .doc(userID)
              .collection('categories')
              .add(
            {
              'title': controller.text,
            },
          );
          controller.clear();
        },
        child: const Icon(Icons.add),
      ),
      body: BlocProvider(
        create: (context) => HomeCubit()..start(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              return Center(
                child: Text(
                  'Wystąpił nieoczekiwany problem: ${state.errorMessage}',
                ),
              );
            }

            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final documents = state.documents;

            return ListView(
              children: [
                for (final document in documents) ...[
                  Dismissible(
                    key: ValueKey(document.id),
                    background: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.red,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 25.0),
                          child: Icon(
                            Icons.delete,
                          ),
                        ),
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      // only from right to left
                      return direction == DismissDirection.endToStart;
                    },
                    onDismissed: (direction) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(userID)
                          .collection('categories')
                          .doc(document.id)
                          .delete();
                    },
                    child: CategoryWidget(
                      document['title'],
                    ),
                  ),
                ],
                TextField(
                  controller: controller,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
