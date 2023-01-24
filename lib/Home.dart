import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Models/PhotosApi.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PhotosApi> postlist = [];
  Future<List<PhotosApi>> getapi() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body.toString());

    if (response.statusCode == 200) {
      postlist.clear();
      for (var i in data) {
        PhotosApi photos = PhotosApi(
            title: i['title'],
            url: i['url'],
            thumbnailUrl: i['thumbnailUrl'],
            id: i['id']);
        postlist.add(photos);
      }
      return postlist;
    } else {
      return postlist;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                  future: getapi(),
                  builder: (context, AsyncSnapshot<List<PhotosApi>> snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return ListView.builder(
                          itemCount: postlist.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    NetworkImage(snapshot.data![index].url),
                              ),
                              title:
                                  Text(snapshot.data![index].title.toString()),
                              subtitle: Text(snapshot.data![index].thumbnailUrl
                                  .toString()),
                              trailing:
                                  Text(snapshot.data![index].id.toString()),
                            );
                          });
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }
}
