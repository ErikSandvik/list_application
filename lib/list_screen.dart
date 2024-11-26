import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'constants.dart';

/// ListScreen widget for managing a list and its entries.
class ListScreen extends StatefulWidget {
  final String title;

  const ListScreen({super.key, required this.title});

  @override
  ListScreenState createState() => ListScreenState();
}

/// State class for the ListScreen widget.
class ListScreenState extends State<ListScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _uncompletedEntries = [];
  List<String> _completedEntries = [];

  /// Gets the file path for storing the list as a JSON file.
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/${widget.title}.json');
  }

  /// Load saved entries from the file.
  Future<void> _loadData() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final data = json.decode(await file.readAsString());
        setState(() {
          _uncompletedEntries = List<String>.from(data['uncompleted']);
          _completedEntries = List<String>.from(data['completed']);
        });
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    }
  }

  /// Saves the state of entries to a file.
  Future<void> _saveData() async {
    try {
      final file = await _getFile();
      final data = {
        'uncompleted': _uncompletedEntries,
        'completed': _completedEntries,
      };
      await file.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint("Error saving data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Add a new entry to the uncompleted list.
  void _addEntry(String entry) {
    if (entry.trim().isNotEmpty) {
      setState(() {
        _uncompletedEntries.add(entry);
      });
      _controller.clear();
      _focusNode.requestFocus();
      _saveData();
    }
  }

  /// Toggles completion status of an entry.
  void _toggleEntry(String entry, bool isCompleted) {
    setState(() {
      if (isCompleted) {
        _completedEntries.remove(entry);
        _uncompletedEntries.add(entry);
      } else {
        _uncompletedEntries = List.of(_uncompletedEntries);
        _completedEntries = List.of(_completedEntries);
        _uncompletedEntries.remove(entry);
        _completedEntries.add(entry);
      }
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(sectionHeaderPadding),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                autofocus: true,
                textInputAction: TextInputAction.done,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Legg til',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                onSubmitted: _addEntry,
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).viewInsets.bottom -
                    100,
              ),
              child: Column(
                children: [
                  _buildSectionHeader(
                    'Ikke fullført',
                    uncompletedSectionIcon,
                    uncompletedSectionColor,
                  ),
                  _buildReorderableListView(_uncompletedEntries, false),
                  const Divider(color: Colors.grey, thickness: 2.0),
                  _buildSectionHeader(
                    'Fullført',
                    completedSectionIcon,
                    completedSectionColor,
                  ),
                  ..._completedEntries.map(
                        (item) => ListTile(
                      title: Text(
                        item,
                        style: completedListItemTextStyle,
                      ),
                      onTap: () => _toggleEntry(item, true),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a Reorderable list, that allows user to reorder entries on the list
  /// by long tapping and dragging.
  Widget _buildReorderableListView(List<String> entries, bool isCompleted) {
    return ReorderableListView(
      onReorder: (oldPosition, newPosition) {
        setState(() {
          if (newPosition > oldPosition) {
            newPosition -= 1;
          }

          final String entryToReorder = entries.removeAt(oldPosition);
          _uncompletedEntries.insert(newPosition, entryToReorder);
        });

        _saveData();
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: entries.map((item) {
        return ListTile(
          key: ValueKey(item),
          title: Text(
            item,
            style: isCompleted ? completedListItemTextStyle : listItemTextStyle,
          ),
          tileColor: listTileColor,
          onTap: () => _toggleEntry(item, isCompleted),
          trailing: ReorderableDragStartListener(
            index: entries.indexOf(item),
            child: const SizedBox.shrink(),
          ),
        );
      }).toList(),
    );
  }

  /// Builds section headers to separate the completed section
  /// from the uncompleted section of the list.
  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(sectionHeaderPadding),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: listTileSpacing),
          Text(
            title,
            style: sectionHeaderTextStyle,
          ),
        ],
      ),
    );
  }
}
