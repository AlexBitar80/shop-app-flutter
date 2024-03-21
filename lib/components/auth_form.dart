import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/shop_text_field.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({
    super.key,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.login;
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLogin() => _authMode == AuthMode.login;

  bool _isSignup() => _authMode == AuthMode.signup;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    if (_isLogin()) {
      // TODO: Implementar login
    } else {
      await auth.signup(
        _authData['email']!,
        _authData['password']!,
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        width: width * 0.80,
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
        ),
        height: _isLogin() ? height * 0.48 : height * 0.56,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShopTextField(
                label: 'E-mail',
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (emailValidator) {
                  final email = emailValidator ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
              ),
              ShopTextField(
                label: 'Senha',
                isPassword: true,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (passwordValidator) {
                  final password = passwordValidator ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if (_isSignup())
                ShopTextField(
                  label: 'Confirmar Senha',
                  isPassword: true,
                  controller: _passwordController,
                  validator: _isLogin()
                      ? null
                      : (passwordValidator) {
                          final password = passwordValidator ?? '';
                          if (password != _passwordController.text) {
                            return 'Senhas não coincidem';
                          }
                          return null;
                        },
                ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton.filled(
                  child: _isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : _isLogin()
                          ? const Text('Entrar')
                          : const Text('Cadastrar'),
                  onPressed: () {
                    _submit();
                  },
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Divider(),
              TextButton(
                onPressed: _switchAuthMode,
                child: _isLogin()
                    ? const Text('Criar uma nova conta')
                    : const Text('Já possui uma conta?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
