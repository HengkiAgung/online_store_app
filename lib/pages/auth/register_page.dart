import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/common/ui_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _submit() {
    context.read<AuthBloc>().add(
      RegisterRequested(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.registerState != curr.registerState,
      listener: (context, state) {
        switch (state.registerState) {
          case Success(:final data):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("✅ $data"), backgroundColor: Colors.green),
            );
            context.push('/login');
            break;

          case Error(:final message):
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
            break;
        }
      },
      builder: (context, state) {
        final register = state.registerState;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Register",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: register is Loading ? null : _submit,
              child:
                  register is Loading
                      ? const CircularProgressIndicator(strokeWidth: 2)
                      : const Text("Register"),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.push('/login'),
              child: const Text("Already have an account? Login"),
            ),
          ],
        );
      },
    );
  }
}
