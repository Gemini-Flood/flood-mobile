import 'package:first_ai/data/datasources/flood/flood_datasource_impl.dart';
import 'package:first_ai/domain/repositories/flood_repository.dart';
import 'package:provider/provider.dart';

final floodRepositoryProvider = Provider<FloodRepositoryImpl>(create: (ref) {
  final floodDataSourceImpl = FloodDataSourceImpl();
  return FloodRepositoryImpl(floodDataSourceImpl: floodDataSourceImpl);
});

class FloodRepositoryImpl extends FloodRepository {

  final FloodDataSourceImpl floodDataSourceImpl;

  FloodRepositoryImpl({required this.floodDataSourceImpl});

  @override
  Future getReports() async {
    return await floodDataSourceImpl.getReports();
  }

  @override
  Future getUserReports(String id) async {
    return await floodDataSourceImpl.getUserReports(id);
  }

  @override
  Future saveReport(Map<String, String> body, String filepath) async {
    return await floodDataSourceImpl.saveReport(body, filepath);
  }

  @override
  Future getZones() async {
    return await floodDataSourceImpl.getZones();
  }

  @override
  Future actualizeZone(Map<String, dynamic> body) async {
    return await floodDataSourceImpl.actualizeZone(body);
  }

}