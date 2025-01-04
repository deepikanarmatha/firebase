import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List movies = [];  // To store fetched movies

  // Fetch movie data from the API
  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://dummyapi.online/api/movies'));

    if (response.statusCode == 200) {
      List movieData = json.decode(response.body);  // Decode the response into a list
      setState(() {
        movies = movieData;  // Store the fetched movies in the list
      });
      Fluttertoast.showToast(
        msg: "Movies fetched successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      throw Exception('Failed to load movies');
    }
  }



  @override
  void initState() {
    super.initState();
    fetchMovies();  // Fetch movies when the widget is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard',  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding:  EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'Movies List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display loading indicator or list of movies
            movies.isEmpty
                ? Center(child: CircularProgressIndicator())  // Show loading if movies are empty
                : Expanded(
              child: ListView.builder(
                itemCount: movies.length,  // Count the number of movies in the list
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return Card(
                    elevation: 4.0,
                    child: ListTile(
                      leading: Image.asset(
                        movie['image'],  // Display movie image (locally or from URL)
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(movie['movie']),  // Display movie name
                      subtitle: Text('Rating: ${movie['rating']}'),  // Display movie rating
                      onTap: () {
                        // Navigate to IMDb URL
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailScreen(imdbUrl: movie['imdb_url']),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final String imdbUrl;

  MovieDetailScreen({required this.imdbUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Movie Details')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Open IMDb link
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WebViewScreen(url: imdbUrl)),
            );
          },
          child: Text('Go to IMDb'),
        ),
      ),
    );
  }
}

class WebViewScreen extends StatelessWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('IMDb')),
      body: Center(
        child: Text('Opening IMDb at: $url'),
      ),
    );
  }
}
