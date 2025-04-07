import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'printerf_state.dart';

class PrinterfCubit extends Cubit<PrinterfState> {
  PrinterfCubit() : super(PrinterfInitial());
}
