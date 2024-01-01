import 'package:fic11_starter_pos/core/assets/assets.gen.dart';
import 'package:fic11_starter_pos/data/datasources/auth_local_datasource.dart';
import 'package:fic11_starter_pos/presentation/auth/bloc/login/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/components/buttons.dart';
import '../../../core/components/custom_text_field.dart';
import '../../../core/components/spaces.dart';
import '../../home/pages/dashboard_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SpaceHeight(80.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 130.0),
              child: Image.asset(
                Assets.images.logo.path,
                width: 100,
                height: 100,
              )),
          const SpaceHeight(24.0),
          const Center(
            child: Text(
              "POS Batch 11",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SpaceHeight(8.0),
          const Center(
            child: Text(
              "Masuk untuk kasir",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          const SpaceHeight(40.0),
          CustomTextField(
            controller: usernameController,
            label: 'Username',
          ),
          const SpaceHeight(12.0),
          CustomTextField(
            controller: passwordController,
            label: 'Password',
            obscureText: true,
          ),
          const SpaceHeight(24.0),
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              state.maybeMap(
                orElse: () {},
                success: (authResponseModel) {
                  AuthLocalDatasource().saveAuthData(authResponseModel.authResponseModel);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage(),
                    ),
                  );
                },
                error: (message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
            builder: (context, state) {
              return state.maybeMap(orElse: () {
                return Button.filled(
                  onPressed: () {
                    context.read<LoginBloc>().add(
                          LoginEvent.login(
                            username: usernameController.text,
                            password: passwordController.text,
                          ),
                        );
                  },
                  label: 'Masuk',
                );
              }, loading: (authResponseModel) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
