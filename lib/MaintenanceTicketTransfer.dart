import 'dart:convert';

import 'package:cshrealestatemobile/MaintenanceTicketReport.dart';
import 'package:cshrealestatemobile/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'SalesInquiryReport.dart';
import 'Sidebar.dart';

class User {
  final String email;
  final int id;
  final String name;
  final String isAdmin;
  final String createdAt;
  final String alteredAt;
  final String isActive;
  final int serialId;
  final int? externalRoleId;

  User({
    required this.email,
    required this.id,
    required this.name,
    required this.isAdmin,
    required this.createdAt,
    required this.alteredAt,
    required this.isActive,
    required this.serialId,
    this.externalRoleId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      id: json['id'],
      name: json['name'],
      isAdmin: json['is_admin'],
      createdAt: json['created_at'],
      alteredAt: json['altered_at'],
      isActive: json['is_active'],
      serialId: json['serial_id'],
      externalRoleId: json['external_role_id'],
    );
  }
}

class MaintenanceTicketTransfer extends StatefulWidget
{
  /*final String name;
  final String id;
  final String email;

  const MaintenanceTicketTransfer({
    Key? key,
    required this.name,
    required this.id,
    required this.email,
  }) : super(key: key);*/


  @override
  _MaintenanceTicketTransferPageState createState() => _MaintenanceTicketTransferPageState();
}

class _MaintenanceTicketTransferPageState extends State<MaintenanceTicketTransfer> with TickerProviderStateMixin {

  int? selectedTransferToId; // To store the selec// ted dropdown value
  List<User> transfer_to_list = [

  ];

  TextEditingController _remarksController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isDashEnable = true,
      isRolesVisible = true,
      isUserEnable = true,
      isUserVisible = true,
      isRolesEnable = true,
      _isLoading = false,
      isVisibleNoRoleFound = false;

  String name = "",email = "";

  List<Map<String, String>> followUps = [
    {"role": "Created", "description": "Ticket created"},
    {"role": "Supervisor", "description": "Checked and approved"},
    {"role": "Technician", "description": "Work in progress"},
    //{"role": "Technician", "description": "Work Completed"},
    //{"role": "Closed", "description": "Ticket closed"},



  ];

  Future<void> fetchUsers() async {

    transfer_to_list.clear();

    final url = '$BASE_URL_config/v1/users'; // Replace with your API endpoint
    String token = 'Bearer $Serial_Token'; // auth token for request

    Map<String, String> headers = {
      'Authorization': token,
      "Content-Type": "application/json"
    };
    try {
      final response = await http.get(Uri.parse(url),
        headers: headers,);
      if (response.statusCode == 200) {

        final data = json.decode(response.body);

        setState(() {

          final usersJson = List<Map<String, dynamic>>.from(data['data']['users']);
          transfer_to_list = usersJson.map((userJson) => User.fromJson(userJson)).toList();
          print('list ${response.body}');

        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {

      print('Error fetching data: $e');
    }


  }

  /*Future<void> sendTransferInquiryRequest() async {



    // Replace with your API endpoint
    final String url = "$BASE_URL_config/v1/leads/${widget.id}";

    var uuid = Uuid();

    // Generate a v4 (random) UUID
    String uuidValue = uuid.v4();

    // Constructing the JSON body
    final Map<String, dynamic> requestBody = {
      "uuid": uuidValue,
      "assigned_to":selectedTransferToId,

    };

    print('create request body $requestBody');

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $Company_Token",
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Request was successful
        print("Response Data: ${response.body}");
        setState(() {
          _formKey.currentState?.reset();
          selectedTransferToId = null;
          _remarksController.clear();

        });

      } else {
        // Error occurred
        print("Error: ${response.statusCode}");
        print("Message: ${response.body}");

      }
    } catch (error) {
      print("Exception: $error");
    }
  }*/



  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }


  Future<void> _initSharedPreferences() async {

    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: appbar_color.withOpacity(0.9),
          automaticallyImplyLeading: false,

          leading: GestureDetector(
            onTap: ()
            {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MaintenanceTicketReport()),
              );
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),),

          title: Text('Ticket Transfer',
            style: TextStyle(
                color: Colors.white
            ),),
        ),

        drawer: Sidebar(
          isDashEnable: isDashEnable,
          isRolesVisible: isRolesVisible,
          isRolesEnable: isRolesEnable,
          isUserEnable: isUserEnable,
          isUserVisible: isUserVisible,
        ),

        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

            decoration:BoxDecoration(
              color: Colors.white
              /*gradient: LinearGradient(
                  colors: [
                    Color(0xFFD9FCF6),
                    Colors.white,

                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              ),*/
            ),
            child: SingleChildScrollView(
                child: Container(

                    height: MediaQuery.of(context).size.height,

                    child: Form(
                        key: _formKey,
                        child: ListView(
                            children: [

                              SizedBox(height: 16,),
                              Padding(padding: EdgeInsets.only(left: 25,top: 10,bottom: 10),
                                child:  Column(
                                  children: followUps.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    Map<String, String> followUp = entry.value;
                                    return Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 2),
                                              child: Icon(Icons.circle, size: 12, color: Colors.blueAccent),
                                            ),
                                            if (index != followUps.length -1)
                                              Container(height: 40, width: 2, color: Colors.blueAccent),
                                          ],
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(followUp["role"]!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                              Text(followUp["description"]!, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                                              SizedBox(height: 0),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),),



                              Container(
                                margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only( top:0,
                                          bottom: 5,
                                          left: 0,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Text("Transfer To:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16
                                              )
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            '*', // Red asterisk for required field
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.red, // Red color for the asterisk
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      margin: EdgeInsets.only(left: 00,right: 0,bottom: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey.shade300, width: 1.5),
                                      ),
                                      child: DropdownButtonFormField<int>(
                                        decoration: InputDecoration(
                                          border: InputBorder.none, // Remove default border
                                          contentPadding: EdgeInsets.zero, // Remove extra padding
                                        ),
                                        value: selectedTransferToId, // Replace with your variable
                                        hint: Text('Select an option'),

                                        validator: (value) {
                                          if (value == null) {
                                            return 'Transfer to is required'; // Custom error message
                                          }
                                          return null;
                                        },

                                        items: transfer_to_list.map((User item) { // Replace 'items' with your list
                                          return DropdownMenuItem<int>(
                                            value: item.id,
                                            child: Text(item.name),
                                          );
                                        }).toList(),
                                        onChanged: (int? newValue) {
                                          setState(() {
                                            selectedTransferToId = newValue; // Replace with your state logic
                                            print(' transfer to id $selectedTransferToId');
                                          });
                                        },
                                        icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),),

                              Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[

                                    /*Container(
                                      margin: EdgeInsets.only( top:0,
                                          bottom: 5,
                                          left: 20,
                                          right: 20),
                                      child: Row(
                                        children: [
                                          Text("Remarks:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16

                                              )
                                          ),
                                          SizedBox(width: 2),
                                          Text(
                                            '*', // Red asterisk for required field
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.red, // Red color for the asterisk
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),*/

                                    Padding(
                                        padding: EdgeInsets.only(top:0,left: 20,right: 20,bottom: 0),
                                        child: TextFormField(
                                            controller: _remarksController,
                                            keyboardType: TextInputType.multiline,

                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Remarks are required';
                                              }
                                              return null;
                                            },
                                            maxLength: 500, // Limit input to 500 characters
                                            maxLines: 3, // A
                                            decoration: InputDecoration(
                                              labelText: "Remarks",
                                              hintText: 'Enter Remarks*',
                                              contentPadding: EdgeInsets.all(15),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10), // Set the border radius
                                                borderSide: BorderSide(
                                                  color: Colors.black, // Set the border color
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                                borderSide: BorderSide(
                                                  color:  appbar_color, // Set the focused border color
                                                ),
                                              ),
                                              labelStyle: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ))),
                                  ]),

                    /*  SizedBox(height: 10),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:[
                          Container(
                            margin: EdgeInsets.only(
                                top:0,
                                bottom: 2,
                                left: 20,
                                right: 20
                            ),
                            child: Text("Total Amount:",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                )
                            ),),

                          Container(
                              margin: EdgeInsets.only(
                                  top:0,
                                  bottom: 20,
                                  left: 20,
                                  right: 20
                              ),
                              child: TextField(
                                  controller: _totalamountController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,

                                  decoration: InputDecoration(
                                    hintText: 'Enter Amount',
                                    contentPadding: EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), // Set the border radius
                                      borderSide: BorderSide(
                                        color: Colors.black, // Set the border color
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:  Colors.black, // Set the focused border color
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ))),
                        ]),*/

                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(left: 20,right: 20,top: 20,bottom: 80),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: appbar_color,
                                    elevation: 5, // Adjust the elevation to make it look elevated
                                    shadowColor: Colors.black.withOpacity(0.5), // Optional: adjust the shadow color
                                  ),
                                  onPressed: () {

                                    if (_formKey.currentState != null &&
                                        _formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();

                                      // sendTransferInquiryRequest();

                                    }},
                                  child: Text('Transfer',
                                      style: TextStyle(
                                          color: Colors.white
                                      )),
                                ),)

                            ]))
                )

            )
        )
    );}}

Widget _buildDecentButton(
    String label, IconData icon, Color color, VoidCallback onPressed) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(30.0),
    splashColor: color.withOpacity(0.2),
    highlightColor: color.withOpacity(0.1),
    child: Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.white,
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 8.0),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
