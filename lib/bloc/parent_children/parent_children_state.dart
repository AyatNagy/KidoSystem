part of 'parent_children_cubit.dart';

abstract class ParentChildrenState {}

class ParentChildrenInitial extends ParentChildrenState {}

class ParentChildrenLoading extends ParentChildrenState {}

class ParentChildrenReady extends ParentChildrenState {
  final List<Map<String, dynamic>> children;
  final String? notice;

  ParentChildrenReady(this.children, {this.notice});
}
