import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexorait_education_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:nexorait_education_app/features/payment/presentaion/pages/payment_page.dart';
import 'package:nexorait_education_app/features/profile/presentaion/pages/user_profile_page.dart';
import 'package:nexorait_education_app/features/student_classes/presentaion/pages/create_student_classes.dart';
import 'package:nexorait_education_app/features/student_temp_qr_code/presentaion/pages/temp_qr_page.dart';
import 'package:nexorait_education_app/features/students/presentaion/pages/attendance_history_page.dart';
import 'package:nexorait_education_app/features/students/presentaion/pages/create_student_page.dart';
import 'package:nexorait_education_app/features/students/presentaion/pages/payment_history_view_page.dart';
import 'package:nexorait_education_app/features/students/presentaion/pages/student_custom_id_page.dart';
import 'package:nexorait_education_app/features/students/presentaion/pages/student_list_page.dart';
import 'package:nexorait_education_app/features/today_attendance/presentation/pages/today_attendance_page.dart';

import '../features/attendance/presentaion/pages/attendance_page.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../features/auth/presentation/pages/signin_page.dart';
import '../features/dashboard/presentaion/pages/dashboard_page.dart';
import '../features/image_upload/presentation/pages/student_image_capture_page.dart';
import '../features/qr/presentation/pages/qr_scanner_page.dart';
import '../features/splash_screen.dart';
import '../features/student_temp_qr_code/presentaion/pages/activated_student_qr_page.dart';
import '../features/students/presentaion/pages/student_upload_image_page.dart';
import '../features/tute/presentation/pages/create_tute_page.dart';
import '../features/tute/presentation/pages/tute_view_page.dart';

class AppRoutes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final repository = AuthRepositoryImpl(AuthRemoteDataSource());
    final loginUseCase = LoginUseCase(repository);
    final logoutUseCase = LogoutUseCase(repository);

    final authBloc = AuthBloc(
      loginUseCase: loginUseCase,
      logoutUseCase: logoutUseCase,
    );

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/signup':
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider.value(value: authBloc, child: const SigninPage()),
        );

      case '/dashboard':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authBloc, // re-use the same AuthBloc from login
            child: DashboardPage(
              token: args['token'],
              userModel: args['user_model'],
            ),
          ),
        );

      case '/students':
        final token = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => StudentListPage(token: token ?? ''),
        );
      case '/add-student-class':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => CreateStudentClasses(
            token: args['token'], // pass the token
            readStudentClassesState:
                args['read_student_classes_state'], // pass the loaded state
          ),
        );
      case '/students_image_upload':
        final token = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => StudentUploadImagePage(token: token ?? ''),
        );
      case '/create_student':
        final token = settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => CreateStudentPage(
            token: token?['token'],
            quickImageId: token?['quick_image_id'],
            imageUrl: token?['image_url'],
          ),
        );
      case '/student-id-numbers':
        final token = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => StudentCustomIdPage(token: token ?? ''),
        );
      case '/qr-scan':
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          settings: const RouteSettings(name: '/qr-scan'),
          builder: (_) =>
              QrScannerPage(scanType: args['scanType'], token: args['token']),
        );

      case '/attendance-details':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => AttendancePage(
            token: args['token'], // pass the token
            attendanceState: args['attendanceState'], // pass the loaded state
          ),
        );
      case '/today-attendance':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => TodayAttendancePage(
            token: args['token'], // pass the token
            classId: args['class_id'], // pass the classId
            attendanceId: args['attendance_id'], // pass the attendanceId
            classCategory:
                args['class_has_category_id'], // pass the classCategory
          ),
        );
      case '/attendance-history':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => AttendanceHistoryPage(
            classCategoryHasStudentClassId:
                args['class_category_has_student_class_id'], // pass the token
            studentId: args['student_id'],
            token: args['token'],
          ),
        );

      case '/image_capture':
        final token = settings.arguments as String; // cast as Map

        return MaterialPageRoute(
          builder: (_) => StudentImageCapturePage(token: token),
        );
      case '/payment-details':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => PaymentPage(
            token: args['token'], // pass the token
            paymentState: args['paymentState'], // pass the loaded state
          ),
        );
      case '/read_tute':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map
        return MaterialPageRoute(
          builder: (_) => CreateTutePage(
            token: args['token'], // pass the token
            readTuteResponse:
                args['read_tute_success'], // pass the read_tute_success
          ),
        );
      case '/tute':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map
        return MaterialPageRoute(
          builder: (_) => TuteViewPage(
            token: args['token'], // pass the token
            studentId: args['student_id'], // pass the studentId
            classCategoryStudentClassId:
                args['class_category_has_student_class_id'], // pass the classCategoryStudentClassId
          ),
        );
      case '/payment-history':
        final args = settings.arguments as Map<String, dynamic>; // cast as Map

        return MaterialPageRoute(
          builder: (_) => PaymentHistoryViewPage(
            studentId: args['student_id'],
            studentStudentClassId: args['student_student_class_id'],
            token: args['token'], // pass the token
          ),
        );
      case '/temp_qr_page':
        final token = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => TempQrPage(token: token ?? ''),
        );
      case '/active-qr':
        final token = settings.arguments as String?;

        return MaterialPageRoute(
          builder: (_) => ActivatedStudentQrPage(token: token ?? ''),
        );
      case '/user-profile':
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) =>
              UserProfilePage(token: args['token'], user: args['user_model']),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              BlocProvider.value(value: authBloc, child: const SigninPage()),
        );
    }
  }
}
