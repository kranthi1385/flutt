import 'package:flutter/material.dart';
import 'package:flutter_integrate_ip/registration.dart';
import 'package:flutter_integrate_ip/surveys_view.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({
    super.key,
  });


  
  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child:  SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               DrawerHeader(child:  ListTile(
                leading:const CircleAvatar(
                  child: Icon(Icons.account_circle_outlined),
                ) ,
                title: const Text('Profile Picture'),
                onTap: () => {Navigator.of(context).pop()},
              ),),
              ListTile(
                leading:const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () => {Navigator.of(context).pop()},
              ),
              
              ListTile(
                leading:const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () => {Navigator.of(context).pop()},
              ),
                ListTile(
                leading:const Icon(Icons.person),
                title: const Text('Registration'),
                onTap: () { 
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const RegistrationForm())
                    );
                    },
              ),
              ListTile(
                leading:const Icon(Icons.calendar_view_day_rounded),
                title: const Text('Surveys'),
                onTap: () {
                  Navigator.pop(context);
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) =>  const SurveyView(panlistId: "",partnerGUID: ""))
                    );
                  },
              ),
                    ]),
          ),
        ),
      )
    );
  }
}
