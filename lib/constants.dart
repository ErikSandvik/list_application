import 'package:flutter/material.dart';

// The colors used in the app
const Color primaryBackgroundColor = Color(0xFF37373E);
const Color appBarBackgroundColor = Color(0xFF443759);
const Color deleteButtonColor = Color(0xFF6433B6);
const Color addButtonColor = Color(0xFF6B5788);
const Color uncompletedSectionColor = Color(0xFF37474F);
const Color completedSectionColor = Color(0xFF388E3C);
const Color listTileColor = Color(0xFF37373E);

// SharedPreferences Keys
const String sharedPreferencesKeyLists = 'tabs';

// Default Lists initialized at start up
const List<String> defaultLists = ['Dagligvarer', 'TODO-liste', 'Utstyr'];

// Text Styles
const TextStyle completedListItemTextStyle = TextStyle(
  color: Colors.grey,
  decoration: TextDecoration.lineThrough,
  decorationColor: Colors.black,
  decorationThickness: 1.5,
);
const TextStyle sectionHeaderTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);
const TextStyle listItemTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
);


// Spacing and Padding
const double listTileSpacing = 8.0;
const double floatingActionButtonPadding = 8.0;
const double sectionHeaderPadding = 8.0;


// Different Snackbar Messages
const String listAddedMessage = 'Listen ble lagt til.';
const String lastListDeletionMessage = 'Kan ikke slette den siste listen.';
const String duplicateListMessage = 'Listen finnes allerede.';

// Icons used in the app
const IconData addListIcon = Icons.add;
const IconData deleteListIcon = Icons.delete;
const IconData uncompletedSectionIcon = Icons.list;
const IconData completedSectionIcon = Icons.check_circle;
