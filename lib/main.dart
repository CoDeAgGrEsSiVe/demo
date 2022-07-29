// import 'dart:_http';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'category.dart';



void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Category>> categoryFuture = getCategory();

  static Future<List<Category>> getCategory() async {
    const url = 'https://10.0.2.2:7272/api/v1/Categories';
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    return data.map<Category>(Category.fromJson).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('category'),
        ),
        body: Center(
            child: FutureBuilder<List<Category>>(
                future: categoryFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final category = snapshot.data!;
                    return buildCategory(category);
                  } else {
                    return const Text('No data');
                  }
                })));
  }
  Widget buildCategory(List<Category> category) => ListView.builder(
      itemCount: category.length,
      itemBuilder: (context, index) {
        final item = category[index];

        return Card(
          child: ListTile(
            title: Text(item.name),
            leading: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(item.icon),
            ),
          ),
        );
      });

}


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

 // body: ListView.builder(
      //   itemCount: category.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(category[index].name),
      //       subtitle: Text(category[index].color.toString()),
      //       leading: CircleAvatar(
      //         backgroundColor: category[index].color,
      //       ),
      //     );
      //   },
