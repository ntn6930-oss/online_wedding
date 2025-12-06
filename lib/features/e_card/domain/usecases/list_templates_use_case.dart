import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:online_wedding/core/error/failures.dart';
import 'package:online_wedding/core/usecases/usecase.dart';
import 'package:online_wedding/features/e_card/domain/entities/template_entity.dart';
import 'package:online_wedding/features/e_card/domain/repositories/template_repository.dart';

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  throw UnimplementedError();
});

final listTemplatesUseCaseProvider = Provider<ListTemplatesUseCase>((ref) {
  final repo = ref.watch(templateRepositoryProvider);
  return ListTemplatesUseCase(repo);
});

class ListTemplatesUseCase
    extends UseCase<List<TemplateEntity>, void> {
  final TemplateRepository repository;
  ListTemplatesUseCase(this.repository);
  @override
  Future<Either<Failure, List<TemplateEntity>>> call(void params) async {
    return repository.listTemplates();
  }
}
