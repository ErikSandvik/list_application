import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'list_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';

/// Initialize the app.
void main() {
  runApp(const MyApp());
}

/// The root widget of the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
        ),
        scaffoldBackgroundColor: primaryBackgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBarBackgroundColor,
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: deleteButtonColor,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

/// Main home screen of the app, displays different lists as tabs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

/// State class for HomeScreen.
class HomeScreenState extends State<HomeScreen> {
  List<String> _lists = [];

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  /// Loads saved lists from SharedPreferences.
  Future<void> _loadLists() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      final storedLists = sharedPreferences.getStringList(sharedPreferencesKeyLists);
      if (storedLists != null) {
        _lists = List.of(storedLists);
      } else {
        _lists = List.of(defaultLists);
      }
    });
  }

  /// Saves the lists to SharedPreferences.
  Future<void> _saveLists() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList(sharedPreferencesKeyLists, _lists);
  }

  /// Opens a confirmation dialog and deletes the selected list.
  Future<void> _deleteList(int index) async {
    if (_lists.length == 1) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Kan ikke slette den siste listen.')),
        );
      return;
    }

    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Slett liste'),
          content: Text(
            'Er du sikker på at du vil slette "${_lists[index]}" listen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Slett'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      String listName = _lists[index];
      setState(() {
        _lists = List.of(_lists);
        _lists.removeAt(index);
      });

      await _saveLists();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$listName.json';
      final file = File(filePath);

      if (await file.exists()) {
        try {
          await file.delete();
          debugPrint("Deleted file: $filePath");
        } catch (e) {
          debugPrint("Error deleting file: $e");
        }
      } else {
        debugPrint("File does not exist: $filePath");
      }
    }
  }

  /// Opens a dialog to add a new list and saves it if confirmed.
  Future<void> _addList() async {
    final newListName = await showDialog<String>(
      context: context,
      builder: (context) {
        String input = '';
        return AlertDialog(
          title: const Text('Legg til ny liste.'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Skriv inn navn på liste.'),
            onChanged: (value) => input = value.trim(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, input),
              child: const Text('Legg til'),
            ),
          ],
        );
      },
    );

    if (newListName == null || newListName.isEmpty) return;
    if (_lists.contains(newListName)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$duplicateListMessage "$newListName".')),
        );
      }
      return;
    }
    setState(() {
      _lists = List.of(_lists);
      _lists.add(newListName);
    });

    await _saveLists();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$listAddedMessage "$newListName".')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _lists.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Liste-App'),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: _lists.map((title) => Tab(text: title)).toList(),
          ),
          actions: [
            IconButton(
              tooltip: 'Legg til ny liste',
              onPressed: _addList,
              icon: Container(
                decoration: const BoxDecoration(
                  color: addButtonColor,
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(floatingActionButtonPadding),
                child: const Icon(addListIcon, size: 24.0),
              ),
            ),
          ],
        ),
        body: _lists.isNotEmpty
            ? TabBarView(
          children: _lists
              .asMap()
              .entries
              .map(
                (entry) => Stack(
              children: [
                ListScreen(title: entry.value),
                Positioned(
                  right: 10,
                  top: 10,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: () => _deleteList(entry.key),
                    child: const Icon(deleteListIcon),
                  ),
                ),
              ],
            ),
          )
              .toList(),
        )
            : const Center(
          child: Text('Ingen liste tilgjengelig.'),
        ),
      ),
    );
  }
}
