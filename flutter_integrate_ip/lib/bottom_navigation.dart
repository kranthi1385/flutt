import 'package:flutter/material.dart';

class MenuBottom extends StatelessWidget {
  const MenuBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: 
        
       const <BottomNavigationBarItem>[ 
        BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_view_day_rounded),label: 'Surveys' ),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Registration'),
      ],

    );
    
  }
}