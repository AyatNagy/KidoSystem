import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/parent_content/dashboard.dart';
import 'package:kido/Pages/parent_content/parent_child_select_screen.dart';
import 'package:kido/bloc/parent_children/parent_children_cubit.dart';

/// Dashboard tab: child list first, then that child's dashboard (same UI as before).
class ParentDashboardFlow extends StatefulWidget {
  const ParentDashboardFlow({super.key});

  @override
  State<ParentDashboardFlow> createState() => _ParentDashboardFlowState();
}

class _ParentDashboardFlowState extends State<ParentDashboardFlow> {
  Map<String, dynamic>? _selectedChild;

  void _selectChild(Map<String, dynamic> child) {
    setState(() => _selectedChild = child);
  }

  void _clearSelection() {
    setState(() => _selectedChild = null);
  }

  Map<String, dynamic> _mergedChildRow(Map<String, dynamic> selected) {
    final state = context.read<ParentChildrenCubit>().state;
    if (state is! ParentChildrenReady) return selected;
    final id = selected['id'];
    for (final c in state.children) {
      if (c['id'] == id) return c;
    }
    return selected;
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedChild == null) {
      return ParentChildSelectScreen(onChildSelected: _selectChild);
    }

    final childData = _mergedChildRow(_selectedChild!);

    return Dashboard(
      key: ValueKey('${childData['id']}_${childData['completedLessons']}'),
      childData: childData,
      onSwitchChild: _clearSelection,
    );
  }
}
