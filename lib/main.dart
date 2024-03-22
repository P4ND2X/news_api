// ignore_for_file: depend_on_referenced_packages, unused_import, prefer_const_constructors, no_leading_underscores_for_local_identifiers, unnecessary_string_interpolations
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<News> newsList = [];

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=eg&category=technology&apiKey=2bfb5ccb6ca745afa50358715b65d263'));
    if (response.statusCode == 200) {
      setState(() {
        newsList = (json.decode(response.body)['articles'] as List)
            .map((item) => News.fromJson(item))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('News App'),
          titleTextStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          backgroundColor: Colors.blue,
        ),
        body: newsList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  _launchURL() async {
                    final Uri url = Uri.parse('${newsList[index].url}');
                    if (!await launchUrl(url)) {
                      throw Exception(
                          'Could not launch ${newsList[index].url}');
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(
                      right: 15,
                      top: 15,
                      left: 15,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(newsList[index].title),
                        SizedBox(
                          height: 5,
                        ),
                        TextButton.icon(
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: _launchURL,
                            icon: Icon(Icons.open_in_browser),
                            label: Text(
                              "Open",
                            )),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class News {
  final String title;
  final String description;
  final String url;
  final String content;

  News({
    required this.title,
    required this.description,
    required this.url,
    required this.content,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
