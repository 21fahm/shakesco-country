library shakesco_country;

import 'package:shakesco_country/selection_list.dart';
import 'package:shakesco_country/selection/code_countries_en.dart';
import 'package:shakesco_country/selection/code_country.dart';
import 'package:flutter/material.dart';

import 'modern.dart';

export 'selection/code_country.dart';

export 'country_selection_theme.dart';

class CountryListPick extends StatefulWidget {
  CountryListPick({
    required this.onChanged,
    this.initialSelection,
    this.hintText,
    this.pickerBuilder,
  });

  final String? initialSelection;
  final String? hintText;
  final ValueChanged<CountryCode?> onChanged;
  final Widget Function(BuildContext context, CountryCode? countryCode)?
      pickerBuilder;

  @override
  _CountryListPickState createState() {
    List<Map> jsonList = countriesEnglish;

    List elements = jsonList
        .map((s) => CountryCode(
              name: s['name'],
              code: s['code'],
              dialCode: s['dial_code'],
              flagUri: 'flags/${s['code'].toLowerCase()}.png',
            ))
        .toList();
    return _CountryListPickState(elements);
  }
}

class _CountryListPickState extends State<CountryListPick> {
  CountryCode? selectedItem;
  List elements = [];

  _CountryListPickState(this.elements);

  @override
  void initState() {
    if (widget.initialSelection != null) {
      selectedItem = elements.firstWhere(
          (e) =>
              (e.code.toUpperCase() ==
                  widget.initialSelection!.toUpperCase()) ||
              (e.dialCode == widget.initialSelection),
          orElse: () => elements[0] as CountryCode);
    } else {
      selectedItem = elements[0];
    }

    super.initState();
  }

  void _awaitFromSelectScreen(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SelectionList(
            elements,
            selectedItem,
            widget.hintText ?? 'Search country',
          ),
        ));

    setState(() {
      selectedItem = result ?? selectedItem;
      widget.onChanged(result ?? selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FuturisticCountrySelect(
        onTap: () => _awaitFromSelectScreen(context),
        selectedFlag: selectedItem!.flagUri!,
        selectedCountry: selectedItem!.toCountryStringOnly());
  }
}
