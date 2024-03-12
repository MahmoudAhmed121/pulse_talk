import 'package:chat_material3/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CustomField extends StatefulWidget {
  final IconData icon;
  final String lable;
  final TextEditingController controller;
  final bool isPass;
  final String? Function(String?)? validator;
  final void Function()? onEditingComplete;
  final FocusNode? focusNode;
  const CustomField({
    super.key,
    required this.icon,
    required this.lable,
    required this.controller,
    this.isPass = false,
    required this.validator,
    this.onEditingComplete,
    this.focusNode,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextFormField(
        validator: widget.validator,
        obscureText: widget.isPass ? obscure : false,
        controller: widget.controller,
        onEditingComplete: widget.onEditingComplete,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          suffixIcon: widget.isPass
              ? IconButton(
                  onPressed: () {
                    setState(
                      () {
                        obscure = !obscure;
                      },
                    );
                  },
                  icon: const Icon(
                    Iconsax.eye,
                  ),
                )
              : const SizedBox(),
          contentPadding: const EdgeInsets.all(
            16,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
            borderSide: const BorderSide(
              color:  AppColor.kPrimaryColor,
            ),
          ),
          labelText: widget.lable,
          prefixIcon: Icon(
            widget.icon,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
          ),
        ),
      ),
    );
  }
}
