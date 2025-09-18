

import 'package:example/page/sample_page.dart';
import 'package:example/page/sample_with_public_key_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bloc Morph")),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_bloc_morph.png',width: 200,height: 200,),
              Text("Bloc Morph",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text("BlocMorph is your companion in Flutter, seamlessly managing Bloc states and elegantly transitioning between loading, error, empty, and content views for a smooth and polished user experience.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15),),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SamplePage()),
                  );
                },
                child: const Text("Sample1"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SampleWithRequestKeyPage()),
                  );
                },
                child: const Text("Sample With RequestKey"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
