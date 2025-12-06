import 'package:dartz/dartz.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/features/e_card/domain/entities/template_entity.dart';

abstract class TemplateRepository {
  Future<Either<Failure, List<TemplateEntity>>> listTemplates();
}
