import 'package:flutter/material.dart';

void showSnackBar({
  required BuildContext context,
  required String message,
  bool isSuccess = true,
  Duration duration = const Duration(seconds: 3),
}) {
  final overlay = Overlay.of(context);
  bool isEntryActive = true;
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 70,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Dismissible(
          direction: DismissDirection.up,
          onDismissed: (direction) {
            overlayEntry.remove();
            isEntryActive = false;
          },
          key: ValueKey(message),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              children: [
                if (isSuccess)
                  const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  ),
                if (!isSuccess)
                  const Icon(
                    Icons.close_outlined,
                    color: Colors.red,
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(duration, () {
    if (isEntryActive) {
      overlayEntry.remove();
      isEntryActive = false;
    }
  });
}
