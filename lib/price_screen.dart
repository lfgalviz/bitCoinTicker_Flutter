import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value;
          // Call getData() when the picker/dropdown changes.
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCurrency = currenciesList[selectedIndex];
        //Call getData() when the picker/dropdown changes.
        getData();
      },
      children: pickerItems,
    );
  }

  List<String> bitcoinValue=['?','?','?'];

  void getData() async {
    try {
      for (var i = 0; i < cryptoList.length; i++) {
        double data = await CoinData(selectedCurrency, cryptoList[i]).getCoinData();
        // We can't await in a setState(). So you have to separate it out into two steps.
        setState(() {
          bitcoinValue[i] = data.toStringAsFixed(0);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    //TODO: Call getData() when the screen loads up.
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          BuildPadding(
            bitcoinValue: bitcoinValue[0],
            selectedCurrency: selectedCurrency,
            virtualCoin: cryptoList[0],
          ),
          BuildPadding(
              bitcoinValue: bitcoinValue[1],
              selectedCurrency: selectedCurrency,
              virtualCoin: cryptoList[1]),
          BuildPadding(
              bitcoinValue: bitcoinValue[2],
              selectedCurrency: selectedCurrency,
              virtualCoin: cryptoList[2]),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class BuildPadding extends StatelessWidget {
  const BuildPadding({
    Key key,
    @required this.bitcoinValue,
    @required this.selectedCurrency,
    @required this.virtualCoin,
  }) : super(key: key);

  final String virtualCoin;
  final String bitcoinValue;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            //TODO: Update the Text Widget with the live bitcoin data here.
            '1 $virtualCoin = $bitcoinValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
