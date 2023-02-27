class User {
  String imagen;
  String nombre;
  String carrera;
  double promedio;

  User(this.imagen, this.nombre, this.carrera, this.promedio);

  get getNombre => nombre;
  get getCarrera => carrera;
  get getPromedio => promedio;
  get getImagen => imagen;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        json['imagen'], json['nombre'], json['carrera'], json['promedio']);
  }
}
