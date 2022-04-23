import 'dart:convert';

import 'package:bitcoin_app/Exchange.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ndialog/ndialog.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('BitCoin'),
          backgroundColor: Colors.blueGrey[900],
          elevation: 10,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 15),
              SizedBox(
                height: 90,
                width: 90,
                child: Center(
                  child: Image.asset('assets/images/bitcoin.png'),
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: SizedBox(height: 590, width: 300, child: HomePage()),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.blueGrey[50],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController inputEditingCtrl = TextEditingController();

  String selectUnit = "btc", unit = "BTC", type = "Crypto", name = "Bitcoin";
  List<String> nameList = [
    "btc",
    "eth",
    "ltc",
    "bch",
    "bnb",
    "eos",
    "xrp",
    "xlm",
    "link",
    "dot",
    "yfi",
    "usd",
    "aed",
    "ars",
    "aud",
    "bdt",
    "bhd",
    "bmd",
    "brl",
    "cad",
    "chf",
    "clp",
    "cny",
    "czk",
    "dkk",
    "eur",
    "gbp",
    "hkd",
    "huf",
    "idr",
    "ils",
    "inr",
    "jpy",
    "krw",
    "kwd",
    "lkr",
    "mmk",
    "mxn",
    "myr",
    "ngn",
    "nok",
    "nzd",
    "php",
    "pkr",
    "pln",
    "rub",
    "sar",
    "sek",
    "sgd",
    "thb",
    "try",
    "twd",
    "uah",
    "vef",
    "vnd",
    "zar",
    "xdr",
    "xag",
    "xau",
    "bits",
    "sats"
  ];
  var val = 0.0;
  double exchanged = 0.0, input = 0.0;
  exchange curType =
      exchange("Not Available", "Not available", "Not available", 0.0, 0.0);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  DropdownButton(
                    itemHeight: 60,
                    value: selectUnit,
                    onChanged: (newValue) {
                      setState(() {
                        selectUnit = newValue.toString();
                      });
                    },
                    items: nameList.map((selectUnit) {
                      return DropdownMenuItem(
                        child: Text(
                          selectUnit,
                        ),
                        value: selectUnit,
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  SizedBox(
                      width: 200,
                      height: 40,
                      child: TextField(
                        controller: inputEditingCtrl,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: InputDecoration(
                          hintText: "Input value only",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      )),
                ],
              )
            ],
          ),
          ElevatedButton(
            onPressed: _typeBtn,
            child: const Text("Exchange"),
            style: ElevatedButton.styleFrom(primary: Colors.blueGrey[900]),
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 4,
            color: Colors.blueGrey,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Coingrid(
              curType: curType,
            ),
          ),
        ],
      ),
    );
  }

  _typeBtn() async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Progress"), title: const Text("Searching..."));
    progressDialog.show();
    var url = Uri.parse('https://api.coingecko.com/api/v3/exchange_rates');
    var response = await http.get(url);
    input = double.parse(inputEditingCtrl.text);
    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedData = json.decode(jsonData);
      type = parsedData['rates'][selectUnit]['type'];
      name = parsedData['rates'][selectUnit]['name'];
      unit = parsedData['rates'][selectUnit]['unit'];
      val = parsedData['rates'][selectUnit]['value'];
      setState(() {
        exchanged = input * val;
        curType = exchange(type, name, unit, val, exchanged);
      });
    }
    progressDialog.dismiss();
  }
}

class Coingrid extends StatefulWidget {
  final exchange curType;
  const Coingrid({Key? key, required this.curType}) : super(key: key);
  @override
  State<Coingrid> createState() => _CoingridState();
}

class _CoingridState extends State<Coingrid> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: 300,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.curType.name,
                  style: const TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            width: 300,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                const Text(
                  "Value",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.curType.val.toString(),
                  style: const TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(20),
            width: 300,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                const Text(
                  "Exchange Value",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.curType.ex.toString(),
                  style: const TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    width: 140,
                    height: 156,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text("Units",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Icon(Icons.currency_bitcoin_rounded,
                            size: 30, color: Colors.blueGrey),
                        Text(
                          widget.curType.unit,
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    width: 140,
                    height: 156,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Type",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        const Icon(Icons.money_rounded,
                            size: 30, color: Colors.blueGrey),
                        Text(
                          widget.curType.type,
                          style: const TextStyle(fontSize: 13),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
