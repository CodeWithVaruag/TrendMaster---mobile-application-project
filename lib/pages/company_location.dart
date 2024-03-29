import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trendmasterass2/model/campaign_model.dart';

import '../model/user_model.dart';
import 'company_success_page.dart';

class CompanyLocationPage extends StatefulWidget {
  CampaignModel campaignModel;
  CompanyModel companyModel;
  CompanyLocationPage({required this.campaignModel, required this.companyModel});

  @override
  _CompanyLocationPageState createState() => _CompanyLocationPageState();
}

class _CompanyLocationPageState extends State<CompanyLocationPage> {
  String selectedLocation = '';

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> getLocationList() {
    return [
      {'name': 'Anywhere in Nepal', 'color': Colors.teal[300]},
      {'name': 'Kathmandu', 'color': Colors.teal[300]},
      {'name': 'Lalitpur', 'color': Colors.teal[300]},
      {'name': 'Bhaktapur', 'color': Colors.teal[300]},
      {'name': 'Patan', 'color': Colors.teal[300]},
      {'name': 'Kritipur', 'color': Colors.teal[300]},
      {'name': 'Chandragiri', 'color': Colors.teal[300]},
      {'name': 'Dhading', 'color': Colors.teal[300]},
      {'name': 'Nagarkot', 'color': Colors.teal[300]},
    ];
  }

  // Function to post campaign details to Firebase
  postDetailsToFirebase() async{
    // Accessing Firestore instance
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    // Creating a CampaignModel object with details from widget
    CampaignModel campaignModel = CampaignModel(
      title: widget.campaignModel.title ,
      description: widget.campaignModel.description,
      niche: widget.campaignModel.niche,
      count: widget.campaignModel.count,
      image: widget.campaignModel.image,
      budget: widget.campaignModel.budget,
      location: selectedLocation.toString(),
      userId: widget.companyModel.uid,
      companyName: widget.companyModel.name,
    );
    // Adding campaign details to Firestore collection
    await firebaseFirestore
        .collection("campaign_details")
        .doc()
        .set(campaignModel.toMap());
    Fluttertoast.showToast(msg: "Campaign Created Successfully.");

    // Navigating to the CompanySuccessPage with company details
    Navigator.of(context).push(
      MaterialPageRoute(builder:(context) => CompanySuccessPage(companyModel: widget.companyModel)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Location"),
        centerTitle: true, // Center the title
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Descriptions
              Text(
                "${widget.companyModel.name
                } do you want your creators to be located at?",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 5),

              Text(
                "This helps us to find the right creators based on location preference",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // List of name of locations
              Center(
                child: Column(
                  children: getLocationList().map((location) {
                    return FractionallySizedBox(
                      widthFactor: 1.0, // This sets the width of the button to be the same as the available space.
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            selectedLocation = location['name'];
                          });
                        },
                        child: Text(location['name']),
                        style: OutlinedButton.styleFrom(
                          primary: location['name'] == selectedLocation ? Colors.white : null,
                          backgroundColor: location['name'] == selectedLocation ? location['color'] : null,
                          textStyle: TextStyle(color: location['name'] == selectedLocation ? Colors.white : null),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 35),
              FractionallySizedBox(
                widthFactor: 0.55,
                child: ElevatedButton(
                  onPressed: () async{
                   await postDetailsToFirebase();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                  child: Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message, size: 30, color: Colors.grey),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 30, color: Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: 30, color: Colors.grey),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 30, color: Colors.grey),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
