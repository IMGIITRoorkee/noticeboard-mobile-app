import '../services/api_service/api_service.dart';
import '../models/filters_list.dart';

class FiltersRepository {
  ApiService _apiService = ApiService();

  Future<List<Category>> fetchAllFilters() async {
    List<Category> allFilters = await _apiService.fetchFilters();
    return allFilters;
  }
}
