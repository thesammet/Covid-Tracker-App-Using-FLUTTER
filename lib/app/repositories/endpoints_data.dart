import 'package:covtracker/app/services/api.dart';
import 'package:covtracker/app/services/endpoint_data.dart';

class EndpointsData {
  EndpointsData(this.values);
  final Map<Endpoint, EndpointData> values;

  //Aşağısı debuggingde yardımcı olması için yazıldı
  EndpointData get cases => values[Endpoint.cases];
  EndpointData get casesSuspected => values[Endpoint.casesSuspected];
  EndpointData get casesConfirmed => values[Endpoint.casesConfirmed];
  EndpointData get deaths => values[Endpoint.deaths];
  EndpointData get recovered => values[Endpoint.recovered];

  @override
  String toString() =>
      "cases: $cases, suspected: $casesSuspected, confirmed: $casesConfirmed, deaths:  $deaths, recovered: $recovered";
}
