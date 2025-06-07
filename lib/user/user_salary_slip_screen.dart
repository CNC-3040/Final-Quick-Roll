// import 'package:flutter/material.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:quick_roll/utils/user_colors.dart';

// class SalarySlipScreen extends StatelessWidget {
//   // Example Attendance and Salary Data
//   final String employeeName = " ";
//   final String designation = " ";
//   final String department = " ";
//   final DateTime joiningDate = DateTime(2, 6, 23);
//   final String payPeriod = " ";
//   final int totalWorkingDays = 30;
//   final int workedDays = 26;

//   final double basicPay = 10000.0;
//   final double incentivePay = 1000.0;
//   final double houseRentAllowance = 400.0;
//   final double mealAllowance = 200.0;

//   final double providentFund = 1200.0;
//   final double professionalTax = 500.0;
//   final double loanDeduction = 400.0;

//   SalarySlipScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Generate Salary Slip'),
//         backgroundColor: AppColors.softSlateBlue, // Set AppBar background color to sky blue
//         iconTheme: const IconThemeData(
//           color: AppColors.darkNavyBlue, // Set back arrow color to charcoalGray
//         ),
//         // Set text color in the AppBar
//         titleTextStyle: const TextStyle(
//           color: AppColors.darkNavyBlue, // Set the title text color to charcoalGray
//           fontWeight: FontWeight.bold,
//           fontSize: 20,
//         ),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.white, backgroundColor: AppColors.deepSkyBlue, // Text color (white)
//             padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
//             textStyle: const TextStyle(fontSize: 16),
//           ),
//           onPressed: () async {
//             // Calculations
//             final totalEarnings = basicPay + incentivePay + houseRentAllowance + mealAllowance;
//             final totalDeductions = providentFund + professionalTax + loanDeduction;
//             final netPay = totalEarnings - totalDeductions;

//             final pdf = pw.Document();
//             pdf.addPage(
//               pw.Page(
//                 build: (context) => pw.Padding(
//                   padding: const pw.EdgeInsets.all(20),
//                   child: pw.Column(
//                     crossAxisAlignment: pw.CrossAxisAlignment.start,
//                     children: [
//                       pw.Text(
//                         "Payslip",
//                         style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
//                       ),
//                       pw.SizedBox(height: 10),
//                       pw.Text("Zoonoodle Inc"),
//                       pw.Text("21023 Pearson Point Road, Gateway Avenue"),
//                       pw.SizedBox(height: 20),
//                       pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Text("Date of Joining: ${joiningDate.toLocal()}"),
//                           pw.Text("Employee Name: $employeeName"),
//                         ],
//                       ),
//                       pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Text("Pay Period: $payPeriod"),
//                           pw.Text("Designation: $designation"),
//                         ],
//                       ),
//                       pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Text("Worked Days: $workedDays"),
//                           pw.Text("Department: $department"),
//                         ],
//                       ),
//                       pw.SizedBox(height: 20),
//                       pw.Table(
//                         border: pw.TableBorder.all(),
//                         children: [
//                           pw.TableRow(children: [
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(5),
//                               child: pw.Text("Earnings", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(5),
//                               child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(5),
//                               child: pw.Text("Deductions", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                             ),
//                             pw.Padding(
//                               padding: const pw.EdgeInsets.all(5),
//                               child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                             ),
//                           ]),

//                           // Other Table Rows...
//                         ],
//                       ),
//                       pw.SizedBox(height: 20),
//                       pw.Row(
//                         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                         children: [
//                           pw.Text("Total Earnings: $totalEarnings"),
//                           pw.Text("Total Deductions: $totalDeductions"),
//                         ],
//                       ),
//                       pw.Text("Net Pay: $netPay", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
//                       pw.SizedBox(height: 20),
//                       pw.Text("Nine Thousand Five Hundred"),
//                       pw.SizedBox(height: 20),
//                       pw.Text("Employer Signature ____________________________"),
//                       pw.Text("Employee Signature ____________________________"),
//                       pw.SizedBox(height: 20),
//                       pw.Text("This is a system-generated payslip."),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//             await Printing.layoutPdf(onLayout: (format) => pdf.save());
//           },
//           child: const Text('Generate PDF'),
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quick_roll/utils/user_colors.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class SalarySlipScreen extends StatefulWidget {
  const SalarySlipScreen({super.key});

  @override
  _SalarySlipScreenState createState() => _SalarySlipScreenState();
}

class _SalarySlipScreenState extends State<SalarySlipScreen> {
  String? employeeName;
  String? employeeId;
  String? companyId;
  String? contact;
  String? shift;
  double? salary;
  bool isLoading = true;

  String designation = "Employee";
  String department = "General";
  DateTime joiningDate = DateTime.now();
  String payPeriod = DateFormat('MMMM yyyy').format(DateTime.now());
  int totalWorkingDays = 30;
  int workedDays = 26;

  double houseRentAllowance = 0.0;
  double mealAllowance = 0.0;
  double incentivePay = 0.0;
  double providentFund = 0.0;
  double professionalTax = 0.0;
  double loanDeduction = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      employeeName = prefs.getString('loggedInUserName') ?? 'Unknown';
      employeeId = prefs.getString('loggedInUserId') ?? 'Unknown';
      companyId = prefs.getString('loggedInUserCompanyId') ?? 'Unknown';
      contact = prefs.getString('loggedInUserContact') ?? 'Unknown';
      shift = prefs.getString('selectedShift') ?? 'Day';
      salary =
          double.tryParse(prefs.getString('loggedInUserSalary') ?? '0.0') ??
              0.0;

      houseRentAllowance = salary! * 0.04;
      mealAllowance = salary! * 0.02;
      incentivePay = salary! * 0.1;
      providentFund = salary! * 0.12;
      professionalTax = 200.0;
      loanDeduction = 0.0;

      isLoading = false;
    });
  }

  String _numberToWords(double number) {
    final units = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine'
    ];
    final tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];
    final teens = [
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];
    final thousands = ['Thousand', 'Million', 'Billion'];

    if (number == 0) return 'Zero';

    String words = '';
    int intPart = number.toInt();
    int decimalPart = ((number - intPart) * 100).round();
    List<int> chunks = [];
    while (intPart > 0) {
      chunks.add(intPart % 1000);
      intPart ~/= 1000;
    }

    for (int i = chunks.length - 1; i >= 0; i--) {
      if (chunks[i] == 0) continue;
      int chunk = chunks[i];
      String chunkWords = '';

      if (chunk >= 100) {
        chunkWords += '${units[chunk ~/ 100]} Hundred ';
        chunk %= 100;
      }
      if (chunk >= 20) {
        chunkWords += '${tens[chunk ~/ 10]} ';
        chunk %= 10;
      } else if (chunk >= 10) {
        chunkWords += '${teens[chunk - 10]} ';
        chunk = 0;
      }
      if (chunk > 0) {
        chunkWords += '${units[chunk]} ';
      }
      if (chunkWords.isNotEmpty && i > 0) {
        chunkWords += '${thousands[i - 1]} ';
      }
      words += chunkWords;
    }

    if (decimalPart > 0) {
      words += 'and ${decimalPart.toString().padLeft(2, '0')}/100 ';
    }

    return words.trim() + ' Only';
  }

  pw.Document _buildPdfDocument() {
    final totalEarnings =
        salary! + incentivePay + houseRentAllowance + mealAllowance;
    final totalDeductions = providentFund + professionalTax + loanDeduction;
    final netPay = totalEarnings - totalDeductions;

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Payslip",
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Company ID: $companyId"),
              pw.Text("Employee ID: $employeeId"),
              pw.Text("Employee Name: $employeeName"),
              pw.Text("Contact: $contact"),
              pw.Text("Shift: $shift"),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      "Date of Joining: ${DateFormat('dd-MM-yyyy').format(joiningDate)}"),
                  pw.Text("Designation: $designation"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Pay Period: $payPeriod"),
                  pw.Text("Department: $department"),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Worked Days: $workedDays / $totalWorkingDays"),
                  pw.Text(""),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: const pw.FractionColumnWidth(0.35),
                  1: const pw.FractionColumnWidth(0.15),
                  2: const pw.FractionColumnWidth(0.35),
                  3: const pw.FractionColumnWidth(0.15),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text("Earnings",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text("Amount",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text("Deductions",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                      pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text("Amount",
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold))),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("Basic Pay")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(salary!.toStringAsFixed(2))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("Provident Fund")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(providentFund.toStringAsFixed(2))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("House Rent Allowance")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(houseRentAllowance.toStringAsFixed(2))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("Professional Tax")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(professionalTax.toStringAsFixed(2))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("Meal Allowance")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(mealAllowance.toStringAsFixed(2))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("Loan Deduction")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(loanDeduction.toStringAsFixed(2))),
                  ]),
                  pw.TableRow(children: [
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("Incentive Pay")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text(incentivePay.toStringAsFixed(2))),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("")),
                    pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text("")),
                  ]),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                      "Total Earnings: ${totalEarnings.toStringAsFixed(2)}"),
                  pw.Text(
                      "Total Deductions: ${totalDeductions.toStringAsFixed(2)}"),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text("Net Pay: ${netPay.toStringAsFixed(2)}",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text("${_numberToWords(netPay)}"),
              pw.SizedBox(height: 20),
              pw.Text("Employer Signature ____________________________"),
              pw.Text("Employee Signature ____________________________"),
              pw.SizedBox(height: 20),
              pw.Text("This is a system-generated payslip."),
            ],
          ),
        ),
      ),
    );
    return pdf;
  }

  Future<void> _generateAndSavePdf() async {
    try {
      final pdf = _buildPdfDocument();
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          'payslip_${employeeId}_${payPeriod.replaceAll(' ', '_')}.pdf';
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payslip saved to ${file.path}')));
      await OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error generating PDF: $e')));
    }
  }

  Future<void> _printPdf() async {
    final pdf = _buildPdfDocument();
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Salary Slip'),
        backgroundColor: AppColors.softSlateBlue,
        iconTheme: const IconThemeData(color: AppColors.darkNavyBlue),
        titleTextStyle: const TextStyle(
          color: AppColors.darkNavyBlue,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Employee: $employeeName',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Shift: $shift'),
                  const SizedBox(height: 20),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: AppColors.deepSkyBlue,
                  //     foregroundColor: Colors.white,
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 16, horizontal: 32),
                  //   ),
                  //   onPressed: _generateAndSavePdf,
                  //   child: const Text('Generate and Save PDF'),
                  // ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkNavyBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 32),
                    ),
                    onPressed: _printPdf,
                    child: const Text('Print Salary Slip'),
                  ),
                ],
              ),
            ),
    );
  }
}
