import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  // func flobal
  runApp(
      MyApp()); // executa apenas um comando que faz o run do app definifo em MyApp
}

// Os widgets são elementos que servem como base para a criação de apps em Flutter
// O código em MyApp configura todo o app. Ele cria o estado geral (falaremos mais sobre isso depois),
// nomeia o app e define o tema visual e o widget "inicial", ou seja, o ponto de partida do app.
class MyApp extends StatelessWidget {
  // a classe my App estende o Stateless widget
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // widget "inicial"
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Cool Names',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromRGBO(206, 61, 243, 1.0)),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// A abordagem do gerenciamento de estado desse app é a do Change Notifier.
// A classe CoolNameState define os dados que o app precisa para funcionar.
// No momento, ele contém apenas uma variável com o par de palavras aleatórias atual.
// A classe "CoolNameState" estende o ChangeNotifier, o que significa que ela pode
// emitir notificações sobre suas próprias mudanças. Se o par de palavras atual mudar,
// alguns widgets deverão saber disso.
// O estado é criado e fornecido a todo o app usando um ChangeNotifierProvider.
class MyAppState extends ChangeNotifier {
  // define o estado do app.
  var current = WordPair.random();

  var pressedState = false;

  get first => null;

  get second => null;

  // O novo método getNext() reatribui o widget current a um novo WordPair aleatório.
  void getNext() {
    current = WordPair.random();
    pressedState = false;
    // envia uma notificação a qualquer elemento que esteja observando MyAppState.
    notifyListeners();
  }

  var favorites = Set.from(<WordPair>{});

  void toggleFavorite() {
    if (favorites.contains(current)) {
      pressedState = false;
      favorites.remove(current);
      print(favorites);
    } else {
      pressedState = true;
      favorites.add(current);
      print(favorites);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
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
                print('selected: $value');
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: GeneratorPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text(appState.pressedState ? 'Remove' : 'Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// classe gerada quando usamos a função de refatoração do VScode
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final style = theme.textTheme.displayMedium?.copyWith(
      color: theme.colorScheme.surface,
      fontWeight: FontWeight.bold,
    );

    // O padding não é um atributo de Textm e sim um widget.
    // Os widgets podem focar em uma única responsabilidade, possibilitando assim
    // total liberdade para criar a interface.
    return Card(
      color: theme.colorScheme.primary,
      elevation: 16.0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),
      ),
    );
  }
}
