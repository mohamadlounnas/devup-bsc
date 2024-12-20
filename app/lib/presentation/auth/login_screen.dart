import 'package:app/widgets/background_gradient.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';
import '../../utils/responsive.dart';
import 'register_screen.dart';

/// A screen that handles user login with email and password
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _saveCredentials = true;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final authService = context.read<AuthService>();
    final savedAuth = await authService.getSavedAuthState();
    if (savedAuth != null) {
      setState(() {
        _emailController.text = savedAuth['email']!;
        _passwordController.text = savedAuth['password']!;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<AuthService>();

    try {
      await authService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        context.go('/events');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return BackgroundGradient(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: Responsive.getAuthPadding(context),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.getAuthMaxWidth(context),
              ),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(
                    color: Colors.grey.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Hero(
                          tag: 'app_logo',
                          child: Image.asset(
                            'assets/logo/full.png',
                            height: isDesktop ? 120 : 80,
                            semanticLabel: 'DevUp logo',
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Welcome Back',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: isDesktop ? 32 : 24,
                          ),
                        ),
                        SizedBox(height: isDesktop ? 48 : 24),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'your.email@example.com',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: const OutlineInputBorder(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text('Remember Me'),
                          subtitle: const Text('Save credentials for next time'),
                          value: _saveCredentials,
                          onChanged: (bool value) {
                            setState(() {
                              _saveCredentials = value;
                            });
                          },
                        ),
                        SizedBox(height: isDesktop ? 48 : 24),
                        Consumer<AuthService>(
                          builder: (context, authService, child) {
                            return ElevatedButton(
                              onPressed: authService.loading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(isDesktop ? 300 : double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: authService.loading
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      'Login',
                                      style: TextStyle(fontSize: isDesktop ? 18 : 16),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            context.push('/register');
                          },
                          child: const Text('Don\'t have an account? Register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
} 