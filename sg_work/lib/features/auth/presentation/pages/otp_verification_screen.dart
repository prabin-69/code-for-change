import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../bloc/auth_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/gradient_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  String _currentOtp = '';
  int _resendSeconds = 60;
  Timer? _resendTimer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendSeconds = AppConstants.otpTimeout.inSeconds;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _canResend = true;
            _resendSeconds = 0;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _resendSeconds--;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Gradient Header ───
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDark,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Back Button ───
                  GestureDetector(
                    onTap: () => context.go(RouteConstants.phoneLogin),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ─── Title ───
                  const Text(
                    'Verify OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ─── Subtitle ───
                  Text.rich(
                    TextSpan(
                      text: 'Enter the 6-digit code sent to\n',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      children: [
                        TextSpan(
                          text: widget.phoneNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ─── Body ───
            Expanded(
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    context.go(RouteConstants.home);
                  } else if (state is RoleSelectionRequired) {
                    context.go(RouteConstants.roleSelection);
                  } else if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.danger,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // ─── OTP Input ───
                      PinCodeTextField(
                        appContext: context,
                        length: AppConstants.otpLength,
                        controller: _otpController,
                        onChanged: (value) {
                          _currentOtp = value;
                        },
                        onCompleted: (value) {
                          context.read<AuthBloc>().add(
                                VerifyOtpEvent(
                                    widget.phoneNumber, value),
                              );
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(14),
                          fieldHeight: 58,
                          fieldWidth: 48,
                          borderWidth: 1.5,
                          activeFillColor: AppColors.surface,
                          inactiveFillColor: AppColors.surface,
                          selectedFillColor: AppColors.surface,
                          activeColor: AppColors.primary,
                          inactiveColor: AppColors.outline,
                          selectedColor: AppColors.primaryLight,
                          errorBorderColor: AppColors.danger,
                        ),
                        enableActiveFill: true,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        animationDuration: const Duration(milliseconds: 200),
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        autoFocus: true,
                        enablePinAutofill: true,
                      ),

                      const SizedBox(height: 32),

                      // ─── Verify Button ───
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is AuthLoading;
                          final isOtpComplete =
                              _currentOtp.length == AppConstants.otpLength;
                          return GradientButton(
                            label: 'Verify',
                            icon: Icons.verified_outlined,
                            isLoading: isLoading,
                            onPressed: (isLoading || !isOtpComplete)
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                          VerifyOtpEvent(
                                            widget.phoneNumber,
                                            _currentOtp,
                                          ),
                                        );
                                  },
                          );
                        },
                      ),

                      const SizedBox(height: 28),

                      // ─── Resend Section ───
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Didn't receive the code? ",
                            style: TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 14,
                            ),
                          ),
                          if (!_canResend)
                            Text(
                              'Resend in ${_resendSeconds}s',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: () {
                                context
                                    .read<AuthBloc>()
                                    .add(SendOtpEvent(widget.phoneNumber));
                                _startResendTimer();
                              },
                              child: const Text(
                                'Resend Code',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
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
          ],
        ),
      ),
    );
  }
}

