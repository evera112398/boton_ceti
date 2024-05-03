import 'package:flutter/material.dart';

class IconBuilder extends StatefulWidget {
  final bool status;
  const IconBuilder({super.key, required this.status});

  @override
  State<IconBuilder> createState() => _IconBuilderState();
}

class _IconBuilderState extends State<IconBuilder> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: widget.status ? Colors.green : Colors.red,
        border: widget.status
            ? Border.all(color: Colors.transparent)
            : Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: widget.status
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 15,
              )
            : const Icon(
                Icons.close,
                color: Colors.white,
                size: 15,
              ),
      ),
    );
  }
}
