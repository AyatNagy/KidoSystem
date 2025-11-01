import 'package:flutter/material.dart';

import '../Widgets/text_field_item.dart';
import '../utils/validators.dart';
import 'parent_signup_screen.dart';

class ParentLogin extends StatefulWidget {
  const ParentLogin({super.key});

 

  @override
  State<ParentLogin> createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {

   final TextEditingController emailController = TextEditingController();
   final TextEditingController passwordController = TextEditingController();
   bool isPasswordVisible=false;
   final _formKey = GlobalKey<FormState>();
   final emailRegex=RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
   final passwordRegex=RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{8,}$');

  //! for sumbit inputs
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
                  'assets/images/parent_sign in.png',
                   height: 336,width: 339,),
            
            
              SizedBox(height: 20,),
              
               Form(
                key: _formKey,
                 child: Column(
                  children: [
                     CustomTextField(
                    fieldController: emailController ,
                    fieldIcon: Icon(Icons.email),
                    fieldLabel: "Email",
                    fieldObscure: false,
                    validator: Validators.validateEmail
                 
                  ),
                 
                  const SizedBox(height: 16,),
                 
                  CustomTextField(
                    fieldController: passwordController ,
                    fieldIcon: Icon(Icons.lock),
                    fieldLabel: "Password",
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
                      gradient: LinearGradient(colors: [Color(0xff3DF0C4),Color(0xff3BDBE7),Color(0xff2C8FF9)],
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
                      child: Text("Sign In",
                      style: TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),)),

                     
                  ),

                   const SizedBox(height: 16,),

                   TextButton(onPressed: (){print("Forget preesed");},
                    child: Text("Forget Password?",style: TextStyle(color: Color(0xff837F7F))),),

                   // const SizedBox(height: 8,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Dont have an account?",
                        style: TextStyle(color: Color(0xff837F7F))),

                        TextButton(onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>ParentSignup()));
                        },
                         child: Text("Create one",
                         style: TextStyle(color: Color(0xff2C8FF9),fontWeight: FontWeight.bold)))

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