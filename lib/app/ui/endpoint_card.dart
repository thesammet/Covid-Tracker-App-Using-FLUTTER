import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:covtracker/app/services/api.dart';

class EndpointCardData {
  EndpointCardData(this.title, this.assetName, this.color);

  final String title;
  final String assetName;
  final Color color;
}

class EndpointCard extends StatelessWidget {
  const EndpointCard({Key key, this.endpoint, this.value}) : super(key: key);

  final Endpoint endpoint;
  final int value;

  static Map<Endpoint, EndpointCardData> _cardsData = {
    Endpoint.cases: EndpointCardData(
        'Cases', '.vscode/assets/count.png', Color(0xFFFFF492)),
    Endpoint.casesSuspected: EndpointCardData(
        'Suspected Cases', '.vscode/assets/suspect.png', Color(0xFFEEDA28)),
    Endpoint.casesConfirmed: EndpointCardData(
        'Confirmed Cases', '.vscode/assets/fever.png', Color(0xFFE99600)),
    Endpoint.deaths: EndpointCardData(
        'Deaths', '.vscode/assets/death.png', Color(0xFFE40000)),
    Endpoint.recovered: EndpointCardData(
        'Recovered', '.vscode/assets/patient.png', Color(0xFF70A901)),
  };

  String get formattedValue {
    if (value == null) {
      return "";
    }
    return NumberFormat("#,###,###,###").format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardsData[endpoint];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(cardData.title,
                  style: TextStyle(
                      fontSize: 20,
                      color: cardData.color,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 4,
              ),
              SizedBox(
                height: 52,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(cardData.assetName),
                      Text(
                        formattedValue,
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
