import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/textfield_decorations.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/views/active_branches_view.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/views/archive_branches_view.dart';
import 'package:huzzl_web/views/recruiters/branches_tab/widgets/navbar_widget.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  _BranchesScreenState createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen>
    with SingleTickerProviderStateMixin {
  final _formkey = GlobalKey<FormState>();

  late TabController _tabController;

  final TextEditingController _branchNameController = TextEditingController();

  String? selectedRegion;
  String? selectedProvince;
  String? selectedCity;
  String? selectedBarangay;
  final otherLocationInformation = TextEditingController();

  List regions = [];
  List provinces = [];
  List cities = [];
  List barangays = [];

  @override
  void initState() {
    super.initState();
    fetchRegions();
    _tabController = TabController(length: 2, vsync: this); // Two tabs
  }

  Future<void> fetchRegions() async {
    final response =
        await http.get(Uri.parse('https://psgc.gitlab.io/api/regions/'));
    if (response.statusCode == 200) {
      setState(() {
        regions = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load regions');
    }
  }

  // Fetch provinces from the API
  Future<void> fetchProvinces(String regionCode) async {
    final response = await http.get(
        Uri.parse('https://psgc.gitlab.io/api/regions/$regionCode/provinces/'));
    if (response.statusCode == 200) {
      setState(() {
        provinces = jsonDecode(response.body);
        selectedProvince = null; // Reset selected province
        cities = [];
        selectedCity = null; // Reset selected city
        barangays = []; // Clear barangays
        selectedBarangay = null; // Reset selected barangay
      });
    } else {
      throw Exception('Failed to load provinces');
    }
  }

  // Fetch cities by province code
  Future<void> fetchCities(String provinceCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/provinces/$provinceCode/cities-municipalities/'));
    if (response.statusCode == 200) {
      setState(() {
        cities = jsonDecode(response.body);
        selectedCity = null; // Reset selected city
        selectedBarangay = null; // Reset selected barangay
        barangays = []; // Clear barangay list
      });
    } else {
      throw Exception('Failed to load cities');
    }
  }

  // Fetch barangays by city/municipality code
  Future<void> fetchBarangays(String cityCode) async {
    final response = await http.get(Uri.parse(
        'https://psgc.gitlab.io/api/cities-municipalities/$cityCode/barangays/'));
    if (response.statusCode == 200) {
      setState(() {
        barangays = jsonDecode(response.body);
        selectedBarangay = null; // Reset selected barangay
      });
    } else {
      throw Exception('Failed to load barangays');
    }
  }

  void submitNewBranch() async {
    if (_formkey.currentState!.validate()) {
      print("console: created a new company branch.");
      setState(() {
        regions = [];
        selectedRegion = null;
        provinces = [];
        selectedProvince = null; // Reset selected province
        cities = [];
        selectedCity = null; // Reset selected city
        barangays = []; // Clear barangays
        selectedBarangay = null;
        _branchNameController.text = '';
      });
      Navigator.of(context).pop();
    }
  }

  void cancelAddNewBranch(BuildContext context) {
    setState(() {
      regions = [];
      selectedRegion = null;
      provinces = [];
      selectedProvince = null; // Reset selected province
      cities = [];
      selectedCity = null; // Reset selected city
      barangays = []; // Clear barangays
      selectedBarangay = null;
      _branchNameController.text = '';
    });
    fetchRegions();
    Navigator.of(context).pop();
  }

  void addNewBranch(BuildContext context) async {
    await fetchRegions(); // Make sure regions are fetched before showing the dialog

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            // Use this setState to update dialog UI
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              content: Form(
                key: _formkey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Add new branch",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: const Row(
                          children: [
                            Text(
                              "Branch name",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      //Branch name input field
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: TextFormField(
                          controller: _branchNameController,
                          decoration: inputTextFieldDecoration(1),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Branch name is required.";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      //Branch location
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: const Row(
                          children: [
                            Text(
                              "Location",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Region Dropdown
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: DropdownButtonFormField<String>(
                          decoration:
                              customHintTextInputDecoration('Select Region'),
                          value: selectedRegion,
                          items:
                              regions.map<DropdownMenuItem<String>>((region) {
                            return DropdownMenuItem<String>(
                              value: region['name'],
                              child: Text(region['name']),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setStateDialog(() {
                              selectedRegion = value;
                              selectedProvince = null;
                              selectedCity = null;
                              selectedBarangay = null;
                              provinces = [];
                              cities = [];
                              barangays = [];
                            });
                            if (value != null) {
                              final selectedRegionCode = regions.firstWhere(
                                (region) => region['name'] == value,
                                orElse: () => null,
                              )['code'];

                              if (selectedRegionCode != null) {
                                fetchProvinces(selectedRegionCode).then((_) {
                                  setStateDialog(
                                      () {}); // Trigger rebuild after fetching provinces
                                });
                              }
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Region is required.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Province Dropdown
                      if (selectedRegion != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: DropdownButtonFormField<String>(
                            decoration: customHintTextInputDecoration(
                                'Select Province'),
                            value: selectedProvince,
                            items: provinces
                                .map<DropdownMenuItem<String>>((province) {
                              return DropdownMenuItem<String>(
                                value: province['name'],
                                child: Text(province['name']),
                              );
                            }).toList(),
                            onChanged: selectedRegion != null
                                ? (value) {
                                    setStateDialog(() {
                                      selectedProvince = value;
                                      selectedCity = null;
                                      selectedBarangay = null;
                                      cities = [];
                                      barangays = [];
                                    });
                                    if (value != null) {
                                      final selectedProvinceCode =
                                          provinces.firstWhere(
                                        (province) => province['name'] == value,
                                        orElse: () => null,
                                      )['code'];

                                      if (selectedProvinceCode != null) {
                                        fetchCities(selectedProvinceCode)
                                            .then((_) {
                                          setStateDialog(
                                              () {}); // Trigger rebuild after fetching cities
                                        });
                                      }
                                    }
                                  }
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Province is required.';
                              }
                              return null;
                            },
                          ),
                        ),
                      const SizedBox(height: 10),

                      // City Dropdown
                      if (selectedProvince != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: DropdownButtonFormField<String>(
                            decoration: customHintTextInputDecoration(
                                'Select City/Municipality'),
                            value: selectedCity,
                            items: cities.map<DropdownMenuItem<String>>((city) {
                              return DropdownMenuItem<String>(
                                value: city['name'],
                                child: Text(city['name']),
                              );
                            }).toList(),
                            onChanged: selectedProvince != null
                                ? (value) {
                                    setStateDialog(() {
                                      selectedCity = value;
                                      selectedBarangay = null;
                                      barangays = [];
                                    });
                                    if (value != null) {
                                      final selectedCitiesCode =
                                          cities.firstWhere(
                                        (city) => city['name'] == value,
                                        orElse: () => null,
                                      )['code'];
                                      if (selectedCitiesCode != null) {
                                        fetchBarangays(selectedCitiesCode)
                                            .then((_) {
                                          setStateDialog(
                                              () {}); // Trigger rebuild after fetching barangays
                                        });
                                      }
                                    }
                                  }
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'City is required.';
                              }
                              return null;
                            },
                          ),
                        ),
                      const SizedBox(height: 10),

                      // Barangay Dropdown
                      if (selectedCity != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: DropdownButtonFormField<String>(
                            decoration: customHintTextInputDecoration(
                                'Select Barangay'),
                            value: selectedBarangay,
                            items: barangays
                                .map<DropdownMenuItem<String>>((barangay) {
                              return DropdownMenuItem<String>(
                                value: barangay['name'],
                                child: Text(barangay['name']),
                              );
                            }).toList(),
                            onChanged: selectedCity != null
                                ? (value) {
                                    setStateDialog(() {
                                      selectedBarangay = value;
                                    });
                                  }
                                : null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Barangay is required.';
                              }
                              return null;
                            },
                          ),
                        ),
                      const SizedBox(height: 10),

                      // Other location information field
                      if (selectedBarangay != null)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: TextFormField(
                            controller: otherLocationInformation,
                            decoration: inputTextFieldDecoration(3),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "This field is required.";
                              }
                            },
                          ),
                        ),

                      const SizedBox(height: 10),
                      //Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: submitNewBranch,
                            style: const ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xffD6E4FF),
                              ),
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Color(0xff3B7DFF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          ElevatedButton(
                            onPressed: () => cancelAddNewBranch(context),
                            style: const ButtonStyle(
                              elevation: WidgetStatePropertyAll(0),
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xffe8e8e8),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xff4D4D4D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 20),
                    const Text(
                      'Branches',
                      style: TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 32,
                        color: Color(0xff373030),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextField(
                        decoration: searchTextFieldDecoration('Search'),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => addNewBranch(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0038FF),
                        padding: EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/add-icon.png",
                            width: 20,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'Add new branch',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 30),
                  ],
                ),
                // Add Tabs for Active and Archive
                TabBar(
                  
      tabAlignment: TabAlignment.start,
      isScrollable: true,
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.orange,
                  labelStyle: TextStyle(
                    fontSize: 18, // Font size of the selected tab
                    fontWeight:
                        FontWeight.bold, // Font weight of the selected tab
                    fontFamily: 'Galano', // Use your custom font
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16, // Font size of the unselected tabs
                    fontWeight:
                        FontWeight.normal, // Font weight of the unselected tabs
                    fontFamily: 'Galano', // Use your custom font
                  ),
                  tabs: [
                    Tab(text: '4 Active'),
                    Tab(text: '0 Archived'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Active Tab Content
                      ActiveBranchesView(),
                      // Archive Tab Content
                      ArchiveBranchesView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
