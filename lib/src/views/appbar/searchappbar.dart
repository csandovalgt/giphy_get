import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:giphy_get/src/client/models/type.dart';
import 'package:giphy_get/src/l10n/l10n.dart';
import 'package:giphy_get/src/providers/app_bar_provider.dart';
import 'package:giphy_get/src/providers/sheet_provider.dart';
import 'package:giphy_get/src/providers/tab_provider.dart';
import 'package:provider/provider.dart';

class SearchAppBar extends StatefulWidget {
  Color searchIconColor;
  Color cleanTextIconColor;
  // Scroll Controller
  final ScrollController scrollController;

  SearchAppBar({
    Key? key,
    required this.scrollController,
    required this.searchIconColor,
    required this.cleanTextIconColor,
  }) : super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  // Tab Provider
  late TabProvider _tabProvider;

  // AppBar Provider
  late AppBarProvider _appBarProvider;

  // Sheet Provider
  late SheetProvider _sheetProvider;

  // Input controller
  late TextEditingController _textEditingController;

  // Input Focus
  final FocusNode _focus = new FocusNode();

  @override
  void initState() {
    // Focus
    _focus.addListener(_focusListener);

    _textEditingController = new TextEditingController(
        text: Provider.of<AppBarProvider>(context, listen: false).queryText);

    _textEditingController.addListener(() {
      if (_appBarProvider.queryText != _textEditingController.text) {
        _appBarProvider.queryText = _textEditingController.text;
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    // Providers
    _tabProvider = Provider.of<TabProvider>(context);

    _sheetProvider = Provider.of<SheetProvider>(context);

    // AppBar Provider
    _appBarProvider = Provider.of<AppBarProvider>(context);

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8, bottom: 10),
      child: _searchWidget(),
    );
  }

  Widget _searchWidget() {
    final l = GiphyGetUILocalizations.labelsOf(context);
    return Column(
      children: [
        _tabProvider.tabType == GiphyType.emoji
            // ? Container(height: 40.0, child: _giphyLogo())
            ? Container()
            : SizedBox(
                height: 40,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      autofocus: _sheetProvider.initialExtent ==
                          SheetProvider.maxExtent,
                      focusNode: _focus,
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon: _searchIcon(),
                        hintText: l.searchInputLabel,
                        suffixIcon: IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: widget.cleanTextIconColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _textEditingController.clear();
                              });
                            }),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      autocorrect: false,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _searchIcon() {
    return Icon(
      Icons.search,
      color: widget.searchIconColor,
    );
  }

  void _focusListener() {
    // Set to max extent height if Textfield has focus
    if (_focus.hasFocus &&
        _sheetProvider.initialExtent == SheetProvider.minExtent) {
      _sheetProvider.initialExtent = SheetProvider.maxExtent;
    }
    print("Focus : ${_focus.hasFocus}");
  }
}
