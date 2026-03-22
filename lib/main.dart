import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nexorait_education_app/core/di/injection_container.dart';
import 'package:nexorait_education_app/features/student_classes/presentaion/bloc/class_room/class_room_bloc.dart';

import 'app.dart';
import 'core/di/injection_container.dart' as di;
import 'features/attendance/presentaion/bloc/attendance/attendance_bloc.dart';
import 'features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'features/dashboard/presentaion/bloc/mobile_dashboard/mobile_dashboard_bloc.dart';
import 'features/dashboard/presentaion/bloc/sms/sms_bloc.dart';
import 'features/image_upload/presentation/bloc/image_upload/image_upload_bloc.dart';
import 'features/payment/presentaion/bloc/mark_payment/mark_payment_bloc.dart';
import 'features/qr/presentation/bloc/read_attendance/read_attendance_bloc.dart';
import 'features/qr/presentation/bloc/read_payment/read_payment_bloc.dart';
import 'features/qr/presentation/bloc/read_student/read_student_bloc.dart';
import 'features/qr/presentation/bloc/read_student_classes/read_student_classes_bloc.dart';
import 'features/qr/presentation/bloc/read_tute/read_tute_bloc.dart';
import 'features/student_grade/presentation/bloc/student_grade/student_grade_bloc.dart';
import 'features/student_temp_qr_code/presentaion/bloc/temp_qr/temp_qr_bloc.dart';
import 'features/students/presentaion/bloc/attendance_history/attendance_history_bloc.dart';
import 'features/students/presentaion/bloc/payment_history/payment_history_bloc.dart';
import 'features/students/presentaion/bloc/student_classes/student_classes_bloc.dart';
import 'features/students/presentaion/bloc/students/students_bloc.dart';
import 'features/today_attendance/presentation/bloc/daily_attendance_details/daily_attendance_details_bloc.dart';
import 'features/tute/presentation/bloc/tute/tute_bloc.dart';
import 'simple_bloc_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('en', null);
  Bloc.observer = SimpleBlocObserver();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  await di.init();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()),
        BlocProvider(create: (_) => sl<StudentsBloc>()),
        BlocProvider(create: (_) => sl<ReadPaymentBloc>()),
        BlocProvider(create: (_) => sl<MarkPaymentBloc>()),
        BlocProvider(create: (_) => sl<ReadAttendanceBloc>()),
        BlocProvider(create: (_) => sl<AttendanceBloc>()),
        BlocProvider(create: (_) => sl<ReadStudentBloc>()),
        BlocProvider(create: (_) => sl<StudentClassesBloc>()),
        BlocProvider(create: (_) => sl<PaymentHistoryBloc>()),
        BlocProvider(create: (_) => sl<AttendanceHistoryBloc>()),
        BlocProvider(create: (_) => sl<StudentGradeBloc>()),
        BlocProvider(create: (_) => sl<ImageUploadBloc>()),
        BlocProvider(create: (_) => sl<MobileDashboardBloc>()),
        BlocProvider(create: (_) => sl<DailyAttendanceDetailsBloc>()),
        BlocProvider(create: (_) => sl<TempQrBloc>()),
        BlocProvider(create: (_) => sl<TuteBloc>()),
        BlocProvider(create: (_) => sl<ClassRoomBloc>()),
        BlocProvider(create: (_) => sl<ReadStudentClassesBloc>()),
        BlocProvider(create: (_) => sl<ReadTuteBloc>()),
        BlocProvider(create: (_) => sl<SmsBloc>()),
      ],
      child: const NexoraMobileApp(),
    ),
  );
}
