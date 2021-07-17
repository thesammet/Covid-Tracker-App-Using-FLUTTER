import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:covtracker/app/services/api.dart';
import 'package:http/http.dart' as http;
import 'package:covtracker/app/services/endpoint_data.dart';

class APIService {
  APIService(this.api);
  final API api;

  Future<String> getAccessToken() async {
    final response = await http.post(api.tokenUri().toString(), headers: {
      "Authorization": "Basic ${api.apiKey}",
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final accessToken = data['access_token'];

      if (accessToken != null) {
        return accessToken;
      }
    }
    print(
        'Request ${api.tokenUri()} failed \n Response ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  Future<EndpointData> getEndpointData(
      {@required String accessToken, @required Endpoint endpoint}) async {
    final uri = api.endpointUri(endpoint);
    final response = await http
        .get(uri.toString(), headers: {"Authorization": "Bearer $accessToken"});
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        //Get bize bir liste döndürdüğü için burada sıfırıncı elemanı endpoint dataya aktarıyoruz.
        final Map<String, dynamic> endpointData = data[0];
        final String responseJsonkeys = _responseJsonKeys[endpoint];

        final int value = endpointData[responseJsonkeys];

        final String dateString = endpointData['date'];
        final date = DateTime.tryParse(dateString);

        if (value != null) {
          return EndpointData(value: value, date: date);
        }
      }
    }
    //hata çıkarsa burada printle gözükecek!
    print(
        'Request $uri failed \n Response ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }

  static Map<Endpoint, String> _responseJsonKeys = {
    Endpoint.cases: "cases",
    Endpoint.casesSuspected: "data",
    Endpoint.casesConfirmed: "data",
    Endpoint.deaths: "data",
    Endpoint.recovered: "data",
  };
}
