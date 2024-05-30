class EstablecimientosData {
  final int idEstablecimiento;
  final String nombre;
  final double latitud;
  final double longitud;

  EstablecimientosData({
    required this.idEstablecimiento,
    required this.nombre,
    required this.latitud,
    required this.longitud,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_establecimiento": idEstablecimiento,
      "nombre": nombre,
      "latitud": latitud,
      "longitud": longitud
    };
  }
}
