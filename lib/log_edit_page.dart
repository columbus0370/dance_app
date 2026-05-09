import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'log.dart';
import 'provider/log_provider.dart';

class LogEditPage extends ConsumerStatefulWidget {
  final Log log;

  const LogEditPage({super.key, required this.log});

  @override
  ConsumerState<LogEditPage> createState() => _LogEditPageState();
}

class _LogEditPageState extends ConsumerState<LogEditPage> {
  late DateTime selectedDate;
  late TextEditingController timeController;
  late TextEditingController memoController;
  late TextEditingController urlController;

  List<String> tags = [];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.log.date;
    timeController =
        TextEditingController(text: widget.log.practiceMinutes.toString());
    memoController = TextEditingController(text: widget.log.memo);
    urlController = TextEditingController(text: widget.log.videoUrl);
    tags = List.from(widget.log.tags);
  }

  void saveEdit() async {
    final updated = Log(
      date: selectedDate,
      practiceMinutes: int.tryParse(timeController.text) ?? 0,
      memo: memoController.text,
      tags: List.from(tags),
      videoUrl: urlController.text,
    );

    final notifier = ref.read(logListProvider.notifier);
    await notifier.update(widget.log.key, updated);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編集'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('日付'),
            subtitle: Text(
              "${selectedDate.year}/${selectedDate.month}/${selectedDate.day}",
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => selectedDate = picked);
              }
            },
          ),
          TextField(
            controller: timeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: '練習時間（min）'),
          ),
          TextField(
            controller: memoController,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'メモ'),
          ),
          TextField(
            controller: urlController,
            decoration: const InputDecoration(labelText: '動画URL'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: saveEdit,
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
