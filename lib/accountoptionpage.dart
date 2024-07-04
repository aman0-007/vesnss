import 'package:flutter/material.dart';
import 'package:vesnss/enrollment.dart';
import 'package:vesnss/studentlogin.dart';
import 'package:vesnss/teacherlogin.dart';

class Accountoptionpage extends StatefulWidget {
  const Accountoptionpage({super.key});

  @override
  State<Accountoptionpage> createState() => _AccountoptionpageState();
}

class _AccountoptionpageState extends State<Accountoptionpage> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: deviceHeight * 0.06),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Enrollment()),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text("Enroll Youself ",style: TextStyle(color: Color(0xFFF5180F),fontWeight: FontWeight.bold,fontSize: 18),),
                const Icon(Icons.arrow_forward,color: Color(0xFFF5180F),size: 25,),
                SizedBox(width: deviceWidth * 0.07),
              ],
            ),
          ),
          SizedBox(height: deviceHeight * 0.16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: deviceWidth*0.6,
                  height: deviceHeight*0.4,
                  child: Image.asset("assets/logo/nss.png")
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.067),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E478A),
                  // color: Color(0xFFF5180F)
                  elevation: 5,
                  minimumSize: Size(deviceWidth * 0.7, deviceHeight * 0.057),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Studentlogin()),
                  );
                },
                child: const Text('Student Login',style: TextStyle(color: Color(0xFFF5180F),fontWeight: FontWeight.bold,fontSize: 18),),
              ),
            ],
          ),
          SizedBox(height: deviceHeight * 0.033), // Space between the buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 5,
                  minimumSize: Size(deviceWidth * 0.7, deviceHeight * 0.057),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Teacherlogin()),
                  );
                },
                child: const Text('Teacher Login',style: TextStyle(color: Color(0xFFF5180F),fontWeight: FontWeight.bold,fontSize: 18),),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
