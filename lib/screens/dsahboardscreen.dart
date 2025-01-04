import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List movies = [];
  double selectedRating = 0.0;

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://dummyapi.online/api/movies'));

    if (response.statusCode == 200) {
      List movieData = json.decode(response.body);
      setState(() {
        movies = movieData;
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    // Filter movies based on the selected rating
    final filteredMovies = movies.where((movie) {
      return movie['rating'] >= selectedRating;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Filter by Rating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Slider(
            value: selectedRating,
            min: 0.0,
            max: 10.0,
            divisions: 10,
            label: selectedRating.toString(),
            onChanged: (value) {
              setState(() {
                selectedRating = value;
              });
            },
          ),
          Expanded(
            child: filteredMovies.isEmpty
                ? Center(
              child: Text(
                'No movies found for the selected rating',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: filteredMovies.length,
              itemBuilder: (context, index) {
                final movie = filteredMovies[index];
                return Card(
                  elevation: 4.0,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: movie['image'] != null && movie['image'].isNotEmpty
                        ? Image.network(
                      movie['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image, size: 50, color: Colors.grey);
                      },
                    )
                        : Icon(Icons.image, size: 50, color: Colors.grey),
                    title: Text(movie['movie']),
                    subtitle: Text('Rating: ${movie['rating']}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MovieDetailScreen(imdbUrl: movie['imdb_url']),
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
            // Navigate to IMDb link or use a webview
          },
          child: Text('Go to IMDb'),
        ),
      ),

    );
  }
}
