import 'package:flutter/material.dart';

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

  const DropdownWithCheckboxes({
    Key? key,
    required this.sections,
  }) : super(key: key);

  @override
  _DropdownWithCheckboxesState createState() => _DropdownWithCheckboxesState();
}

class _DropdownWithCheckboxesState extends State<DropdownWithCheckboxes> {
  Map<String, Map<String, bool>> _selectedItems = {};
  String? _expandedSection;

  @override
  void initState() {
    super.initState();
    // Initialize the selection maps for each section
    for (var section in widget.sections) {
      _selectedItems[section.title] = {
        for (var item in section.items) item: false,
      };
    }
  }

  void _onItemCheckChanged(String section, String item, bool? value) {
    setState(() {
      _selectedItems[section]?[item] = value ?? false;
    });
  }

  void _toggleSection(String section) {
    setState(() {
      if (_expandedSection == section) {
        _expandedSection = null;
      } else {
        _expandedSection = section;
      }
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
              _buildDropdownItems(
                section.title,
                section.items,
                _selectedItems[section.title]!,
              ),
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
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Galano', 
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

  Widget _buildDropdownItems(
      String sectionTitle, List<String> items, Map<String, bool> selectedItems) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffCFCFCF)), 
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((String item) {
          return _buildCustomCheckbox(sectionTitle, item, selectedItems[item]!);
        }).toList(),
      ),
    );
  }

  Widget _buildCustomCheckbox(String section, String item, bool isSelected) {
    return Row(
      children: [
        Checkbox(
          value: isSelected,
          activeColor: Color(0xff0038FF),
          onChanged: (bool? value) => _onItemCheckChanged(section, item, value),
        ),
        Text(
          item,
          style: TextStyle(
            fontFamily: 'Galano',
            fontSize: 14,
            fontWeight: FontWeight.w500 
          ),
        ),
      ],
    );
  }
}
