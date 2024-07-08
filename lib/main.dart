import 'package:english_words/english_words.dart';
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
      create: (context) => CoolNameState(),
      child: MaterialApp(
        title: 'Cool Names',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
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
class CoolNameState extends ChangeNotifier {
  // define o estado do app.
  var current = WordPair.random();

  // O novo método getNext() reatribui o widget current a um novo WordPair aleatório.
  void getNext() {
    current = WordPair.random();
    // envia uma notificação a qualquer elemento que esteja observando MyAppState. 
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  // Cada widget define um método que é chamado sempre que as circunstâncias
  // do widget mudam, para que ele sempre fique atualizado. Cada método build
  // precisa retornar um widget ou uma árvore aninhada de widgets.
  Widget build(BuildContext context) {
    // Rastreia mudanças no estado atual do app utilizando o médodo watch.
    var appState = context.watch<CoolNameState>();

    // Widget de nível superior. Widget útil muito encontrado
    // na maioria dos apps do mundo real. Utilizado para definir o esqueleto
    // padrão dos apps android.
    return Scaffold(
      // Column é um widget padrão do flutter que recebe qualquer número de filhos
      // e os coloca em uma coluna de cima para baixo. Por padrão, a coluna coloca
      // os filhos visualmente no topo. Cria uma col dentro do scaffold.
      body: Column(
        children: [
          // Widget que define um texto
          Text('A random cool idea:'),
          // Usa a var appState que está acessando a classe CoolNameState pegando
          // o único elemento ("current"). O WordPair fornece vários métodos como
          // asLowerCase, entre outros.
          Text(appState.current.asUpperCase),
          ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('next')),
          ElevatedButton(
              onPressed: () {
                print("Favorite word");
              },
              child: Icon(Icons.heart_broken))
          // Essa vírgula específica não precisa estar ali, porque children
          // é o último (e também o único) membro dessa lista de parâmetros Column
          // No entanto, essa virgula eh necessaria para o formatador funcionar com
          // integridade.
        ],
      ),
    );
  }
}
