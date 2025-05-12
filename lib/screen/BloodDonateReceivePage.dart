import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'
    show FirebaseDatabase, ServerValue;
import 'package:blood_bond/widgets/Navbar.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BloodDonateReceivePage extends StatefulWidget {
  @override
  _BloodDonateReceivePageState createState() => _BloodDonateReceivePageState();
}

class _BloodDonateReceivePageState extends State<BloodDonateReceivePage> {
  // Controllers for Donate Blood form
  final _donateNameController = TextEditingController();
  final _donateLocationController = TextEditingController();
  final _donateContactController = TextEditingController();
  final _donateDateController = TextEditingController();
  final _donateMedicalConditionsController = TextEditingController();
  String? _donateBloodGroup;
  String? _donateType;
  String? _donateFrequency;
  String? _donateEligibility;
  bool _donateNotify = false;

  // Controllers for Receive Blood form
  final _receiveNameController = TextEditingController();
  final _receiveLocationController = TextEditingController();
  final _receiveUrgencyController = TextEditingController();
  final _receiveDateController = TextEditingController();
  final _receiveMedicalHistoryController = TextEditingController();
  final _receiveHospitalController = TextEditingController();
  String? _receiveBloodGroup;
  String? _receiveReason;
  String? _receiveDelivery;
  String? _receiveQuantity;
  bool _receiveUrgentNotify = false;

  // Controller for Blood Group Search
  String? _searchBloodGroup;

  // Controller for Area-wise Donor Search
  final _areaSearchController = TextEditingController();

  final _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userPhone;
  bool _isLoading = false;
  List<Map<dynamic, dynamic>> _donorResults = [];
  List<Map<dynamic, dynamic>> _receiverResults = [];
  List<Map<dynamic, dynamic>> _areaDonorResults = [];

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        _userPhone = user?.phoneNumber;
      });
    });
  }

  @override
  void dispose() {
    _donateNameController.dispose();
    _donateLocationController.dispose();
    _donateContactController.dispose();
    _donateDateController.dispose();
    _donateMedicalConditionsController.dispose();
    _receiveNameController.dispose();
    _receiveLocationController.dispose();
    _receiveUrgencyController.dispose();
    _receiveDateController.dispose();
    _receiveMedicalHistoryController.dispose();
    _receiveHospitalController.dispose();
    _areaSearchController.dispose();
    super.dispose();
  }

  Future<void> _submitDonateBlood() async {
    if (_userPhone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to continue')),
      );
      return;
    }
    if (_validateDonateForm()) {
      setState(() => _isLoading = true);
      try {
        final safePhone = getSafePath(_userPhone);
        final donationData = {
          'name': _donateNameController.text.trim(),
          'bloodGroup': _donateBloodGroup,
          'location': _donateLocationController.text.trim(),
          'contactInfo': _donateContactController.text.trim(),
          'dateAvailable': _donateDateController.text,
          'donationType': _donateType,
          'donationFrequency': _donateFrequency,
          'medicalConditions': _donateMedicalConditionsController.text.trim(),
          'eligibilityCriteria': _donateEligibility,
          'notifyCampaigns': _donateNotify,
          'timestamp': DateTime.now().toIso8601String(),
        };

        final donationHistoryUpdate = {
          'lastDonationDate': DateTime.now().toIso8601String(),
          'totalDonations': ServerValue.increment(1),
          'eligibleForDonation': true,
        };

        // Store donation under users and donors
        await _database
            .child('users/$safePhone/bloodDonationHistory/donations')
            .push()
            .set(donationData);
        await _database
            .child('users/$safePhone/bloodDonationHistory')
            .update(donationHistoryUpdate);

        // Store donation under donors with multiple entries
        await _database
            .child('donors/$safePhone/donations')
            .push()
            .set(donationData);
        await _database.child('donors/$safePhone/summary').update({
          'name': _donateNameController.text.trim(),
          'bloodGroup': _donateBloodGroup,
          'location': _donateLocationController.text.trim(),
          'contactInfo': _donateContactController.text.trim(),
          'lastDonationDate': DateTime.now().toIso8601String(),
          'totalDonations': ServerValue.increment(1),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Donation request submitted successfully')),
        );
        _clearDonateForm();
      } catch (e) {
        print('Error submitting donation: $e');
        String errorMessage = 'Failed to submit donation';
        if (e.toString().contains('PERMISSION_DENIED')) {
          errorMessage = 'Permission denied. Check database rules.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _submitReceiveBlood() async {
    if (_userPhone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to continue')),
      );
      return;
    }
    if (_validateReceiveForm()) {
      setState(() => _isLoading = true);
      try {
        final safePhone = getSafePath(_userPhone);
        final receiveData = {
          'name': _receiveNameController.text.trim(),
          'requiredBloodGroup': _receiveBloodGroup,
          'location': _receiveLocationController.text.trim(),
          'hospital': _receiveHospitalController.text.trim(),
          'urgencyLevel': _receiveUrgencyController.text.trim(),
          'preferredDate': _receiveDateController.text,
          'reason': _receiveReason,
          'deliveryOption': _receiveDelivery,
          'medicalHistory': _receiveMedicalHistoryController.text.trim(),
          'requiredQuantity': _receiveQuantity,
          'urgentNotification': _receiveUrgentNotify,
          'timestamp': DateTime.now().toIso8601String(),
        };

        // Store request under users and bloodReceiveRequests
        await _database
            .child('users/$safePhone/bloodReceiveRequests')
            .push()
            .set(receiveData);
        await _database
            .child('bloodReceiveRequests/$safePhone/requests')
            .push()
            .set(receiveData);
        await _database
            .child('bloodReceiveRequests/$safePhone/summary')
            .update({
          'name': _receiveNameController.text.trim(),
          'requiredBloodGroup': _receiveBloodGroup,
          'location': _receiveLocationController.text.trim(),
          'hospital': _receiveHospitalController.text.trim(),
          'lastRequestDate': DateTime.now().toIso8601String(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Blood request submitted successfully')),
        );
        _clearReceiveForm();
      } catch (e) {
        print('Error submitting request: $e');
        String errorMessage = 'Failed to submit request';
        if (e.toString().contains('PERMISSION_DENIED')) {
          errorMessage = 'Permission denied. Check database rules.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _searchBloodAvailability() async {
    if (_userPhone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to continue')),
      );
      return;
    }
    if (_validateSearchForm()) {
      setState(() {
        _isLoading = true;
        _donorResults = [];
        _receiverResults = [];
      });
      try {
        final safePhone = getSafePath(_userPhone);
        final searchQuery = {
          'bloodGroup': _searchBloodGroup,
          'timestamp': DateTime.now().toIso8601String(),
        };

        await _database
            .child('users/$safePhone/bloodSearchHistory')
            .push()
            .set(searchQuery);

        // Fetch donors from the 'donors' node
        final donorSnapshot = await _database.child('donors').get();
        final List<Map<dynamic, dynamic>> donorResults = [];

        // Process the single donor entry from 'donors'
        if (donorSnapshot.exists) {
          final donorData = donorSnapshot.value as Map<dynamic, dynamic>;
          final donorSummary =
              donorData['summary'] as Map<dynamic, dynamic>? ?? {};
          final donations =
              donorData['donations'] as Map<dynamic, dynamic>? ?? {};

          bool matches = true;
          if (_searchBloodGroup != null) {
            if (donorSummary['bloodGroup'] != _searchBloodGroup) {
              matches = false;
            }
          }

          if (matches) {
            donorSummary['donationCount'] = donations.length;
            donorResults.add(donorSummary);
          }
        }

        // Fetch additional donations from 'users/bloodDonationHistory/donations'
        final userDonationSnapshot =
            await _database.child('users/bloodDonationHistory/donations').get();
        if (userDonationSnapshot.exists) {
          final allDonations =
              userDonationSnapshot.value as Map<dynamic, dynamic>;
          allDonations.forEach((donationId, donationData) {
            bool matches = true;
            if (_searchBloodGroup != null) {
              if (donationData['bloodGroup'] != _searchBloodGroup) {
                matches = false;
              }
            }

            if (matches &&
                !donorResults.any((donor) =>
                    donor['name'] == donationData['name'] &&
                    donor['location'] == donationData['location'] &&
                    donor['bloodGroup'] == donationData['bloodGroup'])) {
              final donorSummary = Map<dynamic, dynamic>.from(donationData);
              donorSummary['donationCount'] =
                  1; // Each entry represents one donation
              donorSummary['lastDonationDate'] = donationData['timestamp'];
              donorResults.add(donorSummary);
            }
          });
        }

        // Sort donor results by last donation date
        donorResults.sort(
            (a, b) => b['lastDonationDate'].compareTo(a['lastDonationDate']));
        setState(() {
          _donorResults = donorResults;
        });

        // Fetch receivers from the 'bloodReceiveRequests' node
        final receiverSnapshot =
            await _database.child('bloodReceiveRequests').get();
        final List<Map<dynamic, dynamic>> receiverResults = [];

        // Process the single receiver entry from 'bloodReceiveRequests'
        if (receiverSnapshot.exists) {
          final receiverData = receiverSnapshot.value as Map<dynamic, dynamic>;
          final receiverSummary =
              receiverData['summary'] as Map<dynamic, dynamic>? ?? {};
          final requests =
              receiverData['requests'] as Map<dynamic, dynamic>? ?? {};

          bool matches = true;
          if (_searchBloodGroup != null) {
            if (receiverSummary['requiredBloodGroup'] != _searchBloodGroup) {
              matches = false;
            }
          }

          if (matches) {
            receiverSummary['requestCount'] = requests.length;
            receiverResults.add(receiverSummary);
          }
        }

        // Fetch additional requests from 'users/bloodReceiveRequests'
        final userRequestSnapshot =
            await _database.child('users/bloodReceiveRequests').get();
        if (userRequestSnapshot.exists) {
          final allRequests =
              userRequestSnapshot.value as Map<dynamic, dynamic>;
          allRequests.forEach((requestId, requestData) {
            bool matches = true;
            if (_searchBloodGroup != null) {
              if (requestData['requiredBloodGroup'] != _searchBloodGroup) {
                matches = false;
              }
            }

            if (matches &&
                !receiverResults.any((receiver) =>
                    receiver['name'] == requestData['name'] &&
                    receiver['location'] == requestData['location'] &&
                    receiver['requiredBloodGroup'] ==
                        requestData['requiredBloodGroup'])) {
              final receiverSummary = Map<dynamic, dynamic>.from(requestData);
              receiverSummary['requestCount'] =
                  1; // Each entry represents one request
              receiverSummary['lastRequestDate'] = requestData['timestamp'];
              receiverResults.add(receiverSummary);
            }
          });
        }

        // Sort receiver results by last request date
        receiverResults.sort(
            (a, b) => b['lastRequestDate'].compareTo(a['lastRequestDate']));
        setState(() {
          _receiverResults = receiverResults;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Search completed. Found ${_donorResults.length} donors and ${_receiverResults.length} receivers.',
            ),
          ),
        );
      } catch (e) {
        String errorMessage = 'Failed to search';
        if (e.toString().contains('PERMISSION_DENIED')) {
          errorMessage = 'Permission denied. Check database rules.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _searchDonorsByArea() async {
    if (_userPhone == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please sign in to continue')),
      );
      return;
    }
    final area = _areaSearchController.text.trim();
    if (area.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an area to search')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
      _donorResults = [];
    });
    try {
      final safePhone = getSafePath(_userPhone);
      final searchQuery = {
        'area': area,
        'timestamp': DateTime.now().toIso8601String(),
      };

      await _database
          .child('users/$safePhone/bloodSearchHistory')
          .push()
          .set(searchQuery);

      // Fetch donors from the 'donors' node
      final donorSnapshot = await _database.child('donors').get();
      final List<Map<dynamic, dynamic>> donorResults = [];

      // Process the single donor entry from 'donors'
      if (donorSnapshot.exists) {
        final donorData = donorSnapshot.value as Map<dynamic, dynamic>;
        final donorSummary =
            donorData['summary'] as Map<dynamic, dynamic>? ?? {};
        final donations =
            donorData['donations'] as Map<dynamic, dynamic>? ?? {};

        if (donorSummary['location'].toString().toLowerCase() ==
            area.toLowerCase()) {
          donorSummary['donationCount'] = donations.length;
          donorResults.add(donorSummary);
        }
      }

      // Fetch additional donations from 'users/bloodDonationHistory/donations'
      final userDonationSnapshot =
          await _database.child('users/bloodDonationHistory/donations').get();
      if (userDonationSnapshot.exists) {
        final allDonations =
            userDonationSnapshot.value as Map<dynamic, dynamic>;
        allDonations.forEach((donationId, donationData) {
          if (donationData['location'].toString().toLowerCase() ==
                  area.toLowerCase() &&
              !donorResults.any((donor) =>
                  donor['name'] == donationData['name'] &&
                  donor['location'] == donationData['location'])) {
            final donorSummary = Map<dynamic, dynamic>.from(donationData);
            donorSummary['donationCount'] = 1;
            donorSummary['lastDonationDate'] = donationData['timestamp'];
            donorResults.add(donorSummary);
          }
        });
      }

      donorResults.sort(
          (a, b) => b['lastDonationDate'].compareTo(a['lastDonationDate']));
      setState(() {
        _donorResults = donorResults;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Found ${_donorResults.length} donors in $area.'),
        ),
      );
    } catch (e) {
      String errorMessage = 'Failed to search';
      if (e.toString().contains('PERMISSION_DENIED')) {
        errorMessage = 'Permission denied. Check database rules.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your connection.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  bool _validateDonateForm() {
    if (_donateNameController.text.trim().isEmpty ||
        _donateBloodGroup == null ||
        _donateLocationController.text.trim().isEmpty ||
        _donateContactController.text.trim().isEmpty ||
        _donateDateController.text.isEmpty ||
        _donateType == null ||
        _donateFrequency == null ||
        _donateEligibility == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
    }
    return true;
  }

  bool _validateReceiveForm() {
    if (_receiveNameController.text.trim().isEmpty ||
        _receiveBloodGroup == null ||
        _receiveLocationController.text.trim().isEmpty ||
        _receiveHospitalController.text.trim().isEmpty ||
        _receiveUrgencyController.text.trim().isEmpty ||
        _receiveDateController.text.isEmpty ||
        _receiveReason == null ||
        _receiveDelivery == null ||
        _receiveQuantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
      return false;
    }
    return true;
  }

  bool _validateSearchForm() {
    if (_searchBloodGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a blood group')),
      );
      return false;
    }
    return true;
  }

  void _clearDonateForm() {
    _donateNameController.clear();
    _donateLocationController.clear();
    _donateContactController.clear();
    _donateDateController.clear();
    _donateMedicalConditionsController.clear();
    setState(() {
      _donateBloodGroup = null;
      _donateType = null;
      _donateFrequency = null;
      _donateEligibility = null;
      _donateNotify = false;
    });
  }

  void _clearReceiveForm() {
    _receiveNameController.clear();
    _receiveLocationController.clear();
    _receiveUrgencyController.clear();
    _receiveDateController.clear();
    _receiveMedicalHistoryController.clear();
    _receiveHospitalController.clear();
    setState(() {
      _receiveBloodGroup = null;
      _receiveReason = null;
      _receiveDelivery = null;
      _receiveQuantity = null;
      _receiveUrgentNotify = false;
    });
  }

  void _clearSearchForm() {
    setState(() {
      _searchBloodGroup = null;
      _donorResults = [];
      _receiverResults = [];
    });
  }

  void _clearAreaSearchForm() {
    _areaSearchController.clear();
    setState(() {
      _areaDonorResults = [];
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  String getSafePath(String? phone) {
    if (phone == null) return '';
    return phone.replaceAll(RegExp(r'[.#$/[\]]'), '_');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donate & Receive'),
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NavScreen()));
          },
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 10 : 15,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Manage Blood Donation & Requests",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 24 : 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 15 : 20),
                    // Find Donors by Area Section
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.location_on,
                                    color: Colors.white,
                                    size: isSmallScreen ? 24 : 30),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Find Donors by Area',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            'Enter City/Area',
                            Icons.location_city,
                            _areaSearchController,
                            isSmallScreen,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 15 : 20,
                                    vertical: isSmallScreen ? 10 : 12,
                                  ),
                                ),
                                onPressed:
                                    _isLoading ? null : _searchDonorsByArea,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.search,
                                        color: Colors.white,
                                        size: isSmallScreen ? 18 : 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Search Donors',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSmallScreen ? 14 : 16),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isSmallScreen ? 15 : 20,
                                    vertical: isSmallScreen ? 10 : 12,
                                  ),
                                ),
                                onPressed: _clearAreaSearchForm,
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isSmallScreen ? 14 : 16),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isSmallScreen ? 15 : 20),
                          if (_areaDonorResults.isNotEmpty) ...[
                            Text(
                              'Donors in ${_areaSearchController.text.trim()}',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: _areaDonorResults.length,
                              itemBuilder: (context, index) {
                                final donor = _areaDonorResults[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Name: ${donor['name']}',
                                            style: TextStyle(fontSize: 16)),
                                        Text(
                                            'Blood Group: ${donor['bloodGroup']}',
                                            style: TextStyle(fontSize: 14)),
                                        Text('Contact: ${donor['contactInfo']}',
                                            style: TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 15 : 20),
                    _buildDonateBloodCard(screenWidth, isSmallScreen),
                    SizedBox(height: isSmallScreen ? 15 : 20),
                    _buildReceiveBloodCard(screenWidth, isSmallScreen),
                    SizedBox(height: isSmallScreen ? 15 : 20),
                    _buildSearchBloodCard(screenWidth, isSmallScreen),
                    SizedBox(height: isSmallScreen ? 15 : 20),
                    if (_donorResults.isNotEmpty) ...[
                      Text(
                        'Blood Donors',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _donorResults.length,
                        itemBuilder: (context, index) {
                          final donor = _donorResults[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: ${donor['name']}',
                                      style: TextStyle(fontSize: 16)),
                                  Text('Blood Group: ${donor['bloodGroup']}',
                                      style: TextStyle(fontSize: 14)),
                                  Text('Contact: ${donor['contactInfo']}',
                                      style: TextStyle(fontSize: 14)),
                                  Text('Location: ${donor['location']}',
                                      style: TextStyle(fontSize: 14)),
                                  Text(
                                      'Total Donations: ${donor['donationCount']}',
                                      style: TextStyle(fontSize: 14)),
                                  Text(
                                      'Last Donation: ${donor['lastDonationDate']}',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    SizedBox(height: isSmallScreen ? 15 : 20),
                    if (_receiverResults.isNotEmpty) ...[
                      Text(
                        'Blood Receivers',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _receiverResults.length,
                        itemBuilder: (context, index) {
                          final receiver = _receiverResults[index];
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Name: ${receiver['name']}',
                                      style: TextStyle(fontSize: 16)),
                                  Text(
                                      'Blood Group: ${receiver['requiredBloodGroup']}',
                                      style: TextStyle(fontSize: 14)),
                                  Text('Contact: ${receiver['phone']}',
                                      style: TextStyle(fontSize: 14)),
                                  Text('Location: ${receiver['location']}',
                                      style: TextStyle(fontSize: 14)),
                                  Text('Hospital: ${receiver['hospital']}',
                                      style: TextStyle(fontSize: 14)),
                                  Text(
                                      'Total Requests: ${receiver['requestCount']}',
                                      style: TextStyle(fontSize: 14)),
                                  Text(
                                      'Last Request: ${receiver['lastRequestDate']}',
                                      style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            ),
        ],
      ),
    );
  }

  Widget _buildDonateBloodCard(double screenWidth, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.volunteer_activism,
                    color: Colors.white, size: isSmallScreen ? 24 : 30),
              ),
              SizedBox(width: 10),
              Text(
                'Donate Blood',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField(
              'Name', Icons.person, _donateNameController, isSmallScreen),
          _buildDropdownField(
            'Blood Group',
            ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
            Icons.bloodtype,
            (value) => setState(() => _donateBloodGroup = value),
            _donateBloodGroup,
            isSmallScreen,
          ),
          _buildTextField('Location', Icons.location_on,
              _donateLocationController, isSmallScreen),
          _buildTextField('Contact Info', Icons.phone, _donateContactController,
              isSmallScreen),
          _buildTextField(
            'Date Available',
            Icons.calendar_today,
            _donateDateController,
            isSmallScreen,
            onTap: () => _selectDate(context, _donateDateController),
            readOnly: true,
          ),
          _buildDropdownField(
            'Donation Type',
            ['Whole Blood', 'Plasma', 'Platelets'],
            Icons.bloodtype,
            (value) => setState(() => _donateType = value),
            _donateType,
            isSmallScreen,
          ),
          _buildDropdownField(
            'Donation Frequency',
            ['One-time', 'Monthly', 'Quarterly'],
            Icons.schedule,
            (value) => setState(() => _donateFrequency = value),
            _donateFrequency,
            isSmallScreen,
          ),
          _buildTextField('Medical Conditions', Icons.medical_services,
              _donateMedicalConditionsController, isSmallScreen),
          _buildDropdownField(
            'Eligibility Criteria',
            ['First-time Donor', 'Regular Donor', 'Special Approval'],
            Icons.verified_user,
            (value) => setState(() => _donateEligibility = value),
            _donateEligibility,
            isSmallScreen,
          ),
          _buildCheckbox(
            'Notify Me About Campaigns',
            _donateNotify,
            (value) => setState(() => _donateNotify = value ?? false),
            isSmallScreen,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 15 : 20,
                    vertical: isSmallScreen ? 10 : 12,
                  ),
                ),
                onPressed: _isLoading ? null : _submitDonateBlood,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.volunteer_activism,
                        color: Colors.white, size: isSmallScreen ? 18 : 20),
                    SizedBox(width: 8),
                    Text(
                      'Donate Blood',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 15 : 20,
                    vertical: isSmallScreen ? 10 : 12,
                  ),
                ),
                onPressed: _clearDonateForm,
                child: Text(
                  'Reset',
                  style: TextStyle(
                      color: Colors.white, fontSize: isSmallScreen ? 14 : 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReceiveBloodCard(double screenWidth, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.local_hospital,
                    color: Colors.white, size: isSmallScreen ? 24 : 30),
              ),
              SizedBox(width: 10),
              Text(
                'Receive Blood',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField(
              'Name', Icons.person, _receiveNameController, isSmallScreen),
          _buildDropdownField(
            'Required Blood Group',
            ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
            Icons.bloodtype,
            (value) => setState(() => _receiveBloodGroup = value),
            _receiveBloodGroup,
            isSmallScreen,
          ),
          _buildTextField('Location', Icons.location_on,
              _receiveLocationController, isSmallScreen),
          _buildTextField('Hospital Name', Icons.local_hospital,
              _receiveHospitalController, isSmallScreen),
          _buildTextField('Urgency Level', Icons.priority_high,
              _receiveUrgencyController, isSmallScreen),
          _buildTextField(
            'Preferred Date',
            Icons.calendar_today,
            _receiveDateController,
            isSmallScreen,
            onTap: () => _selectDate(context, _receiveDateController),
            readOnly: true,
          ),
          _buildDropdownField(
            'Reason for Request',
            ['Surgery', 'Emergency', 'Chronic Condition'],
            Icons.note,
            (value) => setState(() => _receiveReason = value),
            _receiveReason,
            isSmallScreen,
          ),
          _buildDropdownField(
            'Delivery Option',
            ['Pickup', 'Hospital Delivery'],
            Icons.local_shipping,
            (value) => setState(() => _receiveDelivery = value),
            _receiveDelivery,
            isSmallScreen,
          ),
          _buildTextField('Medical History', Icons.history,
              _receiveMedicalHistoryController, isSmallScreen),
          _buildDropdownField(
            'Required Quantity',
            ['1 Unit', '2 Units', '3+ Units'],
            Icons.format_list_numbered,
            (value) => setState(() => _receiveQuantity = value),
            _receiveQuantity,
            isSmallScreen,
          ),
          _buildCheckbox(
            'Urgent Notification',
            _receiveUrgentNotify,
            (value) => setState(() => _receiveUrgentNotify = value ?? false),
            isSmallScreen,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 15 : 20,
                    vertical: isSmallScreen ? 10 : 12,
                  ),
                ),
                onPressed: _isLoading ? null : _submitReceiveBlood,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.local_hospital,
                        color: Colors.white, size: isSmallScreen ? 18 : 20),
                    SizedBox(width: 8),
                    Text(
                      'Request Blood',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 15 : 20,
                    vertical: isSmallScreen ? 10 : 12,
                  ),
                ),
                onPressed: _clearReceiveForm,
                child: Text(
                  'Reset',
                  style: TextStyle(
                      color: Colors.white, fontSize: isSmallScreen ? 14 : 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBloodCard(double screenWidth, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade700,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.search,
                    color: Colors.white, size: isSmallScreen ? 24 : 30),
              ),
              SizedBox(width: 10),
              Text(
                'Search by Blood Group',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildDropdownField(
            'Blood Group',
            ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
            Icons.bloodtype,
            (value) => setState(() => _searchBloodGroup = value),
            _searchBloodGroup,
            isSmallScreen,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 15 : 20,
                    vertical: isSmallScreen ? 10 : 12,
                  ),
                ),
                onPressed: _isLoading ? null : _searchBloodAvailability,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search,
                        color: Colors.white, size: isSmallScreen ? 18 : 20),
                    SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 14 : 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 15 : 20,
                    vertical: isSmallScreen ? 10 : 12,
                  ),
                ),
                onPressed: _clearSearchForm,
                child: Text(
                  'Reset',
                  style: TextStyle(
                      color: Colors.white, fontSize: isSmallScreen ? 14 : 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon,
    TextEditingController controller,
    bool isSmallScreen, {
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: isSmallScreen ? 14 : 16),
          prefixIcon: Icon(icon,
              color: Colors.redAccent, size: isSmallScreen ? 20 : 24),
          filled: true,
          fillColor: Colors.red.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 10 : 15,
            horizontal: 10,
          ),
        ),
        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    IconData icon,
    ValueChanged<String?> onChanged,
    String? value,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: isSmallScreen ? 14 : 16),
          prefixIcon: Icon(icon,
              color: Colors.redAccent, size: isSmallScreen ? 20 : 24),
          filled: true,
          fillColor: Colors.red.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 10 : 15,
            horizontal: 10,
          ),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        style:
            TextStyle(fontSize: isSmallScreen ? 14 : 16, color: Colors.black),
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool?> onChanged,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.redAccent,
          ),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
          ),
        ],
      ),
    );
  }
}
