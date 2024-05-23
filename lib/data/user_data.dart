class UserData {
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correo;
  final String celular;
  final int idEstablecimiento;
  final String password;
  final int acepto;

  UserData({
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.correo,
    required this.celular,
    required this.idEstablecimiento,
    required this.password,
    required this.acepto,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_aplicacion": 1,
      "nombre": nombre,
      "apellido_paterno": apellidoPaterno,
      "apellido_materno": apellidoMaterno,
      "correo": correo,
      "celular": celular,
      "id_establecimiento": idEstablecimiento,
      "password": password,
      "acepto": acepto,
    };
  }
}
