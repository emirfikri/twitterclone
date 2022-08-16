part of 'dashboard_cubit.dart';

enum DashboardTab { first, profile, third }

class DashboardState extends Equatable {
  const DashboardState({
    this.tab = DashboardTab.first,
  });

  final DashboardTab tab;

  @override
  List<Object> get props => [tab];
}
