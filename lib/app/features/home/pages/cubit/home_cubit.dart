import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final userID = FirebaseAuth.instance.currentUser?.uid;

  HomeCubit()
      : super(const HomeState(
          documents: [],
          errorMessage: '',
          isLoading: false,
        ));

  StreamSubscription? _streamSubscription;

  Future<void> start() async {
    emit(
      const HomeState(
        documents: [],
        errorMessage: '',
        isLoading: true,
      ),
    );
    _streamSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('categories')
        .snapshots()
        .listen((data) {
      emit(
        HomeState(
          documents: data.docs,
          isLoading: false,
          errorMessage: '',
        ),
      );
    })
      ..onError((error) {
        emit(
          HomeState(
            documents: const [],
            isLoading: false,
            errorMessage: error.toString(),
          ),
        );
      });
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
