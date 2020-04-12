import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = '180EFAA8-EAB9-41C3-9674-B5A060F42DFC';

class CoinData {

  String currency;

  CoinData(this.currency);
  //3. Create the Asynchronous method getCoinData() that returns a Future (the price data).
  Future getCoinData() async {
    
    //4. Create a url combining the coinAPIURL with the currencies we're interested, BTC to USD.
    String requestURL = '$coinAPIURL/BTC/$currency?apikey=$apiKey';
    //5. Make a GET request to the URL and wait for the response.
    http.Response response = await http.get(requestURL);

    //6. Check that the request was successful.
    if (response.statusCode == 200) {
      //7. Use the 'dart:convert' package to decode the JSON data that comes back from coinapi.io.
      var decodedData = jsonDecode(response.body);
      //8. Get the last price of bitcoin with the key 'last'.
      var lastPrice = decodedData['rate'];
      //9. Output the lastPrice from the method.
      return lastPrice;
    } else {
      //10. Handle any errors that occur during the request.
      print(response.statusCode);
      //Optional: throw an error if our request fails.
      throw 'Problem with the get request';
    }
  }
}
