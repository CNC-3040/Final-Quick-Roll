// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class CustomRoleButton extends StatelessWidget {
//   final String text;
//   final Color backgroundColor;
//   final Color textColor;
//   final Widget nextScreen;
//   final bool isOutlined;
//   final Color? borderColor;

//   const CustomRoleButton({
//     super.key,
//     required this.text,
//     required this.backgroundColor,
//     required this.textColor,
//     required this.nextScreen,
//     this.isOutlined = false,
//     this.borderColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final ButtonStyle style = isOutlined
//         ? OutlinedButton.styleFrom(
//             side: BorderSide(
//               color: borderColor ?? Colors.black,
//               width: 1.5,
//             ),
//             foregroundColor: textColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//           )
//         : ElevatedButton.styleFrom(
//             backgroundColor: backgroundColor,
//             foregroundColor: textColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(30),
//             ),
//             elevation: 0,
//           );

//     final Widget button = isOutlined
//         ? OutlinedButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => nextScreen),
//               );
//             },
//             style: style,
//             child: Text(
//               text,
//               style: GoogleFonts.poppins(
//                 fontSize: 25,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           )
//         : ElevatedButton(
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => nextScreen),
//               );
//             },
//             style: style,
//             child: Text(
//               text,
//               style: GoogleFonts.poppins(
//                 fontSize: 25,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           );

//     return SizedBox(
//       width: double.infinity,
//       height: 65,
//       child: button,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRoleButton<T> extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final PageRoute<T> nextScreen;
  final bool isOutlined;
  final Color? borderColor;

  const CustomRoleButton({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.nextScreen,
    this.isOutlined = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = isOutlined
        ? OutlinedButton.styleFrom(
            side: BorderSide(
              color: borderColor ?? Colors.black,
              width: 1.5,
            ),
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          );

    final Widget button = isOutlined
        ? OutlinedButton(
            onPressed: () {
              Navigator.pushReplacement(context, nextScreen);
            },
            style: style,
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w300,
              ),
            ),
          )
        : ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context, nextScreen);
            },
            style: style,
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 25,
                fontWeight: FontWeight.w300,
              ),
            ),
          );

    return SizedBox(
      width: double.infinity,
      height: 65,
      child: button,
    );
  }
}
