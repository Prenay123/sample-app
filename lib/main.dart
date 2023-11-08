import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: const MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namer App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepOrange,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyAppState extends ChangeNotifier {
  WordPair current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  void removeFavorite(WordPair name) {
    favorites.remove(name);
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite(WordPair name) {
    if (favorites.contains(name)) {
      favorites.remove(name);
    } else {
      favorites.add(name);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: 0,
              onDestinationSelected: (value) {
                if (value == 1) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const FavoritesPage();
                  }));
                }
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: const GeneratorPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  const GeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState =
        context.watch<MyAppState>(); // Get the app state from the Provider

    IconData icon;
    if (appState.favorites.contains(appState.current)) {
      // Use appState.current directly
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: appState.current), // Use appState.current directly
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite(
                      appState.current); // Use appState.current directly
                },
                icon: Icon(icon),
                label: const Text('Like'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext(); // Call getNext from appState
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  final WordPair pair;

  const BigCard({Key? key, required this.pair}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headlineSmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asPascalCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
        ),
        body: ListView(
          children: appState.favorites.map((pair) {
            return Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                appState.removeFavorite(pair);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.favorite),
                title: Text(pair.asPascalCase.toLowerCase()),
              ),
            );
          }).toList(),
        ));
  }
}

class WordPair {
  final String first;
  final String second;

  WordPair(this.first, this.second);

  String get asPascalCase => '$first$second';

  static WordPair random() {
    final wordPair = generateWordPairs().take(1).first;
    return WordPair(wordPair.first, wordPair.second);
  }
}






































// import 'package:demoapp/main_drawer.dart';
// import 'package:flutter/material.dart';
// import 'package:demoapp/gradient_container.dart';

// void main() {
//   runApp(const MaterialApp(
//     home: MyApp(),
//   ));
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//  @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: const Text(
//         'My Application',
//         style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
//       ),
//     ),
//     drawer: const MainDrawer(),
//     body: const GradientContainer(),
//   );
// }

// }
















