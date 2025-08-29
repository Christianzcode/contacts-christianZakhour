// lib/presentation/screens/change_history_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // add intl ^0.19.0 in pubspec if not present
import '../../domain/entities/change_record.dart';
import '../blocs/history/history_cubit.dart';

class ChangeHistoryScreen extends StatefulWidget {
  final String contactId;
  final String contactName;
  const ChangeHistoryScreen({
    super.key,
    required this.contactId,
    required this.contactName,
  });

  @override
  State<ChangeHistoryScreen> createState() => _ChangeHistoryScreenState();
}


class _ChangeHistoryScreenState extends State<ChangeHistoryScreen> {
  final _fmt = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    context.read<HistoryCubit>().load(widget.contactId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History • ${widget.contactName}')),
      body: BlocBuilder<HistoryCubit, List<ChangeRecord>>(
        builder: (context, list) {
          if (list.isEmpty) {
            return const Center(child: Text('No history yet'));
          }
          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final r = list[i];
              final when = _fmt.format(r.createdAt);
              final isDelete = r.op.toLowerCase() == 'delete';
              final isCreate = r.op.toLowerCase() == 'create';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: op + date
                    Row(
                      children: [
                        _OpBadge(op: r.op),
                        const SizedBox(width: 8),
                        Text(when, style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Diff rows
                    if (r.diff.isEmpty)
                      Text(
                        isDelete
                            ? 'Deleted'
                            : isCreate
                            ? 'Created'
                            : 'No field changes',
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    else
                      Column(
                        children: r.diff.entries
                        // diff already contains changed fields; if you ever pass full object, keep this where:
                        // .where((e) => (e.value?['before']) != (e.value?['after']))
                            .map((e) => _DiffRow(
                          field: e.key,
                          before: e.value?['before'],
                          after: e.value?['after'],
                        ))
                            .toList(),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _OpBadge extends StatelessWidget {
  final String op;
  const _OpBadge({required this.op});

  @override
  Widget build(BuildContext context) {
    final low = op.toLowerCase();
    IconData icon;
    Color? color;

    if (low == 'delete') {
      icon = Icons.delete_outline;
      color = Colors.red[600];
    } else if (low == 'create') {
      icon = Icons.add_circle_outline;
      color = Colors.green[600];
    } else {
      icon = Icons.edit_outlined;
      color = Colors.blue[600];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color?.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            op.toUpperCase(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

class _DiffRow extends StatelessWidget {
  final String field;
  final dynamic before;
  final dynamic after;

  const _DiffRow({
    required this.field,
    required this.before,
    required this.after,
  });

  String _fmtVal(dynamic v) {
    if (v == null) return '—';
    if (v is String && v.trim().isEmpty) return '—';
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final textStyleField = Theme.of(context)
        .textTheme
        .labelLarge
        ?.copyWith(fontWeight: FontWeight.w600);
    final textStyleVal = Theme.of(context).textTheme.bodyMedium;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.4),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 98,
            child: Text(field, style: textStyleField),
          ),
          Expanded(
            child: Row(
              children: [
                Flexible(child: Text(_fmtVal(before), style: textStyleVal)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.arrow_forward_rounded, size: 16),
                ),
                Flexible(
                  child: Text(
                    _fmtVal(after),
                    style: textStyleVal?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
