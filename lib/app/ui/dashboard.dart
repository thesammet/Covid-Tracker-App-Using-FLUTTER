import 'package:flutter/material.dart';
import 'package:covtracker/app/repositories/data_repository.dart';
import 'package:covtracker/app/repositories/endpoints_data.dart';
import 'package:covtracker/app/services/api.dart';
import 'package:covtracker/app/ui/endpoint_card.dart';
import 'package:covtracker/app/ui/last_updated_status_text.dart';
import 'package:covtracker/app/ui/show_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  EndpointsData _endpointsData;

  @override
  void initState() {
    super.initState();
    final dataRepository = Provider.of<DataRepository>(context, listen: false);
    // ilk başta olan datayı getliyoruz. Synchronous olduğu için cachede olan data direk ekranda gözükür.
    _endpointsData = dataRepository.getAllEndpointsCacheData();
    //daha sonra internet varsa update atılıyor.
    _updateData();
  }

  Future<void> _updateData() async {
    try {
      final dataRepository =
          Provider.of<DataRepository>(context, listen: false);
      final endpointsData = await dataRepository.getAllEndpointsData();
      setState(() => _endpointsData = endpointsData);
      //NETWORK ERROR
    } on SocketException catch (_) {
      await showAlertDialog(
          context: context,
          title: "Connection ERROR!",
          content: "Could not retrieve data. Please try again.",
          defaultActionText: "OK");
      //SERVER (4xx or 5xx) ERRORS.
    } catch (_) {
      await showAlertDialog(
          context: context,
          title: "Unknown ERROR!",
          content: "Please contact support or try again later.",
          defaultActionText: "OK");
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = LastUpdatedDateFormatter(_endpointsData != null
        ? _endpointsData.values[Endpoint.cases]?.date
        : null);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'World Covid Tracker App',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _updateData,
          child: ListView(
            children: <Widget>[
              for (var endpoint in Endpoint.values)
                EndpointCard(
                  endpoint: endpoint,
                  value: _endpointsData != null
                      ? _endpointsData.values[endpoint]?.value
                      : null,
                ),
              LastUpdatedStatusText(text: formatter.lastUpdatedStatusText())
            ],
          ),
        ));
  }
}
