import 'package:equatable/equatable.dart';
import 'package:migaproject/Data/analyricline_model.dart';

abstract class AnalyticsLineState extends Equatable {
  const AnalyticsLineState();

  @override
  List<Object> get props => [];
}

class AnalyticsLineInitial extends AnalyticsLineState {}

class AnalyticsLineLoading extends AnalyticsLineState {}

class AnalyticsLineLoaded extends AnalyticsLineState {
  final List<AnalyticsItem> items;

  const AnalyticsLineLoaded({required this.items});

  @override
  List<Object> get props => [items];
}

class AnalyticsLineError extends AnalyticsLineState {
  final String message;

  const AnalyticsLineError({required this.message});

  @override
  List<Object> get props => [message];
}
