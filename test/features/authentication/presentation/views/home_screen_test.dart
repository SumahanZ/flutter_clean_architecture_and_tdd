import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/domain/entities/user.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/presentation/views/home_screen.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/presentation/widgets/add_user_dialog.dart';
import 'package:flutter_clean_architecture_and_tdd/features/authentication/presentation/widgets/loading_column.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

void main() {
  late AuthCubit mockCubit;

  setUpAll(() {
    HttpOverrides.global = null;
  });

  setUp(() {
    mockCubit = MockAuthCubit();
    //used to get actual http response
  });

  tearDown(() => mockCubit.close());

  //when testing widget always wrap in MaterialApp
  Widget makeTestableWidget(Widget body) {
    //we need to wrap in blockprovider, because we have to provide the bloc
    return BlocProvider(
      create: (context) => mockCubit,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  group("HomeScreen -", () {
    group("Getting User Functionality", () {
      testWidgets(
          "should show progress indicator when state is at [AuthGettingUsersActionState]",
          (widgetTester) async {
        when(() => mockCubit.state)
            .thenReturn(const AuthGettingUsersActionState());

        //act
        await widgetTester.pumpWidget(
          makeTestableWidget(
            const HomeScreen(),
          ),
        );

        final foundLoader = find.byType(LoadingColumn);

        expect(foundLoader, findsOneWidget);
      });

      testWidgets(
          "should show ListView with fetched [List<User>] when state is [AuthLoaded]",
          (widgetTester) async {
        final testUsers = [
          const User(
              id: "1", createdAt: "createdAt", name: "name", avatar: "avatar")
        ];
        when(() => mockCubit.state).thenReturn(AuthLoaded(testUsers));

        //act
        await widgetTester.pumpWidget(
          makeTestableWidget(
            const HomeScreen(),
          ),
        );

        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(ListTile), findsNWidgets(testUsers.length));

        for (final user in testUsers) {
          expect(find.text(user.name), findsOneWidget);
          expect(find.text(user.createdAt), findsOneWidget);
        }
      });
    });

    group("Creating User Functionality", () {
      testWidgets(
          "when clicked on floating action button [AddUserDialog] widget should show up and when enter therefore a new user should be created",
          (widgetTester) async {
        final testUsers = [
          const User(
              id: "1", createdAt: "createdAt", name: "name", avatar: "avatar")
        ];
        when(() => mockCubit.state).thenReturn(AuthLoaded(testUsers));
        //act
        await widgetTester.pumpWidget(
          makeTestableWidget(
            const HomeScreen(),
          ),
        );

        //make sure to test whether a floating action button exist
        final floatingActionButton = find.byType(FloatingActionButton);

        expect(floatingActionButton, findsOneWidget);

        await widgetTester.tap(floatingActionButton);

        await widgetTester.pump();

        //check kalau ada alertdialog muncul

        final userDialog = find.byType(AddUserDialog);

        expect(userDialog, findsOneWidget);

        final foundTextField = find.byType(TextField);

        expect(foundTextField, findsOneWidget);

        await widgetTester.enterText(foundTextField, "Kevin Sander Utomo");

        final foundElevatedButton = find.byType(ElevatedButton);

        await widgetTester.tap(foundElevatedButton);

        await widgetTester.pumpAndSettle();

        verify(() => mockCubit.createUserHandler(
            createdAt: any(named: "createdAt"),
            name: any(named: "name"),
            avatar: any(named: "avatar"))).called(1);
      });
    });
  });
}
