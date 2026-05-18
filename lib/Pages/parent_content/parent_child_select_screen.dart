// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kido/Pages/parent_content/dashboard.dart';
import 'package:kido/Widgets/Layout/header_clipper.dart';
import 'package:kido/bloc/parent_children/parent_children_cubit.dart';
import 'package:kido/constants.dart';

/// Shown before the parent dashboard: pick which child to view.
class ParentChildSelectScreen extends StatelessWidget {
  final void Function(Map<String, dynamic> child)? onChildSelected;

  const ParentChildSelectScreen({super.key, this.onChildSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Stack(
        children: [
          _buildHeader(),
          SafeArea(
            child: RefreshIndicator(
              color: AppColors.kidoPink,
              onRefresh: () => context.read<ParentChildrenCubit>().loadChildren(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Choose a child',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Select a profile to view their learning dashboard',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 28),
                    BlocBuilder<ParentChildrenCubit, ParentChildrenState>(
                      builder: (context, state) {
                        if (state is ParentChildrenLoading) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 48),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.kidoPink,
                              ),
                            ),
                          );
                        }

                        if (state is ParentChildrenReady && state.children.isEmpty) {
                          return _emptyState();
                        }

                        if (state is ParentChildrenReady) {
                          return Column(
                            children: state.children.map((child) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _ChildPickCard(
                                  child: child,
                                  onTap: () => _openDashboard(context, child),
                                ),
                              );
                            }).toList(),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDashboard(BuildContext context, Map<String, dynamic> child) {
    if (onChildSelected != null) {
      onChildSelected!(child);
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Dashboard(
          childData: child,
          onSwitchChild: () => Navigator.pop(context),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ClipPath(
      clipper: HeaderClipper(),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.kidoPink.withOpacity(0.9),
              AppColors.kidoOrange.withOpacity(0.9),
              AppColors.kidoYellow.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(CupertinoIcons.person_add, size: 48, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            'No children linked yet.\nAdd a child from the Home tab first.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _ChildPickCard extends StatelessWidget {
  final Map<String, dynamic> child;
  final VoidCallback onTap;

  const _ChildPickCard({required this.child, required this.onTap});

  Color _levelColor(int level) {
    switch (level) {
      case 1:
        return const Color(0xFF2C8FF9);
      case 2:
        return const Color(0xFFFF8A65);
      case 3:
        return const Color(0xFFF06292);
      default:
        return const Color(0xFF2C8FF9);
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = child['name'] as String? ?? 'Child';
    final level =
        (child['allowedLevel'] as int?) ?? (child['level'] as int?) ?? 1;
    final completed = (child['completedLessons'] as num?)?.toInt() ?? 0;
    final color = _levelColor(level);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.12),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.15),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level $level • $completed lessons done',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
