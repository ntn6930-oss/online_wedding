import 'package:dartz/dartz.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/features/e_card/data/datasources/template_remote_data_source.dart';
import 'package:online_wedding/features/e_card/domain/entities/template_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/template_repository.dart';

class TemplateRepositoryImpl implements TemplateRepository {
  final TemplateRemoteDataSource remote;
  TemplateRepositoryImpl({TemplateRemoteDataSource? remote})
      : remote = remote ?? InMemoryTemplateRemoteDataSource();

  @override
  Future<Either<Failure, List<TemplateEntity>>> listTemplates() async {
    try {
      final items = await remote.listTemplates();
      return Right(items);
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
