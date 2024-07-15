import 'package:first_ai/domain/repositories/flood_repository.dart';

class FloodUseCase {
  final FloodRepository _floodRepository;

  FloodUseCase(this._floodRepository);

  Future getReports() async {
    return await _floodRepository.getReports();
  }

  Future getUserReports(String id) async {
    return await _floodRepository.getUserReports(id);
  }

  Future saveReport(Map<String, String> body, String filepath) async {
    return await _floodRepository.saveReport(body, filepath);
  }

  Future getZones() async {
    return await _floodRepository.getZones();
  }

  Future actualizeZone(Map<String, dynamic> body) async {
    return await _floodRepository.actualizeZone(body);
  }

}