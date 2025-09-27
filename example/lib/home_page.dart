import 'package:example/page/sample_api_page.dart';
import 'package:example/page/sample_api_pagenation.dart';
import 'package:example/page/sample_api_with_key_page.dart';
import 'package:example/page/sample_on_state.dart';
import 'package:example/page/sample_stream.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bloc Morph")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/logo_bloc_morph.png',
                width: 100,
                height: 100,
              ),
              Text(
                "Bloc Morph",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "BlocMorph is your companion in Flutter, seamlessly managing Bloc states and elegantly transitioning between loading, error, empty, and content views for a smooth and polished user experience.",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                height: 1.8,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Samples",
              textAlign: TextAlign.start,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('API Call Sample'),
                  subtitle: Text(
                    'Demonstrates a basic API call, showcasing how BlocMorph handles loading, error, and content states.',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SampleApiPage()),
                    );
                  },
                ),
                ListTile(
                  title: Text('API Call with RequestKey Sample'),
                  subtitle: Text(
                    'Illustrates using RequestKey in BlocMorph to manage multiple API requests and prevent state conflicts.',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SampleApiWithKeyPage(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: Text('Stream Handling Sample'),
                  subtitle: Text(
                    'Shows how to integrate BlocMorph with Streams for dynamic UI updates based on emitted data.',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SampleStream()),
                    );
                  },
                ),
                ListTile(
                  title: Text('onState Callback Sample'),
                  subtitle: Text(
                    'Demonstrates the onState callback in BlocMorph for executing specific actions upon Bloc state changes.',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SampleOnState()),
                    );
                  },
                ),
                ListTile(
                  title: Text('API Pagination Sample'),
                  subtitle: Text(
                    'Provides an example of implementing paginated data loading from an API using BlocMorph.',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black26,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SampleApiPagination(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
