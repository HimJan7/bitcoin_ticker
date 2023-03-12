import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'C08699E8-7777-4394-95CD-991582F6019D';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  double btcPrice = 0, ethPrice = 0, ltcPrice = 0;
  String currency = 'USD';
  double? temp, temp1, temp2;
  String? selectedCurrency = 'USD';

  void getPrice(selectedCurrency) async {
    String url =
        'https://rest.coinapi.io/v1/exchangerate/BTC/$selectedCurrency?apikey=$apiKey';

    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);
      temp = decodedData['rate'];
    }
    url =
        'https://rest.coinapi.io/v1/exchangerate/ETH/$selectedCurrency?apikey=$apiKey';

    http.Response response1 = await http.get(Uri.parse(url));
    if (response1.statusCode == 200) {
      String data = response1.body;
      var decodedData = jsonDecode(data);
      temp1 = decodedData['rate'];
    }
    url =
        'https://rest.coinapi.io/v1/exchangerate/LTC/$selectedCurrency?apikey=$apiKey';

    http.Response response2 = await http.get(Uri.parse(url));
    if (response2.statusCode == 200) {
      String data = response2.body;
      var decodedData = jsonDecode(data);
      temp2 = decodedData['rate'];
    }
    setState(() {
      btcPrice = double.parse((temp!).toStringAsFixed(2));
      ethPrice = double.parse((temp1!).toStringAsFixed(2));
      ltcPrice = double.parse((temp2!).toStringAsFixed(2));
    });
  }

  Widget cupertinoChild() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        getPrice(selectedCurrency);
      },
      children: pickerItems,
    );
  }

  Widget dropDownChild() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton(
        value: selectedCurrency,
        items: dropDownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            getPrice(selectedCurrency);
          });
        });
  }

  void initState() {
    super.initState();
    getPrice(currency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $btcPrice $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ETH = $ethPrice $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 LTC = $ltcPrice $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
              height: 150.0,
              padding: EdgeInsets.only(bottom: 30),
              alignment: Alignment.center,
              color: Colors.lightBlue,
              child: Platform.isIOS ? cupertinoChild() : dropDownChild()),
        ],
      ),
    );
  }
}
