import 'package:flutter/material.dart';

class PasswordConditionChecker extends StatefulWidget {
  final Map settedConditions;
  const PasswordConditionChecker({super.key, required this.settedConditions});

  @override
  State<PasswordConditionChecker> createState() =>
      _PasswordConditionCheckerState();
}

class _PasswordConditionCheckerState extends State<PasswordConditionChecker> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.settedConditions.entries.map((e) {
          final isLastElement =
              e.key == widget.settedConditions.entries.last.key;
          return Column(
            children: [
              Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: e.value ? Colors.green : Colors.red,
                      border: e.value
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: e.value
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
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(e.key),
                  ),
                ],
              ),
              if (!isLastElement) ...[
                const SizedBox(height: 20),
              ]
            ],
          );
        }).toList());
  }
}
