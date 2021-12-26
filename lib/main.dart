import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_yososu/model/data.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Data> _data = [];

  // 빈 껍데기만 만들어 놓는 것, 이제 받아와야 하니까!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('요소수 주유소 현황'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.restart_alt_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.restart_alt_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              fetchData();
            },
            child: const Text('가져오기'),
          ),
          Expanded(
            // 남는 공간을 다 사용해야 하니까 Expanded
            child: ListView(
              // 람다식 말고 여러가지 사용할 것이 많으면 중가로로 바꾸는 방법
              children: _data.map((e) {
                return ListTile(
                  title: Text(e.name),
                  subtitle: Text(e.addr),
                  trailing: Text(e.inventory),
                  onTap: () {
                    launch('tel:+010 7185 7436');
                  },
                  // 누르면 클릭되게 하는 방법
                );
              }).toList(),

              // children: _data.map((e) => Text(e.name)).toList(),
              // 한 줄일 때, 가져올 것이 하나 일 때 사용하는 방법
              // Text 형태중의 이름만 꺼내서 각각의 리스트로 만들어서 리스트 뷰로 뿌린다.
            ),
          ),
        ],
      ),
    );
  }

  // fetch 불러 오는 것
  //  void 는 생략가능
  Future<void> fetchData() async {
    var url = Uri.parse(
        'https://api.odcloud.kr/api/uws/v1/inventory?page=1&perPage=10&serviceKey=data-portal-test-key');
    var response = await http.get(url);

    final jsonResult = jsonDecode(response.body);
    final jsonData = jsonResult['data'];

    // forEach 돌면서 Json 데이터로부터 빈껍데기에 붙여서 넣는 것
    // 붕어빵 하나씩 만들어서 빵 봉지에 담는 것
    setState(() {
      _data.clear();
      // 기존의 것을 지워줘
      jsonData.forEach((e) {
        _data.add(Data.fromJson(e));
      });
    });

    print('fetch completed');
    // print('Response status: ${response.body}');
    // print('Response status: ${response.statusCode}');
    // 여기까지 성공
  }
}
