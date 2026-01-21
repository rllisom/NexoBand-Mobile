import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPageView extends StatelessWidget {
  const LoginPageView({super.key});

  @override
  Widget build(BuildContext context) {
    
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 200,),
              
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [ Color(0xFFF13B57),Color(0xFFFC7E39),],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight
                  ),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.music_note,size: 60,color: Colors.white,),
                    Text("NexoBand",style: GoogleFonts.chicle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  ],
                ),
              ),
              SizedBox(height: 40,),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email:',
                          labelStyle: TextStyle(color: Color(0xFFFC7E39),fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 4)
                            )
                          ),
                        ),
                        SizedBox(height: 40,),
                        TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Contraseña:',
                          labelStyle: TextStyle(color: Color(0xFFFC7E39),fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(width: 4)
                            )
                          )
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.only(left: 150),
                          child: Text("¿Olvidaste la contraseña?",style: TextStyle(color: Color(0xFFFC7E39),fontWeight: FontWeight.bold ),),
                        )
                    ],
                  ),
                )
              ),
              SizedBox(height: 20,),
              Container(
                width: 330,
                height: 40,
                decoration: BoxDecoration(
                  gradient : LinearGradient(colors: [ Color(0xFFF13B57),Color(0xFFFC7E39)]),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Center(child: Text("Iniciar sesión",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
              ),
              SizedBox(height: 30,),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Si no tienes cuenta,",style: TextStyle(fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 94, 94, 94)),),
                    ShaderMask( shaderCallback: (Rect bounds){
                      return LinearGradient(colors: [ Color(0xFFF13B57),Color(0xFFFC7E39)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        ).createShader(bounds);
                    },
                      child: Text(" regístrate aquí",style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                ],),
              )
            ],
          ),
        ),
      ),
    );
  }
}