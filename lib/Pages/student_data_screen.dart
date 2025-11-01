import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Widgets/text_field_item.dart';
import '../utils/validators.dart';

class StudentData extends StatefulWidget {
  const StudentData({super.key});

  @override
  State<StudentData> createState() => _StudentDataState();
}

class _StudentDataState extends State<StudentData> {

   final TextEditingController nameController = TextEditingController();
   final TextEditingController usernameController = TextEditingController();
   final TextEditingController passwordController = TextEditingController();
   final TextEditingController ageController = TextEditingController();
   //final TextEditingController phoneController = TextEditingController();
   //final phoneRegex=RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$');
    
   bool isPasswordVisible=false;
   final _formKey = GlobalKey<FormState>();

    void handle(){
    if(_formKey.currentState!.validate()){
      print("success");
    }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               //crossAxisAlignment: CrossAxisAlignment.center,
              
              children: [
                //const SizedBox(height: 20,),
                Row(
                  
                  children: [
                    Image.asset('assets/images/log.png',height: 40,),
                    const SizedBox(height: 6,),
                    Image.asset('assets/images/Kido.png',height: 40,)
                  ],
                ),

                const SizedBox(height: 20,),
            
                Text(
                     "Bring kid onboard", 
                    style:TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      shadows: [
                    Shadow(
                      blurRadius: 2,
                      offset: Offset(0.5, 0.5),
                      color: Colors.black26,
                    )
                  ],
            
                ),
                maxLines: 1,
                //overflow: TextOverflow.ellipsis,
                //textAlign: TextAlign.center,
                ),

                const SizedBox(height:10,),
            
                Image.asset(
                  'assets/images/student_data.png',
                   height: 336,width: 339,),
            
            
              SizedBox(height: 20,),
              
               Form(
                key: _formKey,
                 child: Column(
                  children: [


                     CustomTextField(
                    fieldController: nameController ,
                    fieldIcon: Icon(Icons.face),
                    fieldLabel: "Child's name",
                    fieldObscure: false,
                    
                    //validator: Validators.validateEmail
                 
                  ),
                 
                  const SizedBox(height: 16,),


                     CustomTextField(
                    fieldController: usernameController ,
                    fieldIcon: Icon(Icons.people),
                    fieldLabel: "Child's Username",
                    fieldObscure: false,
                    //validator: Validators.validateEmail
                 
                  ),
                 
                  const SizedBox(height: 16,),

                   CustomTextField(
                    fieldController: ageController ,
                    fieldIcon: Icon(Icons.date_range),
                    fieldLabel: "Child's Age",
                    fieldObscure: false,
                    keyboardType:TextInputType.numberWithOptions(),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    //validator: Validators.validateEmail
                 
                  ),
                 
                  const SizedBox(height: 16,),

                 
                 
                  CustomTextField(
                    fieldController: passwordController ,
                    fieldIcon: Icon(Icons.lock),
                    fieldLabel: "Child's Password",
                    fieldObscure: !isPasswordVisible,
                    suffixIcon: IconButton(
                      onPressed: (){
                      setState(() {
                        isPasswordVisible=!isPasswordVisible;
                      });
                      }, icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off , color: Color(0xff837F7F)
                      )),
                    validator: Validators.validatePassword,
                 
                  ),
                 
                  const SizedBox(height: 30,),
                 
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xffffB74D),Color(0xffff8A65),Color(0xfff06292)],
                                               begin: Alignment.centerLeft,
                                               end:Alignment.centerRight),
                      borderRadius: BorderRadius.circular(25),
                      
                    ),
                    child: ElevatedButton(
                      onPressed: handle,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                      ),
                      child: Text("Add My Little Star",
                      style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),)),

                     
                  ),

                   

                   // const SizedBox(height: 8,),

                    
                  ],
                 ),
               )
            
            
            
               
            
            
              ],
            ),
          ),
        ),
      );
  }
}