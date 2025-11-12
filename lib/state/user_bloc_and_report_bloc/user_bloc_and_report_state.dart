part of 'user_bloc_and_report_bloc.dart';

sealed class UserBlocAndReportState extends Equatable {
  const UserBlocAndReportState();
  
  @override
  List<Object> get props => [];
}

final class UserBlocAndReportInitial extends UserBlocAndReportState {}
class UserBlockSuccess extends UserBlocAndReportState{}
class UserUnblockSuccess extends UserBlocAndReportState{}