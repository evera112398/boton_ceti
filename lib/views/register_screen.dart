import 'package:boton_ceti/global/global_vars.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int currentStep = 0;

  void _onStepContinue() {
    print('step continue');
    currentStep++;
    setState(() {});
  }

  void _onStepCancel() {
    print('step cancel');
    currentStep--;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stepper(
          type: StepperType.vertical,
          currentStep: currentStep,
          onStepContinue: _onStepContinue,
          onStepCancel: _onStepCancel,
          steps: [
            Step(
              isActive: currentStep >= 0,
              title: const Text('Datos personales'),
              content: Container(),
            ),
            Step(
              isActive: currentStep >= 1,
              title: const Text('Correo y celular'),
              content: Container(),
            ),
            Step(
              isActive: currentStep >= 2,
              title: const Text('Crear contraseña'),
              content: Container(),
            ),
            Step(
              isActive: currentStep >= 3,
              title: const Text('Documentos legales'),
              content: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
