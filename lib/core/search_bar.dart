import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final Function(String) onSearch;

  const CustomSearchBar({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onChanged: onSearch, // Calls the passed function
    );
  }
}


// import 'package:flutter/material.dart';

// void main() {
//   runApp(Hellosimple());
// }   designation id, name, company_id 
//employee  

// class Hellosimple extends StatelessWidget {
//   const Hellosimple({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// class PlaceHolder extends StatefulWidget {
//   const PlaceHolder({super.key});

//   @override
//   State<PlaceHolder> createState() => _PlaceHolderState();
// }

// class _PlaceHolderState extends State<PlaceHolder> {
//   int count = 0;

//   void increase() {
//     void setState(VoidCallback fn) {
//       // TODO: implement setState
//       count++;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text("$count")),
//       floatingActionButton: FloatingActionButton(onPressed: increase),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:quick_roll/main.dart';

// void main() {
//   runApp(Themechange());
// }

// class Themechange extends StatefulWidget {
//   const Themechange({super.key});

//   @override
//   State<Themechange> createState() => _ThemechangeState();
// }

// class _ThemechangeState extends State<Themechange> {
//   bool isDark = false;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: isDark ? ThemeData.dark() : ThemeData.light(),
//       home: Scaffold(
//         body: Center(
//           child: SwitchListTile(
//               value: isDark,
//               onChanged: (value) => setState(() {
//                     isDark = value;
//                   })),
//         ),
//       ),
//     );
//   }
// }
