import 'package:flutter/material.dart';
import 'package:quick_roll/utils/admin_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DesignationScreen extends StatefulWidget {
  const DesignationScreen({super.key});

  @override
  State<DesignationScreen> createState() => _DesignationScreenState();
}

class _DesignationScreenState extends State<DesignationScreen> {
  final TextEditingController _designationController = TextEditingController();
  List<String> designations = [];
  final String _storageKey = 'designations';

  @override
  void initState() {
    super.initState();
    _loadDesignations();
  }

  Future<void> _loadDesignations() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedDesignations = prefs.getString(_storageKey);
    if (storedDesignations != null) {
      setState(() {
        designations = List<String>.from(jsonDecode(storedDesignations));
      });
    }
  }

  Future<void> _saveDesignations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(designations));
  }

  void _addDesignation() {
    final designation = _designationController.text.trim();
    if (designation.isNotEmpty && !designations.contains(designation)) {
      setState(() {
        designations.add(designation);
        _designationController.clear();
      });
      _saveDesignations();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Designation added successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a unique designation')),
      );
    }
  }

  void _deleteDesignation(String designation) {
    setState(() {
      designations.remove(designation);
    });
    _saveDesignations();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Designation deleted successfully')),
    );
  }

  @override
  void dispose() {
    _designationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.skyBlue,
        title: const Text(
          'Manage Designations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.charcoalGray,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.charcoalGray),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.white, AppColors.lightSkyBlue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                elevation: 8,
                color: AppColors.babyBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _designationController,
                          decoration: InputDecoration(
                            labelText: 'Add Designation',
                            labelStyle:
                                const TextStyle(color: AppColors.charcoalGray),
                            prefixIcon: const Icon(Icons.work,
                                color: AppColors.slateTeal),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: AppColors.slateTeal),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                  color: AppColors.slateTeal, width: 2),
                            ),
                          ),
                          style: const TextStyle(color: AppColors.charcoalGray),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _addDesignation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.slateTeal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: designations.isEmpty
                    ? const Center(
                        child: Text(
                          'No designations added yet',
                          style: TextStyle(
                            color: AppColors.charcoalGray,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: designations.length,
                        itemBuilder: (context, index) {
                          final designation = designations[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              title: Text(
                                designation,
                                style: const TextStyle(
                                  color: AppColors.charcoalGray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () =>
                                    _deleteDesignation(designation),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
