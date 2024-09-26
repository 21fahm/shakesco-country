library shakesco_country;

import 'dart:ui';

import 'package:shakesco_country/country_selection_theme.dart';
import 'package:shakesco_country/selection_list.dart';
import 'package:shakesco_country/selection/code_countries_en.dart';
import 'package:shakesco_country/selection/code_country.dart';
import 'package:shakesco_country/selection/code_countrys.dart';
import 'package:flutter/material.dart';

export 'selection/code_country.dart';

export 'country_selection_theme.dart';

class CountryListPick extends StatefulWidget {
  CountryListPick({
    required this.onChanged,
    this.initialSelection,
    this.pickerBuilder,
  });

  final String? initialSelection;
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
          ),
        ));

    setState(() {
      selectedItem = result ?? selectedItem;
      widget.onChanged(result ?? selectedItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _awaitFromSelectScreen(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0x66C084E9),
              Color(0x66D16EBE),
              Color(0x66FFD2B2),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.13)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              child: widget.pickerBuilder != null
                  ? widget.pickerBuilder!(context, selectedItem)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Image.asset(
                              selectedItem!.flagUri!,
                              package: 'country_list_pick',
                              width: 32.0,
                            ),
                            SizedBox(width: 12),
                            Text(
                              selectedItem!.toCountryStringOnly(),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_drop_down, color: Colors.black54),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
