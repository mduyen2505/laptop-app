import 'package:HDTech/constants.dart'; // Import constants.dart
import 'package:HDTech/models/computer_model.dart';
import 'package:flutter/material.dart';

class FilterDrawer extends StatefulWidget {
  final Function(Map<String, dynamic>) onFilterChanged;
  final List<Computer> computers;

  const FilterDrawer(
      {super.key, required this.onFilterChanged, required this.computers});

  @override
  FilterDrawerState createState() => FilterDrawerState();
}

class FilterDrawerState extends State<FilterDrawer> {
  final Map<String, dynamic> _selectedFilters = {};
  late List<String> _companies;
  late List<String> _rams;
  late List<String> _cpus;
  late List<String> _gpus;
  late List<String> _memories;

  @override
  void initState() {
    super.initState();

    // Extract unique values from the list of computers for each filter
    _companies =
        _getUniqueValues(widget.computers, (computer) => computer.company);
    _rams = _getUniqueValues(widget.computers, (computer) => computer.ram);
    _cpus = _getUniqueValues(widget.computers, (computer) => computer.cpu);
    _gpus = _getUniqueValues(widget.computers, (computer) => computer.gpu);
    _memories =
        _getUniqueValues(widget.computers, (computer) => computer.memory);
  }

  List<String> _getUniqueValues(
      List<Computer> computers, String Function(Computer) extractValue) {
    return computers.map(extractValue).toSet().toList(); // Get unique values
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // Set drawer background color to white
      child: SingleChildScrollView(
        // Enable scrolling
        child: Padding(
          padding: const EdgeInsets.only(top: 36.0), // Push content down
          child: Column(
            children: [
              // Filter buttons for each attribute
              _buildFilterButton('Company', _companies, 'company'),
              _buildFilterButton('RAM', _rams, 'ram'),
              _buildFilterButton('CPU', _cpus, 'cpu'),
              _buildFilterButton('GPU', _gpus, 'gpu'),
              _buildFilterButton('Memory', _memories, 'memory'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(
      String title, List<String> options, String filterKey) {
    return ExpansionTile(
      title: Text(title),
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _selectedFilters[filterKey],
          onChanged: (String? value) {
            setState(() {
              _selectedFilters[filterKey] = value;
              _sendUpdatedFilters();
            });
          },
          activeColor: kPrimaryColor, // Set radio button color to primary color
        );
      }).toList(),
    );
  }

  void _sendUpdatedFilters() {
    // Clean filters to remove null or empty values
    final cleanedFilters = Map<String, dynamic>.from(_selectedFilters);
    cleanedFilters.removeWhere(
        (key, value) => value == null || (value is List && value.isEmpty));

    // Send updated filters
    widget.onFilterChanged(cleanedFilters);
  }
}
