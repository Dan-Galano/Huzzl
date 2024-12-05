import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DropdownSection {
  final String title;
  final List<String> items;

  DropdownSection({
    required this.title,
    required this.items,
  });
}

class DropdownWithCheckboxes extends StatefulWidget {
  final List<DropdownSection> sections;
  final int maxSelections; // Maximum items that can be selected
  final List<String> preSelectedItems; // Pre-selected items
  final Function(List<String>) onSelectionChanged; // Callback for changes

  const DropdownWithCheckboxes({
    Key? key,
    required this.sections,
    this.maxSelections = 3, // Default to 3
    this.preSelectedItems = const [],
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _DropdownWithCheckboxesState createState() => _DropdownWithCheckboxesState();
}

class _DropdownWithCheckboxesState extends State<DropdownWithCheckboxes> {
  late List<String> _selectedItems; // Tracks current selections
  String? _expandedSection;

  @override
  void initState() {
    super.initState();
    // Initialize selected items with pre-selected values
    _selectedItems = List<String>.from(widget.preSelectedItems);
  }

  void _onItemCheckChanged(String item, bool? value) {
    setState(() {
      if (value == true) {
        if (_selectedItems.length < widget.maxSelections) {
          _selectedItems.add(item);
        } else {
          EasyLoading.instance
            ..displayDuration = const Duration(milliseconds: 1500)
            ..indicatorType = EasyLoadingIndicatorType.fadingCircle
            ..loadingStyle = EasyLoadingStyle.custom
            ..backgroundColor = const Color(0xFfd74a4a)
            ..textColor = Colors.white
            ..fontSize = 16.0
            ..indicatorColor = Colors.white
            ..maskColor = Colors.black.withOpacity(0.5)
            ..userInteractions = false
            ..dismissOnTap = true;
          EasyLoading.showToast(
            "⚠︎ You can select up to ${widget.maxSelections} classifications only.",
            dismissOnTap: true,
            toastPosition: EasyLoadingToastPosition.top,
            duration: Duration(seconds: 3),
          );
        }
      } else {
        _selectedItems.remove(item);
      }
    });
    widget.onSelectionChanged(_selectedItems); // Notify parent
  }

  void _toggleSection(String section) {
    setState(() {
      _expandedSection = (_expandedSection == section) ? null : section;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.sections.map((DropdownSection section) {
        return Column(
          children: [
            _buildSectionTitle(section.title),
            if (_expandedSection == section.title)
              _buildDropdownItems(section.items),
            SizedBox(height: 16.0),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return GestureDetector(
      onTap: () => _toggleSection(title),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              Spacer(),
              Image.asset(
                _expandedSection == title
                    ? 'assets/images/dropdown_up.png'
                    : 'assets/images/dropdown.png',
                width: 20,
                height: 20,
              ),
            ],
          ),
          Container(
            height: 1,
            color: Color(0xffCFCFCF),
            margin: EdgeInsets.only(top: 10.0),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItems(List<String> items) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffCFCFCF)),
        ),
      ),
      child: SingleChildScrollView(
        // Make dropdown items scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: items.map((String item) {
            return _buildCustomCheckbox(item);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCustomCheckbox(String item) {
    final isSelected = _selectedItems.contains(item);
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          activeColor: Color(0xff0038FF),
          onChanged: (bool? value) => _onItemCheckChanged(item, value),
        ),
        Flexible(
          // Allow text to wrap if too long
          child: Text(
            item,
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Galano',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow
                  .ellipsis, // Optionally use ellipsis for long text
            ),
          ),
        ),
      ],
    );
  }
}
