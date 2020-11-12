import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokelibrary/pokedetail.dart';
import 'package:pokelibrary/pokemon.dart';

import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    title: "Pokémon Library",
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var url = "https://raw.githubusercontent.com/Biuni/"
      "PokemonGO-Pokedex/master/pokedex.json";
  PokeHub pokeHub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);

    fetchPokemons();
  }

  fetchPokemons() async {
    var result = await http.get(url);
    var jsonResult = jsonDecode(result.body);
    setState(() {
      pokeHub = PokeHub.fromJson(jsonResult);
      SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokémon Library"),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => initState(),
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.refresh_rounded,
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.teal,
                  image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: AssetImage('assets/pokemon.png'),
                  )),
            ),
            ListTile(
              title: Text('My GitHub'),
              onTap: () => launch('https://www.github.com/abedafr'),
            ),
            ListTile(
              title: Text('My Twitter'),
              onTap: () => launch('https://www.twitter.com/abedafriad'),
            ),
            ListTile(
              title: Text('My Instagram'),
              onTap: () => launch('https://www.instagram.com/abedafriad'),
            ),
            Text(
              "👨‍💻 with ❤\nBy @abedafriad",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w100,
              ),
            ),
          ],
        ),
      ),
      body: pokeHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: pokeHub.pokemon
                  .map((p) => InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PokeDetail(pokemon: p)));
                        },
                        child: Hero(
                          tag: p.img,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fitWidth,
                                          image: NetworkImage(p.img))),
                                ),
                                Text(
                                  p.name,
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
