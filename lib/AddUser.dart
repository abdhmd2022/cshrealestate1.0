import 'dart:convert';
import 'package:cshrealestatemobile/UsersReport.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Sidebar.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;


class AddUser extends StatefulWidget
{
  const AddUser({Key? key}) : super(key: key);
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUser> with TickerProviderStateMixin {
  bool isDashEnable = true,
      isRolesVisible = true,
      isUserEnable = true,
      isUserVisible = true,
      isRolesEnable = true,
      _isLoading = false,
      isVisibleNoUserFound = false,
      _isFocused_email = false,
      _isFocus_name = false;


  List<dynamic> myData_roles = [
    {'role_name': 'Sales'},
    {'role_name': 'Accountant'},
    {'role_name': 'Manager'},
  ];

  dynamic _selectedrole;
  List<String> _selectedCompanies = [];
  List<String> myDataCompanies = [];


  String user_email_fetched = "";

  late final TextEditingController controller_email = TextEditingController();
  late final TextEditingController controller_password = TextEditingController();
  late final TextEditingController controller_name = TextEditingController();

  bool _isFocused_password = false;
  bool _obscureText = true;

  String name = "",email = "";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  late SharedPreferences prefs;

  String? hostname = "", company = "",company_lowercase = "",serial_no= "",username= "",HttpURL= "",SecuritybtnAcessHolder= "";

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      _selectedrole = myData_roles.first;

    });


    /*setState(() {
      hostname = prefs.getString('hostname');

      company  = prefs.getString('company_name');
      company_lowercase = company!.replaceAll(' ', '').toLowerCase();
      serial_no = prefs.getString('serial_no');
      username = prefs.getString('username');

      SecuritybtnAcessHolder = prefs.getString('secbtnaccess');

      String? email_nav = prefs.getString('email_nav');
      String? name_nav = prefs.getString('name_nav');

      if (email_nav!=null && name_nav!= null)
      {
        name = name_nav;
        email = email_nav;
      }

      if(SecuritybtnAcessHolder == "True")
      {
        isRolesVisible = true;
        isUserVisible = true;
      }
      else
      {
        isRolesVisible = false;
        isUserVisible = false;
      }
      fetchRoles(serial_no!);
      fetchCompany(serial_no!);
    });*/
  }

  /*Future<void> userRegistration(String selectedserial,String email,String password,String rolename, String name) async {
    setState(() {
      _isLoading = true;
    });

    try
    {
      final url = Uri.parse('$BASE_URL_config/api/login/userRegistration');


      Map<String,String> headers = {
        'Authorization' : 'Bearer $authTokenBase',
        "Content-Type": "application/json"
      };

      var body = jsonEncode( {
        "username": email ,
        "serialno" :selectedserial,
        "password": password,
        "rolename": rolename,
        "name": name,
      });

      final response = await http.post(
          url,
          body: body,
          headers:headers
      );

      if (response.statusCode == 200)
      {
        String responsee = response.body;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responsee),
          ),
        );
        if(responsee == "User Registered Successfully")
        {
          addAllowedCompanies(email, serial_no!, _selectedCompanies);

          controller_email.clear();
          controller_name.clear();
          controller_password.clear();
          _selectedrole =   myData_roles[0];
          FocusScope.of(context).unfocus();

        }
        else if (responsee == "No of users exceeded")
        {
          controller_email.clear();
          controller_name.clear();
          controller_password.clear();
          _selectedrole =   myData_roles.first;
          FocusScope.of(context).unfocus();

        }
        else
        {
          controller_email.clear();
          controller_name.clear();
          controller_password.clear();
          _selectedrole =   myData_roles[0];
          FocusScope.of(context).unfocus();
        }
      }
      else
      {
        Map<String, dynamic> data = json.decode(response.body);
        String error = '';

        if (data.containsKey('error')) {
          setState(() {
            error = data['error'];
          });
        }
        else
        {
          error = 'Something went wrong!!!';
        }

        Fluttertoast.showToast(msg: error);

      }
      setState(() {
        _isLoading = false;
      });
    }
    catch (e)
    {print(e);
    setState(() {
      _isLoading = false;
    });}

  }

  Future<void> fetchRoles(String selectedserial) async {
    setState(() {
      _isLoading = true;
    });

    try
    {
      final url = Uri.parse('$BASE_URL_config/api/roles/get');
      Map<String,String> headers = {
        'Authorization' : 'Bearer $authTokenBase',
        "Content-Type": "application/json"
      };

      var body = jsonEncode( {
        'serialno': selectedserial,

      });

      final response = await http.post(
          url,
          body: body,
          headers:headers
      );

      if (response.statusCode == 200)
      {
        myData_roles = jsonDecode(response.body);
        if (myData_roles != null) {
          setState(() {
            _selectedrole = myData_roles.first;
          });



        }
        else
        {
          throw Exception('Failed to fetch data');
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
    catch (e)
    {print(e);
    setState(() {
      _isLoading = false;
    });}
  }

  Future<void> fetchCompany(String selectedserial) async {
    myDataCompanies.clear();
    final url = Uri.parse('$BASE_URL_config/api/admin/getCompany');

    Map<String,String> headers = {
      'Authorization' : 'Bearer $authTokenBase',
      "Content-Type": "application/json"
    };

    var body = jsonEncode({
      'serialno': selectedserial
    });

    final response = await http.post(
        url,
        body : body,
        headers : headers
    );

    if (response.statusCode == 200)
    {
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData != null) {
        setState(() {
          myDataCompanies = responseData.map<String>((item) {
            return item['company_name'] as String;
          }).toList();
        });
      }
      else
      {

        throw Exception('Failed to fetch data');
      }
      setState(() {
        _isLoading = false;
      });
    }
    else
    {
      Map<String, dynamic> data = json.decode(response.body);
      String error = '';

      if (data.containsKey('error')) {
        setState(() {
          error = data['error'];
        });
      }
      else
      {
        error = 'Something went wrong!!!';
      }
      Fluttertoast.showToast(msg: error);

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> addAllowedCompanies(String email, String serialno, List<String> companies_list) async {
    myDataCompanies.clear();
    final url = Uri.parse('$BASE_URL_config/api/roles/allowed_companies');

    Map<String,String> headers = {
      'Authorization' : 'Bearer $authTokenBase',
      "Content-Type": "application/json"
    };

    print('$serialno, $email, $companies_list');

    var body = jsonEncode({
      'serial_no': serialno,
      'user_name' : email,
      'companies' : companies_list
    });

    final response = await http.post(
        url,
        body : body,
        headers : headers
    );

    if (response.statusCode == 200)
    {
      print(response.body);
    }
    else
    {
      Map<String, dynamic> data = json.decode(response.body);
      String error = '';

      if (data.containsKey('error')) {
        setState(() {
          error = data['error'];
        });
      }
      else
      {
        error = 'Something went wrong!!!';
      }
      Fluttertoast.showToast(msg: error);

      setState(() {
        _isLoading = false;
      });
    }
  }*/


  /*void _openMultiSelectDialog() async {
    final selectedValues = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Companies'),
          content: StatefulBuilder(
            builder: (context, setState) {
              bool isAllSelected = _selectedCompanies.length == myDataCompanies.length;

              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Select All Checkbox
                    CheckboxListTile(
                      title: const Text('Select All'),
                      value: isAllSelected,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            // Select all companies
                            _selectedCompanies = List.from(myDataCompanies);
                          } else {
                            // Deselect all companies
                            _selectedCompanies.clear();
                          }
                        });
                      },
                      activeColor: Colors.teal, // Customize the checkbox color
                    ),
                    const Divider(), // Optional: Separate "Select All" from individual options
                    // Individual Company Checkboxes
                    ...myDataCompanies.map((company) {
                      return CheckboxListTile(
                        title: Text(company),
                        value: _selectedCompanies.contains(company),
                        onChanged: (bool? checked) {
                          setState(() {
                            if (checked == true) {
                              _selectedCompanies.add(company);
                            } else {
                              _selectedCompanies.remove(company);
                            }
                          });
                        },
                        activeColor: Colors.teal, // Customize the checkbox color
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null); // Cancel
              },
              child: const Text('Cancel',
                style: TextStyle(
                    color: Colors.black
                ),),

            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _selectedCompanies); // Confirm
              },
              child: const Text('OK',
                  style: TextStyle(
                      color: Colors.black
                  )
              ),
            ),
          ],
        );
      },
    );

    // Update the selected companies if dialog returns valid data
    if (selectedValues != null) {
      setState(() {
        _selectedCompanies = selectedValues;
      });
    }
  }*/


  @override
  void initState() {
    super.initState();
    _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    _initSharedPreferences();
  }


  bool isValidEmail(String email) {
    // Simple email validation pattern
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => UsersReport()),
        );
        return true;
      },
      child:Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              /*Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SerialSelect()),
              );*/
            },
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Add Users',
                      style: TextStyle(
                          color: Colors.white
                      ),
                      overflow: TextOverflow.ellipsis, // Truncate text if it overflows
                      maxLines: 1, // Display only one line of text
                    ),
                  ),
                  SizedBox(width: 10), // Add some spacing between text and image
                  Icon(

                    Icons.edit,
                    color: appbar_color
                  )
                ],
              ),
            ),
          ),
          backgroundColor: appbar_color,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.menu,
                color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState!.openDrawer();
            },
          ),
        ),
        drawer: Sidebar(
            isDashEnable: isDashEnable,
            isRolesVisible: isRolesVisible,
            isRolesEnable: isRolesEnable,
            isUserEnable: isUserEnable,
            isUserVisible: isUserVisible,
            Username: name,
            Email: email,
            tickerProvider: this),
        body:Stack(
          children: [
            Visibility(
              visible: _isLoading,
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),

            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      left: 35,
                      top: 20,
                      right: 30,
                      bottom: 25,
                    ),
                    child: Text(
                      'User Registration',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Padding(

                      padding: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 0),

                      child: TextFormField(
                        controller: controller_name,

                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter name';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: _isFocus_name ? appbar_color : Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(color: _isFocus_name ? appbar_color : Colors.black),
                          prefixIcon: Icon(
                            Icons.person_2_outlined,
                            color: _isFocus_name ? appbar_color : Colors.black,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isFocus_name = true;
                            _isFocused_email = false;
                            _isFocused_password = false;

                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            _isFocus_name = false;
                            _isFocused_email = false;
                            _isFocused_password = false;
                          });
                        },
                        onTap: () {
                          setState(() {
                            _isFocus_name = true;
                            _isFocused_email = false;
                            _isFocused_password = false;
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            _isFocus_name = false;
                            _isFocused_email = false;
                            _isFocused_password = false;
                          });
                        },

                      )),

                  Padding(

                      padding: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 0),

                      child: TextFormField(
                        controller: controller_email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!isValidEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          hintText: 'Enter email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: _isFocused_email ? appbar_color : Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(color: _isFocused_email ? appbar_color : Colors.black),
                          prefixIcon: Icon(
                            Icons.email,
                            color: _isFocused_email ? appbar_color : Colors.black,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isFocused_email = true;
                            _isFocus_name = false;
                            _isFocused_password = false;
                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            _isFocused_email = false;
                            _isFocus_name = false;
                            _isFocused_password = false;
                          });
                        },
                        onTap: () {
                          setState(() {
                            _isFocused_email = true;
                            _isFocus_name = false;
                            _isFocused_password = false;

                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            _isFocused_email = false;
                            _isFocus_name = false;
                            _isFocused_password = false;
                          });
                        },

                      )),

                  Padding(padding: EdgeInsets.only(top:20,left: 20,right: 20,bottom: 0),

                      child: TextFormField(
                        controller: controller_password,
                        obscureText: _obscureText,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 4) {
                            return 'Password must be at least 4 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: _isFocused_password ? appbar_color : Colors.black,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                              color: _isFocused_password ? appbar_color : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color:Colors.black),

                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: appbar_color),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelStyle: TextStyle(
                            color: _isFocused_password ? appbar_color : Colors.black,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isFocused_password = true;
                            _isFocus_name = false;
                            _isFocused_email = false;
                          });
                        },
                        onFieldSubmitted: (value) {
                          setState(() {
                            _isFocused_password = false;
                            _isFocus_name = false;
                            _isFocused_email = false;
                          });
                        },
                        onTap: () {
                          setState(() {
                            _isFocused_password = true;
                            _isFocus_name = false;
                            _isFocused_email = false;
                          });
                        },
                        onEditingComplete: () {
                          setState(() {
                            _isFocused_password = false;
                            _isFocus_name = false;
                            _isFocused_email = false;
                          });
                        },
                      )


                  ),

                  Container(
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10,left:20),

                          child:Text(
                            'Select Role',
                            style: TextStyle(

                                fontWeight: FontWeight.bold
                            ),)
                          ,),

                        Padding(
                          padding: EdgeInsets.only(top:5,left:20,right:20,bottom :0),

                          child: DropdownButtonFormField<dynamic>(
                            decoration: InputDecoration(

                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: appbar_color),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                            ),


                            hint: Text('Role Name'), // Add a hint
                            value: _selectedrole,
                            items: myData_roles.map((item) {
                              return DropdownMenuItem<dynamic>(
                                value: item,
                                child: Text(item['role_name']),
                              );
                            }).toList(),
                            onChanged: (value) async {
                              _selectedrole = value!;
                            },

                            onTap: ()
                            {
                              setState(() {
                                _isFocused_email = false;
                                _isFocus_name = false;
                                _isFocused_password = false;
                              });

                            },
                          ),
                        ),

                        /*Padding(padding: EdgeInsets.only(top: 10,left:20),

                          child:Text(
                            'Allowed Companies',
                            style: TextStyle(

                                fontWeight: FontWeight.bold
                            ),)
                          ,),*/

                       /* Padding(
                          padding: EdgeInsets.only(top:5,left:20,right:20,bottom :0),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _openMultiSelectDialog,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Text(
                                    _selectedCompanies.isNotEmpty
                                        ? _selectedCompanies.map((e) => e).join('\n')
                                        : 'Tap to select companies',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),*/
                      ],
                    ),
                  ),

                  Padding(padding: EdgeInsets.only(left: 20,right: 20,top: 40,bottom: 50),

                    child: Container(


                      child: ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: appbar_color, // Set the text color
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 18.0), // Set the button padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0), // Set the button border radius
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            String fetched_email = controller_email.text;
                            String fetched_name = controller_name.text;
                            String fetched_password = controller_password.text;
                            String fetched_role = _selectedrole["role_name"];

                            if(fetched_name.isEmpty)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Enter Name"),
                                ),
                              );
                            }
                            else if (fetched_email.isEmpty)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Enter Email Address"),
                                ),
                              );
                            }
                            else if (fetched_password.isEmpty)
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Enter Password"),
                                ),
                              );
                            }
                            else
                            {
                              if (isValidEmail(fetched_email)) {
                                if(fetched_password.length < 4)
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Password must be at least 4 characters"),
                                    ),
                                  );
                                }

                                else
                                {
                                  setState(() {
                                    _isFocused_email = false;
                                    _isFocus_name = false;
                                    _isFocused_password = false;
                                  });
                                  /*userRegistration(serial_no!,fetched_email,fetched_password,fetched_role,fetched_name);*/
                                }
                              }
                              else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Enter Valid Email Address"),
                                  ),
                                );
                              }
                            }
                          });
                        },
                        child: Text('REGISTER'),
                      ),
                    ),)
                ],
              ),)
          ],
        ) ,
      ),
    );
    // TODO: implement build
  }
}