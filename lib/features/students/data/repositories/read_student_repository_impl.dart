
import '../../domain/repositories/read_student_repository.dart';
import '../../../qr/data/datasources/read_student_remote_datasource.dart';
import '../models/student_search_model/read_student_response_model.dart';

class ReadStudentRepositoryImpl implements ReadStudentRepository {
  final ReadStudentRemoteDatasource remoteDataSource;

  ReadStudentRepositoryImpl(this.remoteDataSource);

  @override
  Future<ReadStudentResponseModel> readStudent({
    required String token,
    required String customId,
  }) {
    return remoteDataSource.readPayment(
      token: token,
      customId: customId,
    );
  }
}
