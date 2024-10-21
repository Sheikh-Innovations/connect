import 'package:connect/data/providers/hive_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

void showEditDeleteModal(
    {required BuildContext context,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required String senderId}) {
  showCupertinoModalPopup(
    context: context,
    builder: (BuildContext context) {
      return CupertinoActionSheet(
        title: Text(
          'Select Action Type',
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          if (senderId == HiveService.instance.userData?.id)
            CupertinoActionSheetAction(
              onPressed: onEdit,
              child: Text('Edit ', style: TextStyle(fontSize: 16.sp)),
            ),
          CupertinoActionSheetAction(
            onPressed: onDelete,
            child: Text('Remove', style: TextStyle(fontSize: 16.sp)),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context); // Close the modal
          },
          child: const Text('Cancel'),
        ),
      );
    },
  );
}

void _showEditDialog(
    BuildContext context, String messageId, Function(String, String) onEdit) {
  final TextEditingController _controller = TextEditingController();

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('Edit Message'),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: CupertinoTextField(
            controller: _controller,
            placeholder: 'Enter new message',
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
          ),
          CupertinoDialogAction(
            child: Text('Save'),
            onPressed: () {
              final newContent = _controller.text;
              if (newContent.isNotEmpty) {
                onEdit(messageId, newContent); // Call the edit function
                Navigator.pop(context); // Close the dialog
              }
            },
          ),
        ],
      );
    },
  );
}