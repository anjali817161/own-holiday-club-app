import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:own_holiday_app/utils/app_colors.dart';
import '../controller/otp_controller.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.primaryYellow,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // ── Yellow header ──────────────────────────────────────
          SizedBox(
            height: top + 180,
            child: Stack(
              children: [
                Positioned.fill(child: Container(color: AppColors.primaryYellow)),
                // Back button
                Positioned(
                  top: top + 8,
                  left: 12,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.primaryBlack, size: 26),
                    onPressed: () => Get.back(),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: top + 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeInDown(
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlack.withOpacity(0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shield_rounded,
                              size: 36,
                              color: AppColors.primaryBlack,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FadeInDown(
                          delay: const Duration(milliseconds: 150),
                          child: const Text(
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                              color: AppColors.primaryBlack,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── White body ─────────────────────────────────────────
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
                child: FadeInUp(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Enter Verification Code',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: AppColors.primaryBlack,
                        ),
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'We sent a 6-digit code to\n',
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: AppColors.greyText,
                            height: 1.6,
                          ),
                          children: [
                            TextSpan(
                              text: '+91 ${controller.phoneNumber}',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: AppColors.primaryBlack,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── Animated OTP boxes ──────────────────
                      _OtpBoxes(controller: controller),

                      const SizedBox(height: 40),

                      // ── Verify button ───────────────────────
                      Obx(() => SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: controller.isLoading.value
                                  ? null
                                  : controller.verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryYellow,
                                foregroundColor: AppColors.primaryBlack,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                                elevation: 0,
                              ),
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor: AlwaysStoppedAnimation(
                                            AppColors.primaryBlack),
                                      ),
                                    )
                                  : const Text(
                                      'Verify & Continue',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                            ),
                          )),

                      const SizedBox(height: 28),

                      // ── Resend ──────────────────────────────
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Didn't receive the code? ",
                                style: TextStyle(
                                    color: AppColors.greyText, fontSize: 12.0),
                              ),
                              GestureDetector(
                                onTap: controller.canResend.value
                                    ? controller.resendOtp
                                    : null,
                                child: Text(
                                  controller.canResend.value
                                      ? 'Resend'
                                      : 'Resend in ${controller.resendSeconds.value}s',
                                  style: TextStyle(
                                    color: controller.canResend.value
                                        ? AppColors.primaryBlack
                                        : AppColors.greyText,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Animated OTP Box Widget ──────────────────────────────────────────────────

class _OtpBoxes extends StatefulWidget {
  final OtpController controller;
  const _OtpBoxes({required this.controller});

  @override
  State<_OtpBoxes> createState() => _OtpBoxesState();
}

class _OtpBoxesState extends State<_OtpBoxes> {
  static const int length = 6;
  final List<TextEditingController> _ctrls =
      List.generate(length, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(length, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(String val, int i) {
    if (val.length == 1) {
      if (i < length - 1) {
        _nodes[i + 1].requestFocus();
      } else {
        _nodes[i].unfocus();
      }
    }
    // Collect full OTP
    final otp = _ctrls.map((c) => c.text).join();
    widget.controller.otpController.text = otp;
  }

  void _onKey(RawKeyEvent event, int i) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _ctrls[i].text.isEmpty &&
        i > 0) {
      _nodes[i - 1].requestFocus();
      _ctrls[i - 1].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(length, (i) {
        return _OtpSingleBox(
          ctrl: _ctrls[i],
          node: _nodes[i],
          onChanged: (v) => _onChanged(v, i),
          onKey: (e) => _onKey(e, i),
          index: i,
        );
      }),
    );
  }
}

class _OtpSingleBox extends StatefulWidget {
  final TextEditingController ctrl;
  final FocusNode node;
  final ValueChanged<String> onChanged;
  final ValueChanged<RawKeyEvent> onKey;
  final int index;

  const _OtpSingleBox({
    required this.ctrl,
    required this.node,
    required this.onChanged,
    required this.onKey,
    required this.index,
  });

  @override
  State<_OtpSingleBox> createState() => _OtpSingleBoxState();
}

class _OtpSingleBoxState extends State<_OtpSingleBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 180));
    _scale = Tween<double>(begin: 1.0, end: 1.08).animate(
        CurvedAnimation(parent: _anim, curve: Curves.easeOut));

    widget.node.addListener(() {
      setState(() => _focused = widget.node.hasFocus);
      if (widget.node.hasFocus) {
        _anim.forward();
      } else {
        _anim.reverse();
      }
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 46,
        height: 56,
        decoration: BoxDecoration(
          color: _focused ? AppColors.primaryYellow.withOpacity(0.15) : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _focused ? AppColors.primaryYellow : AppColors.borderGrey,
            width: _focused ? 2 : 1.5,
          ),
          boxShadow: _focused
              ? [
                  BoxShadow(
                    color: AppColors.primaryYellow.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: widget.onKey,
          child: TextField(
            controller: widget.ctrl,
            focusNode: widget.node,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryBlack,
            ),
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}
