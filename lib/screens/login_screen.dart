import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:membresias_admin/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  // Lógica para iniciar sesión
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Iniciar sesión con correo y contraseña
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      // Obtener el usuario actual
      User? user = userCredential.user;

      if (user != null) {
        // Aquí verificamos el rol del usuario
        String? userRole = await AuthService().getUserRole(user.uid);
        List<String> validAdminRoles = ['admin', 'admin1', 'admin2', 'admin3'];

        if (validAdminRoles.contains(userRole)) {
          // Si el rol está en la lista de roles válidos, redirigimos a la pantalla de home
          Navigator.pushReplacementNamed(context, '/home');
        } else if (userRole == 'business_user') {
          // Si el rol es 'business_user', redirigimos a la pantalla de gestión de negocios
          Navigator.pushReplacementNamed(context, '/qrScanner');
        } else {
          // Si no tiene un rol válido, mostramos un mensaje de error
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Rol no encontrado')));
        }
      }
    } catch (e) {
      // Manejo de errores de inicio de sesión
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar sesión')),
      body: Stack(
        children: [
          // Imagen de fondo con opacidad
          Opacity(
            opacity: 0.03, // Ajusta la opacidad según sea necesario
            child: Image.asset(
              'lib/assets/images/background.png', // Ruta de la imagen de fondo
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                      height:
                          25), // Espacio para mover los elementos hacia abajo
                  Image.asset(
                    'lib/assets/images/logo.png', // Ruta de la imagen del logo
                    height: 300, // Ajusta el tamaño según sea necesario
                  ),

                  TextField(
                    controller: _emailController,
                    decoration:
                        InputDecoration(labelText: 'Correo electrónico'),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText:
                        !_isPasswordVisible, // Controla la visibilidad de la contraseña
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(
                              fontSize: 18, // Tamaño del texto
                            ),
                          ),
                          child: Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: Colors.orange, // Color del texto
                              fontSize: 18, // Tamaño del texto
                              inherit:
                                  false, // Asegúrate de que inherit sea false
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
