import '../../../utils/mixins/exceptions/custom_exception_handler.dart';
import '../data/centre_group.dart';
import '../repos/remote_centre_group_repo.dart';

class CentreGroupService {
  CentreGroupService({required RemoteCentreGroupRepo remoteCentreGroupRepo})
    : _remoteCentreGroupRepo = remoteCentreGroupRepo;

  final RemoteCentreGroupRepo _remoteCentreGroupRepo;

  Future<Result<List<CentreGroup>, CustomException>> getCentreGroups() =>
      _remoteCentreGroupRepo.getCentreGroups();
}
