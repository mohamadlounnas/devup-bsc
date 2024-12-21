import 'package:admin_app/app_container.dart';
import 'package:admin_app/presentation/dashboard/dashboard_screen.dart';
import 'package:admin_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController =
      TextEditingController(text: "aminemenadi11@gmail.com");
  final TextEditingController _passwordController =
      TextEditingController(text: "amine2005");
  bool _saveCredentials = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final authService = context.read<AuthService>();
    final savedCredentials = await authService.getSavedCredentials();
    if (savedCredentials != null) {
      setState(() {
        _usernameController.text = savedCredentials['username']!;
        _passwordController.text = savedCredentials['password']!;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<AuthService>();

    try {
      await authService.loginWithCredentials(
        _usernameController.text,
        _passwordController.text,
      );

      if (_saveCredentials) {
        await authService.saveCredentials(
          _usernameController.text,
          _passwordController.text,
        );
      }
      await PermissionService.instance.checkPermission('');

      if (mounted) {
        context.go('/dashboard');
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
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: AppContainer.sm(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    Card(
                      margin: const EdgeInsets.all(24),
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.5),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                        side: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24, bottom: 12),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Image.asset(
                                'assets/full.png',
                                width: 200,
                                height: 200,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: MenuAnchor(
                                  builder: (context, controller, _) {
                                    return TextFormField(
                                      controller: _usernameController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                        prefixIcon: const Icon(
                                            Icons.person_outline_outlined),
                                        labelText: 'Username',
                                        hintText: '202YXXXXXXX',
                                        alignLabelWithHint: true,
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    );
                                  },

                                  // items is credentials
                                  menuChildren: [],
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: TextFormField(
                                  controller: _passwordController,
                                  decoration: const InputDecoration(
                                    alignLabelWithHint: true,
                                    isDense: true,
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    prefixIcon:
                                        Icon(Icons.lock_outline_rounded),
                                    labelText: 'Password',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              // checkbox for save credentials
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: ListTile(
                                  trailing: Switch(
                                    activeColor:
                                        Theme.of(context).colorScheme.primary,
                                    value: _saveCredentials,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _saveCredentials = value;
                                      });
                                    },
                                  ),
                                  title: const Text('Save credentials'),
                                  subtitle: const Text(
                                      'Save your credentials for the next time'),
                                  leading: const Icon(Icons.key_rounded),
                                  onTap: () {
                                    setState(() {
                                      _saveCredentials = !_saveCredentials;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Consumer<AuthService>(
                                  builder: (context, authService, child) {
                                    if (authService.loading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    return Material(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      elevation: 3,
                                      child: ListTile(
                                        leading: const Icon(
                                          Icons.fingerprint_rounded,
                                          color: Colors.white,
                                        ),
                                        title: const Center(
                                          child: Text(
                                            'Sign in',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        onTap: _handleLogin,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              if (context.watch<AuthService>().error != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    context.watch<AuthService>().error!,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
