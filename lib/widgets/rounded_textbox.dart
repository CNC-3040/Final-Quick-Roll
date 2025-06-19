// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class RoundedTextBox extends StatefulWidget {
//   final String hint;
//   final bool isPassword;

//   const RoundedTextBox({
//     super.key,
//     required this.hint,
//     this.isPassword = false,
//   });

//   @override
//   State<RoundedTextBox> createState() => _RoundedTextBoxState();
// }

// class _RoundedTextBoxState extends State<RoundedTextBox> {
//   bool _obscureText = true;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: const Color(0xFF336870)),
//         borderRadius: BorderRadius.circular(40),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               obscureText: widget.isPassword ? _obscureText : false,
//               style: GoogleFonts.poppins(
//                 color: const Color(0xFF024653),
//                 fontSize: 18,
//               ),
//               decoration: InputDecoration(
//                 hintText: widget.hint,
//                 hintStyle: GoogleFonts.poppins(
//                   color: const Color(0xFF73979B),
//                   fontSize: 18,
//                 ),
//                 border: InputBorder.none,
//               ),
//               cursorColor: const Color(0xFF336870),
//             ),
//           ),
//           if (widget.isPassword)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _obscureText = !_obscureText;
//                 });
//               },
//               child: Icon(
//                 _obscureText ? Icons.visibility_off : Icons.visibility,
//                 color: const Color(0xFF336870),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class RoundedTextBox extends StatefulWidget {
//   final String hint;
//   final bool isPassword;
//   final bool isTimeInput;
//   final bool isCheckbox;
//   final String? checkboxLabel;
//   final IconData? trailingIcon;
//   final List<String>? dropdownItems;
//   final ValueChanged<String>? onChanged;
//   final ValueChanged<String?>? onDropdownChanged;
//   final ValueChanged<bool>? onCheckboxChanged;

//   const RoundedTextBox({
//     super.key,
//     required this.hint,
//     this.isPassword = false,
//     this.isTimeInput = false,
//     this.isCheckbox = false,
//     this.checkboxLabel,
//     this.trailingIcon,
//     this.dropdownItems,
//     this.onChanged,
//     this.onDropdownChanged,
//     this.onCheckboxChanged,
//   });

//   @override
//   State<RoundedTextBox> createState() => _RoundedTextBoxState();
// }

// class _RoundedTextBoxState extends State<RoundedTextBox> {
//   bool _obscureText = true;
//   bool _checkboxValue = false;
//   String? _selectedDropdownValue;
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.isCheckbox) {
//       return Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             widget.checkboxLabel ?? "",
//             style: GoogleFonts.poppins(
//               fontSize: 16,
//               color: const Color(0xFF024653),
//             ),
//           ),
//           const SizedBox(width: 10),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 _checkboxValue = !_checkboxValue;
//                 if (widget.onCheckboxChanged != null) {
//                   widget.onCheckboxChanged!(_checkboxValue);
//                 }
//               });
//             },
//             child: Container(
//               width: 20,
//               height: 20,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(5),
//                 border: Border.all(color: const Color(0xFF024653)),
//                 color: _checkboxValue
//                     ? const Color(0xFF024653)
//                     : Colors.transparent,
//               ),
//               child: _checkboxValue
//                   ? const Icon(Icons.check, size: 16, color: Colors.white)
//                   : null,
//             ),
//           ),
//         ],
//       );
//     }

//     return Container(
//       height: 60,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: const Color(0xFF336870)),
//         borderRadius: BorderRadius.circular(40),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: widget.dropdownItems != null
//                 ? DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: _selectedDropdownValue,
//                       hint: Text(
//                         widget.hint,
//                         style: GoogleFonts.poppins(
//                           color: const Color(0xFF73979B),
//                           fontSize: 18,
//                         ),
//                       ),
//                       icon: const Icon(Icons.arrow_drop_down,
//                           color: Color(0xFF336870)),
//                       isExpanded: true,
//                       onChanged: (value) {
//                         setState(() {
//                           _selectedDropdownValue = value;
//                         });
//                         if (widget.onDropdownChanged != null) {
//                           widget.onDropdownChanged!(value);
//                         }
//                       },
//                       items: widget.dropdownItems!.map((item) {
//                         return DropdownMenuItem(
//                           value: item,
//                           child: Text(
//                             item,
//                             style: GoogleFonts.poppins(
//                               color: const Color(0xFF024653),
//                               fontSize: 18,
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),
//                   )
//                 : TextField(
//                     controller: _controller,
//                     obscureText: widget.isPassword ? _obscureText : false,
//                     keyboardType: widget.isTimeInput
//                         ? TextInputType.datetime
//                         : TextInputType.text,
//                     style: GoogleFonts.poppins(
//                       color: const Color(0xFF024653),
//                       fontSize: 18,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: widget.hint,
//                       hintStyle: GoogleFonts.poppins(
//                         color: const Color(0xFF73979B),
//                         fontSize: 18,
//                       ),
//                       border: InputBorder.none,
//                     ),
//                     cursorColor: const Color(0xFF336870),
//                     onChanged: widget.onChanged,
//                   ),
//           ),
//           if (widget.isPassword)
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _obscureText = !_obscureText;
//                 });
//               },
//               child: Icon(
//                 _obscureText ? Icons.visibility_off : Icons.visibility,
//                 color: const Color(0xFF336870),
//               ),
//             ),
//           if (widget.trailingIcon != null && !widget.isPassword)
//             Icon(widget.trailingIcon, color: const Color(0xFF336870), size: 20),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedTextBox extends StatefulWidget {
  final String hint;
  final bool isPassword;
  final bool isTimeInput;
  final bool isCheckbox;
  final String? checkboxLabel;
  final IconData? trailingIcon;
  final List<String>? dropdownItems;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String?>? onDropdownChanged;
  final ValueChanged<bool>? onCheckboxChanged;
  final String? errorText;

  const RoundedTextBox({
    super.key,
    required this.hint,
    this.isPassword = false,
    this.isTimeInput = false,
    this.isCheckbox = false,
    this.checkboxLabel,
    this.trailingIcon,
    this.dropdownItems,
    this.onChanged,
    this.onDropdownChanged,
    this.onCheckboxChanged,
    this.errorText,
  });

  @override
  State<RoundedTextBox> createState() => _RoundedTextBoxState();
}

class _RoundedTextBoxState extends State<RoundedTextBox> {
  bool _obscureText = true;
  bool _checkboxValue = false;
  String? _selectedDropdownValue;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isCheckbox) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.checkboxLabel ?? "",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF024653),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              setState(() {
                _checkboxValue = !_checkboxValue;
                if (widget.onCheckboxChanged != null) {
                  widget.onCheckboxChanged!(_checkboxValue);
                }
              });
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xFF024653)),
                color: _checkboxValue
                    ? const Color(0xFF024653)
                    : Colors.transparent,
              ),
              child: _checkboxValue
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
                color: widget.errorText != null
                    ? Colors.red
                    : const Color(0xFF336870)),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            children: [
              Expanded(
                child: widget.dropdownItems != null
                    ? DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedDropdownValue,
                          hint: Text(
                            widget.hint,
                            style: GoogleFonts.poppins(
                              color: const Color(0xFF73979B),
                              fontSize: 18,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_drop_down,
                              color: Color(0xFF336870)),
                          isExpanded: true,
                          onChanged: (value) {
                            setState(() {
                              _selectedDropdownValue = value;
                            });
                            if (widget.onDropdownChanged != null) {
                              widget.onDropdownChanged!(value);
                            }
                          },
                          items: widget.dropdownItems!.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(
                                item,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF024653),
                                  fontSize: 18,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : TextField(
                        controller: _controller,
                        obscureText: widget.isPassword ? _obscureText : false,
                        keyboardType: widget.isTimeInput
                            ? TextInputType.datetime
                            : TextInputType.text,
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF024653),
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.hint,
                          hintStyle: GoogleFonts.poppins(
                            color: const Color(0xFF73979B),
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                        ),
                        cursorColor: const Color(0xFF336870),
                        onChanged: widget.onChanged,
                      ),
              ),
              if (widget.isPassword)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  child: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF336870),
                  ),
                ),
              if (widget.trailingIcon != null && !widget.isPassword)
                Icon(widget.trailingIcon,
                    color: const Color(0xFF336870), size: 20),
            ],
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 5),
            child: Text(
              widget.errorText!,
              style: GoogleFonts.poppins(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
