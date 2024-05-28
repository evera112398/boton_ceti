import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class RebuildUI {
  static Future<bool> rebuild(BuildContext context, Function setState) async {
    if (!context.mounted) return false;
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      await SchedulerBinding.instance.endOfFrame;
      if (!context.mounted) return false;
    }
    setState(() {});
    return true;
  }
}
