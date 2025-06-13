import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/core/di/injection.dart';
import 'package:tava/features/auth/presentation/bloc/auth_bloc.dart';

/// A page for user registration, allowing users to create a new account.
class SignupPage extends StatelessWidget {
  /// Creates a new instance of [SignupPage] widget.
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthBloc>(),
      child: const SignupView(),
    );
  }
}

/// A stateful widget view that handles user registration.
class SignupView extends StatefulWidget {
  /// Creates a new instance of [SignupView] widget.
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/dashboard');
        } else if (state is AuthError) {
          _showErrorDialog(context, state.message);
        }
      },
      builder: (context, state) {
        return PlatformScaffold(
          appBar: PlatformAppBar(
            title: const Text('Sign Up'),
            leading: PlatformIconButton(
              icon: PlatformWidget(
                material: (_, __) => const Icon(Icons.arrow_back),
                cupertino: (_, __) => const Icon(CupertinoIcons.back),
              ),
              onPressed: () => context.go('/login'),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),

                    // Title
                    PlatformText(
                      'Create Account',
                      style: platformThemeData(
                        context,
                        material: (data) =>
                            data.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        cupertino: (data) =>
                            data.textTheme.navLargeTitleTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    PlatformText(
                      'Join the community of musicians',
                      style: platformThemeData(
                        context,
                        material: (data) => data.textTheme.bodyLarge?.copyWith(
                          color:
                              data.colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        cupertino: (data) => data.textTheme.textStyle.copyWith(
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Name field
                    PlatformTextFormField(
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      hintText: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      material: (_, __) => MaterialTextFormFieldData(
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: const Icon(Icons.person_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      cupertino: (_, __) => CupertinoTextFormFieldData(
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Email field
                    PlatformTextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: 'Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      material: (_, __) => MaterialTextFormFieldData(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      cupertino: (_, __) => CupertinoTextFormFieldData(
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 12),
                          child: Icon(CupertinoIcons.mail),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Password field
                    PlatformTextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      hintText: 'Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      material: (_, __) => MaterialTextFormFieldData(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      cupertino: (_, __) => CupertinoTextFormFieldData(
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefix: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          child: Icon(_obscurePassword
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Confirm password field
                    PlatformTextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      hintText: 'Confirm Password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _handleSignup(),
                      material: (_, __) => MaterialTextFormFieldData(
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () => setState(() =>
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      cupertino: (_, __) => CupertinoTextFormFieldData(
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefix: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(() =>
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword),
                          child: Icon(_obscureConfirmPassword
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Sign up button
                    PlatformElevatedButton(
                      onPressed: state is AuthLoading ? null : _handleSignup,
                      material: (_, __) => MaterialElevatedButtonData(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FFFF),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      cupertino: (_, __) => CupertinoElevatedButtonData(
                        color: const Color(0xFF00FFFF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: state is AuthLoading
                          ? const PlatformCircularProgressIndicator()
                          : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),

                    const SizedBox(height: 16),

                    // Sign in link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PlatformText(
                          'Already have an account? ',
                          style: platformThemeData(
                            context,
                            material: (data) => data.textTheme.bodyMedium,
                            cupertino: (data) => data.textTheme.textStyle,
                          ),
                        ),
                        PlatformTextButton(
                          onPressed: () => context.go('/login'),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Color(0xFF00FFFF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            RegisterRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              name: _nameController.text.trim(),
            ),
          );
    }
  }

  /// Shows an error dialog with the provided message.
  // TODO(sifterstudios): Not sure how to fix warning
  void _showErrorDialog(BuildContext context, String message) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          PlatformDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
