import 'package:flutter/material.dart';
import '../Widgets/text_field_item.dart';
import '../utils/validators.dart';
import 'parent_login_screen.dart';




class ParentSignup extends StatefulWidget {
  const ParentSignup({super.key});

  @override
  State<ParentSignup> createState() => _ParentSignupState();
}

class _ParentSignupState extends State<ParentSignup> {

  final TextEditingController emailController = TextEditingController();
   final TextEditingController passwordController = TextEditingController();
   final TextEditingController nameController = TextEditingController();
   final TextEditingController phoneController = TextEditingController();
   final phoneRegex=RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$');

   bool isPasswordVisible=false;
   final _formKey = GlobalKey<FormState>();
   
    void handle(){
    if(_formKey.currentState!.validate()){
      print("success");
    }
    }


  @override
  Widget build(BuildContext context) {
    return
      
       Scaffold(
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
                     "Hi,Parent!", 
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
            
                )),

                const SizedBox(height:10,),
            
                Image.asset(
                  'assets/images/parent_sign up.png',
                   height: 336,width: 339,),
            
            
              SizedBox(height: 20,),
              
               Form(
                key: _formKey,
                 child: Column(
                  children: [

                     CustomTextField(
                    fieldController: nameController ,
                    fieldIcon: Icon(Icons.person),
                    fieldLabel: "Full Name",
                    fieldObscure: false,
                    validator:Validators.validateName,
                 
                  ),

                   const SizedBox(height: 16,),

                   CustomTextField(
                    fieldController: phoneController ,
                    fieldIcon: Icon(Icons.phone),
                    fieldLabel: "Phone Number",
                    fieldObscure: false,
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Please enter your phone!";
                      }
            
                       if(!phoneRegex.hasMatch(value)){
                        return "Please enter a valid phone number";
                      }
            
                      return null;
                    },
                 
                  ),

                   const SizedBox(height: 16,),


                     CustomTextField(
                    fieldController: emailController ,
                    fieldIcon: Icon(Icons.email),
                    fieldLabel: "Email",
                    fieldObscure: false,
                    validator: Validators.validateEmail,
                 
                  ),
                 
                  const SizedBox(height: 16,),
                 
                  CustomTextField(
                    fieldController: passwordController ,
                    fieldIcon: Icon(Icons.lock),
                    fieldLabel: "Password",
                    fieldObscure: !isPasswordVisible,
                    suffixIcon: IconButton(
                      onPressed: 
                      (){
                        setState(() {
                           isPasswordVisible=!isPasswordVisible;
                        });
                      }, 
                      icon: Icon(
                         isPasswordVisible ? Icons.visibility : Icons.visibility_off , color: Color(0xff837F7F)
                      )),
                    validator: Validators.validatePassword,
                 
                  ),
                 
                  const SizedBox(height: 30,),
                 
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xffF8AA3B),Color(0xffFF7A78),Color(0xffEE3187)],
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
                      child: Text("Create Account",
                      style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),)),

                     
                  ),

                   const SizedBox(height: 16,),

                   

                   // const SizedBox(height: 8,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Have an account?",
                        style: TextStyle(color: Color(0xff837F7F))),

                        TextButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>ParentLogin()));
                        },
                         child: Text("Log In",
                         style: TextStyle(color: Color(0xffEE3187),fontWeight: FontWeight.bold)))

                      ],
                    )
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