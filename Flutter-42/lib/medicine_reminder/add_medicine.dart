import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:golden_care_2/ui/assets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../Ecg_model/ECG_screen.dart';
import '../home_screen/home_screen.dart';
import '../profile_screen/profile_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';



class AddMedicineScreen extends StatefulWidget {
  static const String routName = 'add medicine';

  final bool isEdit;
  final int? existingId;
  final String? existingImageUrl;

  final String? existingName;
  final String? existingDosage;
  final TimeOfDay? existingTime;
  final File? existingImage;
  final int? existingHours;

  const AddMedicineScreen({
    Key? key,
    this.isEdit = false,
    this.existingId,
    this.existingImageUrl,

    this.existingName,
    this.existingDosage,
    this.existingTime,
    this.existingImage,
    this.existingHours
  }) : super(key: key);

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  int selectedIndex = 1;
  File? _selectedImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();

  int _hours = 5;
  TimeOfDay? _selectedTime;

  String? _timeError;
  String? _imageError;
  String? _existingImageUrl;  // إضافة متغير لتخزين رابط الصورة القديمة

  @override
  @override
  void initState() {
    super.initState();
    _loadImageIfEditing();
    _loadImageFromPrefsIfEditing();

    print('Is Edit: ${widget.isEdit}');

    if (widget.isEdit) {
      _medicineNameController.text = widget.existingName ?? '';
      _dosageController.text = widget.existingDosage ?? '';
      _selectedTime = widget.existingTime;
      _selectedImage = widget.existingImage;
      _hours = widget.existingHours ?? 5;

    }
  }

  Future<void> _loadImageFromPrefsIfEditing() async {
    final prefs = await SharedPreferences.getInstance();
    final base64Image = prefs.getString('medicineImageBase64');

    if (widget.isEdit && base64Image != null && _selectedImage == null) {
      final bytes = base64Decode(base64Image);
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/stored_medicine_image.jpg';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      setState(() {
        _selectedImage = file;
      });
    }
  }


  Future<void> _loadImageIfEditing() async {
    if (widget.isEdit && _selectedImage == null && widget.existingImageUrl != null) {
      File? downloadedImage = await downloadImageFile(widget.existingImageUrl!);
      if (downloadedImage != null) {
        setState(() {
          _selectedImage = downloadedImage;
        });
      }
    }
  }

  Future<File?> downloadImageFile(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/downloaded_medicine_image.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        print('Failed to download image: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error downloading image: $e');
      return null;
    }
  }

  Future<void> fetchMedicinesFromApi() async {
    // جلب بيانات المريض من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final patientId = prefs.getString('patientId');
    if (patientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient ID not found')),
      );
      return;
    }

    final url = Uri.parse('https://migration.runasp.net/api/Medicine/getMedicines?patientId=$patientId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // افترض إن الـ API بترجع JSON بيانات الأدوية، اعمل parsing هنا
        final List medicines = jsonDecode(response.body);
        print('Medicines: $medicines');

        // لو عندك قائمة تعرض الأدوية، اعمل setState لتحديث الواجهة هنا
        // مثلاً: setState(() => _medicines = medicines);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load medicines: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching medicines: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    if (selectedIndex != index) {
      setState(() {
        selectedIndex = index;
      });

      switch (index) {
        case 0:
          Navigator.pushNamed(context, HomeScreen.routName);
          break;
        case 1:
        // لما تختاري تاب الادوية، جلب البيانات من API فوراً
          fetchMedicinesFromApi();
          break;
        case 2:
          Navigator.pushNamed(context, ECGScreen.routName);
          break;
        case 3:
          Navigator.pushNamed(context, ProfileScreen.routName);
          break;
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _imageError = null;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeError = null;
      });
    }
  }


  Future<void> _confirm() async {
    setState(() {
      _timeError = _selectedTime == null ? 'Please select a time' : null;


      // إذا هي حالة إضافة (ليس تعديل)، فيجب اختيار صورة
      if (!widget.isEdit) {
        _imageError = _selectedImage == null ? 'Please select or capture an image' : null;
      } else {
        // في حالة التعديل، الصورة الجديدة اختيارية
        _imageError = null;
      }
    });

    if (!_formKey.currentState!.validate() || _selectedTime == null || (!widget.isEdit && _selectedImage == null)) {
      return;  // إذا لم تتوفر الشروط، لا نتابع
    }

    print('🟡 isEdit: ${widget.isEdit}');
    print('🟡 existingId: ${widget.existingId}');


    final prefs = await SharedPreferences.getInstance();
    final patientId = prefs.getString('patientId');
    print(' ✅PatientId from SharedPreferences: $patientId');

    if (patientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' ✅Patient ID not found')),
      );
      return;
    }

    final DateTime fullDateTime = DateTime(
      DateTime.now().year, // يمكنك استخدام _selectedDate!.year إذا عندك التاريخ
      DateTime.now().month,
      DateTime.now().day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (widget.isEdit && widget.existingId != null) {
      final updateUrl = Uri.parse('https://migration.runasp.net/api/Medicine/updateMedicine/${widget.existingId}');
      var request = http.MultipartRequest('PUT', updateUrl);

      request.fields['MedicineName'] = _medicineNameController.text.trim();
      request.fields['MedicineDosage'] = _dosageController.text.trim();
      request.fields['StartTime'] = fullDateTime.toIso8601String(); // ✅ نفس التعديل

      request.fields['MedicineNumTimes'] = _hours.toString();
      request.fields['PatientID'] = patientId;

      // أضف صورة جديدة فقط إذا تم اختيارها
      if (_selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath('MedicineImage', _selectedImage!.path));
      }

      print('📦 Request Fields:');
      request.fields.forEach((key, value) {
        print('🔸 $key: $value');
      });

      print('🖼 Request Files:');
      for (var file in request.files) {
        print('📁 field: ${file.field}, filename: ${file.filename}');
      }

      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Medicine updated successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update medicine: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating medicine: $e')),
        );
      }
    } else {
      final uri = Uri.parse('https://migration.runasp.net/api/Medicine/addMedicine');
      final request = http.MultipartRequest('POST', uri);

      request.fields['MedicineName'] = _medicineNameController.text.trim();
      request.fields['MedicineDosage'] = _dosageController.text.trim();
      request.fields['StartTime'] = fullDateTime.toIso8601String(); // ✅ نفس التعديل
      request.fields['MedicineNumTimes'] = _hours.toString();
      request.fields['PatientID'] = patientId;

      request.files.add(await http.MultipartFile.fromPath(
        'MedicineImage',
        _selectedImage!.path,
      ));

// Convert image to base64 and save in SharedPreferences
      final bytes = await _selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);
      prefs.setString('medicineImageBase64', base64Image); // تخزين الصورة


      try {
        final response = await request.send();
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Medicine added successfully')),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add medicine: ${response.statusCode}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
          onPressed: () => Navigator.pop(context),
          iconSize: 30,
        ),
        title: Text(
          widget.isEdit ? 'Edit Medicine' : 'Add New Medicine',
          style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w400,
              fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenSize.height * 0.03),
                _buildTextField("Medicine Name", _medicineNameController),
                SizedBox(height: screenSize.height * 0.02),
                _buildTextField("Dosage in mg", _dosageController,
                    keyboardType: TextInputType.number),
                SizedBox(height: screenSize.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Remind me every ',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 20)),
                    InkWell(
                      onTap: () async {
                        final selectedHour = await showDialog<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Select interval in hours'),
                              content: Container(
                                width: double.minPositive,
                                height: 200,
                                child: ListView.builder(
                                  itemCount: 24,
                                  itemBuilder: (context, index) {
                                    final hour = index + 1;
                                    return ListTile(
                                      title: Text('$hour hour${hour > 1 ? 's' : ''}'),
                                      onTap: () => Navigator.pop(context, hour),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );

                        if (selectedHour != null) {
                          setState(() {
                            _hours = selectedHour;
                          });
                        }
                      },
                      child: Text('$_hours',
                          style: TextStyle(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 22,
                              decoration: TextDecoration.underline)),
                    ),
                    SizedBox(width: 5),
                    Text('hours',
                        style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 20)),
                  ],
                ),
                SizedBox(height: screenSize.height * 0.03),

                // ✅ عرض الصورة المختارة أو المحملة
                if (_selectedImage != null)
                  Center(
                    child: Column(
                      children: [
                        Image.file(_selectedImage!, height: 180),
                        SizedBox(height: 12),
                      ],
                    ),
                  ),

                // ✅ أزرار اختيار الصورة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImagePickerButton(Icons.camera_alt, "Scan Document",
                            () => _pickImage(ImageSource.camera)),
                    _buildImagePickerButton(Icons.file_upload_outlined,
                        "Upload from phone", () => _pickImage(ImageSource.gallery)),
                  ],
                ),

                if (_imageError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_imageError!,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.center),
                  ),

                SizedBox(height: screenSize.height * 0.05),
                Text("Starting Time",
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w400)),
                SizedBox(height: screenSize.height * 0.01),
                Center(
                  child: SizedBox(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.06,
                    child: ElevatedButton(
                      onPressed: _selectTime,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Select Time",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                ),
                if (_timeError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                    child: Text(_timeError!,
                        style: TextStyle(color: Colors.red)),
                  ),
                SizedBox(height: screenSize.height * 0.02),
                Text(
                  _selectedTime == null
                      ? "No time selected"
                      : "Selected Starting Time: ${_selectedTime!.format(context)}",
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: screenSize.height * 0.02),
                Center(
                  child: SizedBox(
                    width: screenSize.width * 0.8,
                    height: screenSize.height * 0.06,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _timeError = _selectedTime == null ? 'Please select a time' : null;
                          if (!widget.isEdit) {
                            _imageError = _selectedImage == null ? 'Please select or capture an image' : null;
                          } else {
                            _imageError = null;
                          }
                        });

                        if (_formKey.currentState!.validate() &&
                            _selectedTime != null &&
                            (widget.isEdit || _selectedImage != null)) {
                          _confirm();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text("Confirm",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryColor)),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'This field is required';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            enabledBorder: _textFieldBorder(),
            focusedBorder: _textFieldBorder(),
            errorBorder: _textFieldBorder(borderColor: Colors.red),
            focusedErrorBorder: _textFieldBorder(borderColor: Colors.red),
          ),
        ),
      ],
    );
  }

  InputBorder _textFieldBorder({Color borderColor = AppColors.primaryColor}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: borderColor, width: 2),
    );
  }

  Widget _buildImagePickerButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: AppColors.primaryColor,fontSize: 18)),
        SizedBox(height: 12),
        Ink(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            height: 100,
            width: 100,
            child: IconButton(
              icon: Icon(icon, color: AppColors.primaryColor),
              onPressed: onPressed,
              iconSize: 50,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/images/home.png")),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/images/reminder.png")),
          label: "Medicine Reminder",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/images/measure.png")),
          label: "Measure",
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(AssetImage("assets/images/profile.png")),
          label: "Profile",
        ),
      ],
    );
  }
}
