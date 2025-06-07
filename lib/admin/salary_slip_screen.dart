import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quick_roll/utils/admin_colors.dart';


class SalarySlipScreen extends StatelessWidget {
  // Example Attendance and Salary Data
  final String employeeName = " ";
  final String designation = " ";
  final String department = " ";
  final DateTime joiningDate = DateTime(2, 6, 23);
  final String payPeriod = " ";
  final int totalWorkingDays = 30;
  final int workedDays = 26;

  final double basicPay = 10000.0;
  final double incentivePay = 1000.0;
  final double houseRentAllowance = 400.0;
  final double mealAllowance = 200.0;

  final double providentFund = 1200.0;
  final double professionalTax = 500.0;
  final double loanDeduction = 400.0;

  SalarySlipScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Salary Slip'),
        backgroundColor: AppColors.skyBlue, // Set AppBar background color to sky blue
        iconTheme: const IconThemeData(
          color: AppColors.charcoalGray, // Set back arrow color to charcoalGray
        ),
        // Set text color in the AppBar
        titleTextStyle: const TextStyle(
          color: AppColors.charcoalGray, // Set the title text color to charcoalGray
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: AppColors.slateTeal, // Text color (white)
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            textStyle: const TextStyle(fontSize: 16),
          ),
          onPressed: () async {
            // Calculations
            final totalEarnings = basicPay + incentivePay + houseRentAllowance + mealAllowance;
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
                      pw.Text(
                        "Payslip",
                        style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Text("Zoonoodle Inc"),
                      pw.Text("21023 Pearson Point Road, Gateway Avenue"),
                      pw.SizedBox(height: 20),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Date of Joining: ${joiningDate.toLocal()}"),
                          pw.Text("Employee Name: $employeeName"),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Pay Period: $payPeriod"),
                          pw.Text("Designation: $designation"),
                        ],
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Worked Days: $workedDays"),
                          pw.Text("Department: $department"),
                        ],
                      ),
                      pw.SizedBox(height: 20),
                      pw.Table(
                        border: pw.TableBorder.all(),
                        children: [
                          pw.TableRow(children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text("Earnings", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text("Deductions", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ),
                          ]),

                          // Other Table Rows...
                        ],
                      ),
                      pw.SizedBox(height: 20),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("Total Earnings: $totalEarnings"),
                          pw.Text("Total Deductions: $totalDeductions"),
                        ],
                      ),
                      pw.Text("Net Pay: $netPay", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 20),
                      pw.Text("Nine Thousand Five Hundred"),
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
            await Printing.layoutPdf(onLayout: (format) => pdf.save());
          },
          child: const Text('Generate PDF'),
        ),
      ),
    );
  }
}
