import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quick_roll/admin/home_screen.dart';
import 'package:quick_roll/core/role_selection_screen.dart';
import 'package:quick_roll/utils/user_colors.dart';
import 'package:quick_roll/widgets/emp_rounded_textbox.dart';
import 'package:quick_roll/widgets/emp_navigation_arrow.dart';
import 'package:quick_roll/model/employee_signup_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NoAnimationPageRoute<T> extends MaterialPageRoute<T> {
  NoAnimationPageRoute({required WidgetBuilder builder})
      : super(builder: builder);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class EmployeeNameScreen extends StatelessWidget {
  const EmployeeNameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeModel = Provider.of<EmployeeSignupModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: employeeModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: employeeModel.getGreenStripWidth(context),
                    color: AppColors.deepTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Employee",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Name",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: RoundedTextBox(
                hint: "Employee Name",
                initialValue: employeeModel.name,
                errorText: employeeModel.nameError,
                onChanged: (value) {
                  employeeModel.setValue('name', value);
                  employeeModel.validateName();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (employeeModel.validateName()) {
                    employeeModel.setScreenIndex(1);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const EmployeeDesignationScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeDesignationScreen extends StatelessWidget {
  const EmployeeDesignationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeModel = Provider.of<EmployeeSignupModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: employeeModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: employeeModel.getGreenStripWidth(context),
                    color: AppColors.deepTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Employee",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Designation",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: RoundedTextBox(
                hint: "Designation",
                dropdownItems: const [
                  'Software Engineer',
                  'Product Manager',
                  'HR Manager',
                  'Accountant',
                  'Sales Representative',
                ],
                initialValue: employeeModel.designation,
                errorText: employeeModel.designationError,
                onDropdownChanged: (value) {
                  employeeModel.setValue('designation', value ?? '');
                  employeeModel.validateDesignation();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  employeeModel.setScreenIndex(0);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (employeeModel.validateDesignation()) {
                    employeeModel.setScreenIndex(2);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const EmployeeDOBScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeDOBScreen extends StatelessWidget {
  const EmployeeDOBScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeModel = Provider.of<EmployeeSignupModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: employeeModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: employeeModel.getGreenStripWidth(context),
                    color: AppColors.deepTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "When is your",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Birthday?",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: RoundedTextBox(
                hint: "Date of Birth (YYYY-MM-DD)",
                initialValue: employeeModel.dob,
                errorText: employeeModel.dobError,
                isTimeInput: true,
                onChanged: (value) {
                  employeeModel.setValue('dob', value);
                  employeeModel.validateDOB();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  employeeModel.setScreenIndex(1);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (employeeModel.validateDOB()) {
                    employeeModel.setScreenIndex(3);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const EmployeeContactScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeContactScreen extends StatelessWidget {
  const EmployeeContactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeModel = Provider.of<EmployeeSignupModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: employeeModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: employeeModel.getGreenStripWidth(context),
                    color: AppColors.deepTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Welcome",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    employeeModel.name.isEmpty
                        ? "Employee"
                        : employeeModel.name,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  RoundedTextBox(
                    hint: "Email Address",
                    initialValue: employeeModel.email,
                    errorText: employeeModel.emailError,
                    upperText: false,
                    onChanged: (value) {
                      employeeModel.setValue('email', value);
                      employeeModel.validateEmail();
                    },
                  ),
                  const SizedBox(height: 20),
                  RoundedTextBox(
                    hint: "Contact Number",
                    initialValue: employeeModel.contact,
                    errorText: employeeModel.contactError,
                    upperText: false,
                    onChanged: (value) {
                      employeeModel.setValue('contact', value);
                      employeeModel.validateContact();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  employeeModel.setScreenIndex(2);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (employeeModel.validateEmail() &&
                      employeeModel.validateContact()) {
                    employeeModel.setScreenIndex(4);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const EmployeePasswordScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeePasswordScreen extends StatelessWidget {
  const EmployeePasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeModel = Provider.of<EmployeeSignupModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: employeeModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: employeeModel.getGreenStripWidth(context),
                    color: AppColors.deepTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Security",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Is Important!",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoundedTextBox(
                    hint: "Create A Password",
                    isPassword: true,
                    initialValue: employeeModel.password,
                    errorText: employeeModel.passwordError,
                    upperText: false,
                    onChanged: (value) {
                      employeeModel.setValue('password', value);
                      employeeModel.validatePassword();
                    },
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      "Strong password recommended.*",
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.deepTeal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      RoundedTextBox(
                        hint: "Remember me",
                        isCheckbox: true,
                        checkboxLabel: "Remember me",
                        onCheckboxChanged: (value) {
                          // Handle remember me state if needed
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  employeeModel.setScreenIndex(3);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (employeeModel.validatePassword()) {
                    employeeModel.setScreenIndex(5);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const EmployeeAddressScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeAddressScreen extends StatelessWidget {
  const EmployeeAddressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeModel = Provider.of<EmployeeSignupModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: employeeModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: employeeModel.getGreenStripWidth(context),
                    color: AppColors.deepTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Where Can We",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Reach You?",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: RoundedTextBox(
                hint: "Address",
                initialValue: employeeModel.address,
                errorText: employeeModel.addressError,
                onChanged: (value) {
                  employeeModel.setValue('address', value);
                  employeeModel.validateAddress();
                },
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  employeeModel.setScreenIndex(4);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    employeeModel.setValue('address', '');
                    employeeModel.setScreenIndex(6);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const EmployeeDocumentsScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Later",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: AppColors.myTeal,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (employeeModel.validateAddress()) {
                    employeeModel.setScreenIndex(6);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) => const EmployeeDocumentsScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeDocumentsScreen extends StatelessWidget {
  const EmployeeDocumentsScreen({Key? key}) : super(key: key);

  Future<void> _pickImage(BuildContext context, String field) async {
    final employeeModel =
        Provider.of<EmployeeSignupModel>(context, listen: false);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      employeeModel.setValue(field, pickedFile.path);
      employeeModel.validateDocuments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeModel = Provider.of<EmployeeSignupModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            AnimatedBuilder(
              animation: employeeModel,
              builder: (context, child) {
                return Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 20,
                    width: employeeModel.getGreenStripWidth(context),
                    color: AppColors.deepTeal,
                  ),
                );
              },
            ),
            Positioned(
              top: size.height * 0.15,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Upload",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w200,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Documents",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Positioned(
              top: size.height * 0.40,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(context, 'documentImage'),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: employeeModel.documentImageError != null
                                ? const Color(0xff97dbbc)
                                : AppColors.deepTeal),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            employeeModel.documentImage.isEmpty
                                ? "Upload Document"
                                : "Document Selected",
                            style: GoogleFonts.poppins(
                              color: employeeModel.documentImage.isEmpty
                                  ? const Color(0xffffffff)
                                  : const Color(0xff024653),
                              fontSize: 21,
                            ),
                          ),
                          Icon(Icons.upload_file, color: AppColors.deepTeal),
                        ],
                      ),
                    ),
                  ),
                  if (employeeModel.documentImageError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: Text(
                        employeeModel.documentImageError!,
                        style: GoogleFonts.poppins(
                          color: const Color(0xff97dbbc),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _pickImage(context, 'photoPath'),
                    child: Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                            color: employeeModel.photoPathError != null
                                ? const Color(0xff97dbbc)
                                : AppColors.deepTeal),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            employeeModel.photoPath.isEmpty
                                ? "Upload Photo"
                                : "Photo Selected",
                            style: GoogleFonts.poppins(
                              color: employeeModel.photoPath.isEmpty
                                  ? const Color(0xffffffff)
                                  : const Color(0xff024653),
                              fontSize: 21,
                            ),
                          ),
                          Icon(Icons.upload_file, color: AppColors.deepTeal),
                        ],
                      ),
                    ),
                  ),
                  if (employeeModel.photoPathError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 5),
                      child: Text(
                        employeeModel.photoPathError!,
                        style: GoogleFonts.poppins(
                          color: const Color(0xff97dbbc),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              left: 30,
              child: GestureDetector(
                onTap: () {
                  employeeModel.setScreenIndex(5);
                  Navigator.pop(context);
                },
                child: const NavigationArrow(isForward: false),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    employeeModel.setValue('documentImage', '');
                    employeeModel.setValue('photoPath', '');
                    employeeModel.setScreenIndex(7);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) =>
                            const EmployeeRegistrationSuccessScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "Later",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: AppColors.myTeal,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 30,
              child: GestureDetector(
                onTap: () {
                  if (employeeModel.validateDocuments()) {
                    employeeModel.setScreenIndex(7);
                    Navigator.push(
                      context,
                      NoAnimationPageRoute(
                        builder: (context) =>
                            const EmployeeRegistrationSuccessScreen(),
                      ),
                    );
                  }
                },
                child: const NavigationArrow(isForward: true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeRegistrationSuccessScreen extends StatelessWidget {
  const EmployeeRegistrationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employeeModel = Provider.of<EmployeeSignupModel>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.deepTeal,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: size.height * 0.18,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/Artboardemplogo.png",
                width: 130,
                height: 130,
              ),
            ),
            Positioned(
              top: size.height * 0.41,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    "Registration",
                    style: GoogleFonts.poppins(
                      fontSize: 35,
                      fontWeight: FontWeight.w200,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Successful",
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (employeeModel.apiError != null)
              Positioned(
                top: size.height * 0.55,
                left: 30,
                right: 30,
                child: Text(
                  employeeModel.apiError!,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: const Color(0xff97dbbc),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            Positioned(
              bottom: 40,
              left: 30,
              right: 30,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          employeeModel.setScreenIndex(0);
                          Navigator.pushReplacement(
                            context,
                            NoAnimationPageRoute(
                              builder: (context) => const EmployeeNameScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Take a Tour",
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                            color: AppColors.myTeal,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final success =
                              await employeeModel.registerEmployee(context);
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              NoAnimationPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 35, vertical: 7),
                          decoration: BoxDecoration(
                            color: AppColors.myTeal,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Text(
                            "Finish",
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              color: AppColors.deepTeal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "By Clicking finish, you agree to Quick Roll's Terms of services\n& acknowledge Quick Roll's Privacy Policy.",
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: AppColors.myTeal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeSignupFlow extends StatelessWidget {
  const EmployeeSignupFlow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const EmployeeNameScreen();
  }
}
