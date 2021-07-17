import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:covtracker/app/repositories/endpoints_data.dart';
import 'package:covtracker/app/services/api.dart';
import 'package:covtracker/app/services/api_service.dart';
import 'package:covtracker/app/services/data_cache_service.dart';
import 'package:covtracker/app/services/endpoint_data.dart';

class DataRepository {
  DataRepository({this.dataCacheService, @required this.apiService});
  final APIService apiService;
  final DataCacheService dataCacheService;

  String _accessToken;

  Future<EndpointData> getEndpointData(Endpoint endpoint) async =>
      await _getDataRefreshingToken<EndpointData>(
          onGetData: () => apiService.getEndpointData(
              accessToken: _accessToken, endpoint: endpoint));

  EndpointsData getAllEndpointsCacheData() => dataCacheService.getData();

  Future<EndpointsData> getAllEndpointsData() async {
    final endpointsData = await _getDataRefreshingToken<EndpointsData>(
      onGetData: _getAllEndpointData,
    );
    await dataCacheService.setData(endpointsData);
    return endpointsData;
  }

  Future<T> _getDataRefreshingToken<T>({Future<T> Function() onGetData}) async {
    try {
      if (_accessToken == null) {
        _accessToken = await apiService.getAccessToken();
      }

      return await onGetData();
    } on Response catch (response) {
      if (response.statusCode == 401) {
        _accessToken = await apiService.getAccessToken();
        return await onGetData();
      }
      rethrow;
    }
  }

  Future<EndpointsData> _getAllEndpointData() async {
    //Future.wait tüm dataların aynı anda dolmasını bekler ve
    //dataların hepsi geldikten sonra cevap döndürür.
    final value = await Future.wait([
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.cases),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesSuspected),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.casesConfirmed),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.deaths),
      apiService.getEndpointData(
          accessToken: _accessToken, endpoint: Endpoint.recovered),
    ]);

    return EndpointsData({
      Endpoint.cases: value[0],
      Endpoint.casesSuspected: value[1],
      Endpoint.casesConfirmed: value[2],
      Endpoint.deaths: value[3],
      Endpoint.recovered: value[4],
    });
  }
}
