import 'package:http/http.dart' as http;
import '../api/api_client.dart';
import '../../utils/api_constants.dart';

class ServiceRepo {
  final ApiClient apiClient;

  ServiceRepo({required this.apiClient});

  Future<http.Response> getExploreServices() async {
    return await apiClient.getData(ApiConstants.exploreServices);
  }

  Future<http.Response> getDestinations() async {
    return await apiClient.getData(ApiConstants.destinations);
  }

  Future<http.Response> getServiceDetailsList() async {
    return await apiClient.getData(ApiConstants.serviceDetails);
  }

  Future<http.Response> getServiceDetails(String slug) async {
    return await apiClient.getData("${ApiConstants.serviceDetails}?slug=$slug");
  }

  Future<http.Response> submitServiceEnquiry(dynamic data) async {
    return await apiClient.postData(ApiConstants.serviceEnquiries, data);
  }

  Future<http.Response> submitDestinationEnquiry(dynamic data) async {
    return await apiClient.postData(ApiConstants.enquiries, data);
  }

  Future<http.Response> submitGeneralEnquiry(dynamic data) async {
    return await apiClient.postData(ApiConstants.holidayLeads, data);
  }

  Future<http.Response> getFaqs() async {
    return await apiClient.getData("${ApiConstants.faq}/membership");
  }

  Future<http.Response> getHeroSlides() async {
    return await apiClient.getData(ApiConstants.heroSlides);
  }
}
