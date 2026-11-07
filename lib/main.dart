import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' hide Path;

void main() => runApp(const App());

const verde = Color(0xFF06C167);
const lon0 = -58.545;
const lat0 = -34.515;
const kpx = 100.0;
const ancho = 2060.0;
const alto = 2200.0;

Offset geo(double lo, double la) => Offset((lo - lon0) * 92.0 * kpx, (lat0 - la) * 110.6 * kpx);
double dkm(Offset a, Offset b) => (a - b).distance / kpx;
double cl(double x, [double a = 0, double b = 1]) => x < a ? a : (x > b ? b : x);
double ahoraH() {
  final n = DateTime.now();
  return n.hour + n.minute / 60;
}

final yo = geo(-58.3855, -34.6012);

const caba = <List<double>>[
  [-58.4720, -34.5390], [-58.4640, -34.5300], [-58.4500, -34.5290], [-58.4380, -34.5390],
  [-58.4270, -34.5500], [-58.4130, -34.5560], [-58.4040, -34.5570], [-58.3990, -34.5640],
  [-58.3880, -34.5700], [-58.3770, -34.5800], [-58.3690, -34.5900], [-58.3600, -34.5990],
  [-58.3520, -34.6080], [-58.3410, -34.6100], [-58.3330, -34.6170], [-58.3380, -34.6300],
  [-58.3640, -34.6340], [-58.3720, -34.6410], [-58.3840, -34.6480], [-58.3980, -34.6520],
  [-58.4130, -34.6570], [-58.4270, -34.6640], [-58.4400, -34.6700], [-58.4440, -34.6800],
  [-58.4560, -34.6960], [-58.4660, -34.7050], [-58.4800, -34.6990], [-58.4970, -34.6850],
  [-58.5060, -34.6700], [-58.5160, -34.6560], [-58.5290, -34.6430], [-58.5300, -34.6260],
  [-58.5240, -34.6160], [-58.5130, -34.6040], [-58.4990, -34.5900], [-58.4870, -34.5750],
  [-58.4780, -34.5600], [-58.4720, -34.5470],
];

final agua = <List<double>>[
  [-58.4900, -34.5150],
  ...caba.sublist(0, 17),
  [-58.3560, -34.6420], [-58.3440, -34.6600], [-58.3300, -34.6900], [-58.3200, -34.7150], [-58.3200, -34.5150],
];

Path poli(List<List<double>> l, [bool cerrar = true]) {
  final p = Path();
  for (var i = 0; i < l.length; i++) {
    final q = geo(l[i][0], l[i][1]);
    if (i == 0) {
      p.moveTo(q.dx, q.dy);
    } else {
      p.lineTo(q.dx, q.dy);
    }
  }
  if (cerrar) p.close();
  return p;
}

final pCaba = poli(caba);
final pAgua = poli(agua);
final pRia = poli(caba.sublist(16, 29), false);

class Via {
  final String n;
  final int t;
  final List<List<double>> p;
  Via(this.n, this.t, this.p);
  late final List<Offset> q = p.map((e) => geo(e[0], e[1])).toList();
}

final vias = <Via>[
  Via('Av. Gral. Paz', 2, [...caba.sublist(28), caba[0]]),
  Via('Au. 25 de Mayo', 2, [[-58.3730, -34.6110], [-58.3860, -34.6200], [-58.4040, -34.6340], [-58.4230, -34.6460], [-58.4440, -34.6560], [-58.4700, -34.6640], [-58.4960, -34.6690], [-58.5060, -34.6700]]),
  Via('Au. Illia', 2, [[-58.3780, -34.5940], [-58.3870, -34.5830], [-58.3990, -34.5700], [-58.4060, -34.5640]]),
  Via('Au. Lugones', 2, [[-58.4090, -34.5640], [-58.4230, -34.5550], [-58.4400, -34.5440], [-58.4580, -34.5370], [-58.4710, -34.5400]]),
  Via('Av. del Libertador', 1, [[-58.4710, -34.5470], [-58.4570, -34.5520], [-58.4430, -34.5620], [-58.4290, -34.5700], [-58.4130, -34.5780], [-58.3990, -34.5850], [-58.3840, -34.5920], [-58.3780, -34.5950]]),
  Via('Av. Cabildo', 1, [[-58.4730, -34.5470], [-58.4650, -34.5560], [-58.4540, -34.5620], [-58.4420, -34.5700], [-58.4290, -34.5790], [-58.4240, -34.5830]]),
  Via('Av. Santa Fe', 1, [[-58.4240, -34.5830], [-58.4100, -34.5890], [-58.3960, -34.5940], [-58.3800, -34.5960]]),
  Via('Av. Las Heras', 1, [[-58.4170, -34.5800], [-58.4000, -34.5880], [-58.3900, -34.5930]]),
  Via('Av. Córdoba', 1, [[-58.3750, -34.5990], [-58.3980, -34.5990], [-58.4180, -34.5960], [-58.4400, -34.5920], [-58.4600, -34.5890]]),
  Via('Av. Corrientes', 1, [[-58.3640, -34.6030], [-58.3820, -34.6037], [-58.4050, -34.6020], [-58.4280, -34.6000], [-58.4500, -34.5960], [-58.4640, -34.5910]]),
  Via('Av. Rivadavia', 1, [[-58.3730, -34.6080], [-58.4080, -34.6100], [-58.4360, -34.6190], [-58.4650, -34.6280], [-58.4920, -34.6330], [-58.5230, -34.6380]]),
  Via('Av. Independencia', 1, [[-58.3680, -34.6180], [-58.3900, -34.6170], [-58.4100, -34.6160], [-58.4250, -34.6150]]),
  Via('Av. San Juan', 1, [[-58.3700, -34.6210], [-58.3900, -34.6260], [-58.4150, -34.6280], [-58.4400, -34.6330], [-58.4700, -34.6400]]),
  Via('Av. 9 de Julio', 1, [[-58.3800, -34.5930], [-58.3817, -34.6037], [-58.3835, -34.6180], [-58.3840, -34.6280]]),
  Via('Av. Callao', 1, [[-58.3930, -34.5880], [-58.3925, -34.6000], [-58.3930, -34.6110]]),
  Via('Av. Pueyrredón', 1, [[-58.4000, -34.5850], [-58.4030, -34.5990], [-58.4070, -34.6100], [-58.4100, -34.6220]]),
  Via('Av. Juan B. Justo', 1, [[-58.4290, -34.5800], [-58.4380, -34.5950], [-58.4460, -34.6090], [-58.4560, -34.6200], [-58.4750, -34.6290], [-58.5000, -34.6350]]),
  Via('Av. Triunvirato', 1, [[-58.4840, -34.5740], [-58.4700, -34.5780], [-58.4560, -34.5830], [-58.4470, -34.5930]]),
  Via('Av. Directorio', 1, [[-58.4250, -34.6320], [-58.4550, -34.6420], [-58.4850, -34.6520], [-58.5130, -34.6580]]),
  Via('Av. Sáenz', 1, [[-58.4000, -34.6370], [-58.4200, -34.6470], [-58.4400, -34.6530]]),
  Via('Av. Boedo', 1, [[-58.4170, -34.6030], [-58.4180, -34.6200], [-58.4190, -34.6340], [-58.4200, -34.6450]]),
  Via('Av. Paseo Colón', 1, [[-58.3700, -34.5950], [-58.3710, -34.6080], [-58.3720, -34.6200], [-58.3680, -34.6300]]),
  Via('Av. Lacarra', 1, [[-58.4800, -34.6500], [-58.4750, -34.6650], [-58.4720, -34.6800]]),
];

class Parque {
  final String n;
  final double lo, la, w, h;
  Parque(this.n, this.lo, this.la, this.w, this.h);
}

final parques = <Parque>[
  Parque('Bosques de Palermo', -58.4200, -34.5740, 2.4, 0.9),
  Parque('Reserva Ecológica', -58.3445, -34.6200, 1.8, 1.2),
  Parque('Parque Centenario', -58.4350, -34.6060, 0.5, 0.4),
  Parque('Parque Chacabuco', -58.4380, -34.6350, 0.6, 0.5),
  Parque('Parque Avellaneda', -58.4830, -34.6490, 1.0, 0.8),
  Parque('Parque Lezama', -58.3700, -34.6280, 0.4, 0.4),
  Parque('Parque Rivadavia', -58.4350, -34.6170, 0.5, 0.3),
  Parque('Parque Indoamericano', -58.4560, -34.6650, 1.1, 0.8),
  Parque('Parque de la Ciudad', -58.4780, -34.6770, 1.5, 1.2),
  Parque('Parque Saavedra', -58.4660, -34.5600, 0.5, 0.4),
  Parque('Parque Sarmiento', -58.4780, -34.5800, 0.8, 0.5),
  Parque('Ciudad Universitaria', -58.4520, -34.5380, 1.4, 0.4),
  Parque('Plaza San Martín', -58.3800, -34.5950, 0.3, 0.3),
  Parque('Plaza de Mayo', -58.3730, -34.6080, 0.25, 0.25),
  Parque('Parque Patricios', -58.4000, -34.6370, 0.4, 0.4),
  Parque('Parque Los Andes', -58.4560, -34.5890, 0.4, 0.4),
];

class Lugar {
  final String n;
  final double lo, la;
  final int pr;
  Lugar(this.n, this.lo, this.la, this.pr);
}

final barrios = <Lugar>[
  Lugar('Núñez', -58.4560, -34.5480, 1), Lugar('Belgrano', -58.4500, -34.5630, 0),
  Lugar('Colegiales', -58.4480, -34.5740, 1), Lugar('Palermo', -58.4300, -34.5880, 0),
  Lugar('Recoleta', -58.3980, -34.5880, 0), Lugar('Retiro', -58.3740, -34.5920, 0),
  Lugar('Microcentro', -58.3820, -34.6040, 1), Lugar('Puerto Madero', -58.3640, -34.6120, 0),
  Lugar('Monserrat', -58.3770, -34.6150, 2), Lugar('San Telmo', -58.3700, -34.6210, 1),
  Lugar('La Boca', -58.3630, -34.6350, 0), Lugar('Barracas', -58.3820, -34.6420, 1),
  Lugar('Constitución', -58.3850, -34.6260, 2), Lugar('Balvanera', -58.4050, -34.6080, 1),
  Lugar('Almagro', -58.4200, -34.6050, 1), Lugar('Boedo', -58.4180, -34.6230, 2),
  Lugar('Caballito', -58.4400, -34.6190, 0), Lugar('Flores', -58.4650, -34.6270, 0),
  Lugar('Villa Crespo', -58.4400, -34.5990, 2), Lugar('Chacarita', -58.4550, -34.5900, 2),
  Lugar('Villa Urquiza', -58.4700, -34.5730, 1), Lugar('Villa Devoto', -58.5000, -34.6020, 1),
  Lugar('Liniers', -58.5200, -34.6350, 1), Lugar('Mataderos', -58.5000, -34.6580, 1),
  Lugar('Villa Lugano', -58.4700, -34.6800, 0), Lugar('Parque Chacabuco', -58.4380, -34.6350, 2),
  Lugar('Nueva Pompeya', -58.4200, -34.6500, 2), Lugar('Villa Soldati', -58.4560, -34.6700, 2),
  Lugar('Villa del Parque', -58.4950, -34.6050, 2), Lugar('Floresta', -58.4900, -34.6300, 2),
  Lugar('Saavedra', -58.4650, -34.5540, 2), Lugar('Paternal', -58.4690, -34.5980, 2),
];

final regiones = <Lugar>[
  Lugar('VICENTE LÓPEZ', -58.4950, -34.5300, 0), Lugar('SAN MARTÍN', -58.5350, -34.5800, 0),
  Lugar('TRES DE FEBRERO', -58.5380, -34.6150, 0), Lugar('LA MATANZA', -58.5350, -34.6700, 0),
  Lugar('LANÚS', -58.4200, -34.6950, 0), Lugar('AVELLANEDA', -58.3900, -34.6700, 0),
];

abstract class Usuario {
  String nombre;
  String email;
  String telefono;
  Usuario(this.nombre, this.email, this.telefono);
  String conectar();
}

class Pasajero extends Usuario {
  int id;
  String doc;
  Pasajero(this.id, this.doc, String n, String e, String t) : super(n, e, t);
  @override
  String conectar() => 'Pasajero $nombre conectado';
}

class Piloto extends Usuario {
  int id;
  String lic;
  double nota;
  int viajes;
  Piloto(this.id, this.lic, this.nota, this.viajes, String n, String e, String t) : super(n, e, t);
  @override
  String conectar() => 'Piloto $nombre conectado';
}

class TipoAeronave {
  String modelo;
  int cap;
  double factor;
  double vel;
  double maxV;
  bool ifr;
  TipoAeronave(this.modelo, this.cap, this.factor, this.vel, this.maxV, this.ifr);
}

class SistemaSeguridad {
  String cert;
  String estado;
  SistemaSeguridad(this.cert, this.estado);
}

class Aeronave {
  String mat;
  int horas;
  TipoAeronave tipo;
  SistemaSeguridad seg;
  Aeronave(this.mat, this.horas, this.tipo, this.seg);
}

class RutaVuelo {
  String codigo;
  String destino;
  int min;
  RutaVuelo(this.codigo, this.destino, this.min);
}

class EstadisticasTerminal {
  int vuelos;
  int pasajeros;
  EstadisticasTerminal(this.vuelos, this.pasajeros);
}

class Terminal {
  String nombre;
  String ubic;
  double lo;
  double la;
  EstadisticasTerminal est;
  late Offset p = geo(lo, la);
  RutaVuelo ruta = RutaVuelo('', '', 0);
  double dem = 0.3;
  int cola = 1;
  Terminal(this.nombre, this.ubic, this.lo, this.la, this.est);
}

abstract class MetodoPago {
  String trx = '';
  double monto = 0;
  String nro;
  MetodoPago(this.nro);
  String get tipo;
  String get detalle;
  String get masc => '•••• ${nro.substring(nro.length - 4)}';
  String procesar();
}

class TarjetaCredito extends MetodoPago {
  String titular;
  TarjetaCredito(super.n, this.titular);
  @override
  String get tipo => 'Crédito';
  @override
  String get detalle => titular;
  @override
  String procesar() => 'Procesando pago con tarjeta de crédito';
}

class TarjetaDebito extends MetodoPago {
  String banco;
  TarjetaDebito(super.n, this.banco);
  @override
  String get tipo => 'Débito';
  @override
  String get detalle => banco;
  @override
  String procesar() => 'Procesando pago con tarjeta de débito';
}

class Recibo {
  String nro;
  String fecha;
  Recibo(this.nro, this.fecha);
}

class Pago {
  String id;
  double total;
  MetodoPago metodo;
  Recibo recibo;
  double propina = 0;
  Pago(this.id, this.total, this.metodo, this.recibo);
  double get cobro => total + propina;

  String realizar() {
    metodo.monto = total;
    metodo.trx = 'TRX-${id.substring(4)}';
    return metodo.procesar();
  }
}

enum Clima { sol, nublado, lluvia, viento, niebla, tormenta }

extension ClimaX on Clima {
  String get nom => const ['Soleado', 'Nublado', 'Lluvia', 'Ventoso', 'Niebla', 'Tormenta'][index];
  IconData get ic => const [Icons.wb_sunny, Icons.cloud, Icons.water_drop, Icons.air, Icons.blur_on, Icons.flash_on][index];
  double get extra => const [0.0, 0.05, 0.5, 0.2, 0.25, 0.6][index];
  double get vf => const [1.0, 1.0, 0.92, 0.8, 0.88, 0.7][index];
  Color get col => const [
        Color(0xFFF9A825), Color(0xFF78909C), Color(0xFF1E88E5),
        Color(0xFF26A69A), Color(0xFF90A4AE), Color(0xFF5E35B1),
      ][index];
}

enum Serv { estandar, compartido, premium }

extension ServX on Serv {
  String get nom => const ['Estándar', 'Compartido', 'Premium'][index];
  String get desc => const ['Vuelo directo', 'Compartí aeronave · −30%', 'Prioridad y lounge · +28%'][index];
  double get factor => const [1.0, 0.7, 1.28][index];
  int get extra => const [0, 6, -1][index];
  IconData get ic => const [Icons.flight, Icons.people, Icons.star][index];
}

class Promo {
  String cod;
  double pct;
  String txt;
  Promo(this.cod, this.pct, this.txt);
}

final promos = <Promo>[
  Promo('AERO20', 0.2, '20% OFF en tu primer vuelo'),
  Promo('VOLA10', 0.1, '10% OFF en tu vuelo'),
  Promo('LLUVIA15', 0.15, '15% OFF en días de lluvia'),
  Promo('TURISMO25', 0.25, '25% OFF en circuitos turísticos'),
];

class Alerta {
  IconData ic;
  String t;
  Color col;
  Alerta(this.ic, this.t, this.col);
}

class Cot {
  double km, base, din, tasa, desc, total, sg;
  int mins, llega, auto;
  Cot(this.km, this.base, this.din, this.tasa, this.desc, this.total, this.sg, this.mins, this.llega, this.auto);
}

class Viaje {
  Terminal o;
  Terminal d;
  RutaVuelo ruta;
  Aeronave ae;
  Piloto pl;
  Pago pago;
  Serv sv;
  Cot cot;
  int pts;
  Viaje(this.o, this.d, this.ruta, this.ae, this.pl, this.pago, this.sv, this.cot, this.pts);
}

class LugarTuristico {
  final String nombre;
  final String subtitulo;
  final String descripcion;
  final String terminalCercana;
  final String imagenUrl;
  final String codigoPromo;
  final double descuentoPct;

  LugarTuristico({
    required this.nombre,
    required this.subtitulo,
    required this.descripcion,
    required this.terminalCercana,
    required this.imagenUrl,
    required this.codigoPromo,
    required this.descuentoPct,
  });
}

final lugaresTuristicos = <LugarTuristico>[
  LugarTuristico(
    nombre: 'Teatro Colón',
    subtitulo: 'Joyas arquitectónicas y líricas',
    descripcion: 'Considerado uno de los mejores teatros de ópera del mundo por su acústica. Disfruta de un traslado aéreo directo evitando el tráfico.',
    terminalCercana: 'Terminal Centro',
    imagenUrl: 'assets/images/teatro.jpg',
    codigoPromo: 'TURISMO25',
    descuentoPct: 0.25,
  ),
  LugarTuristico(
    nombre: 'Caminito & La Boca',
    subtitulo: 'Color, historia y tango',
    descripcion: 'El icónico callejón museo con conventillos pintados. Viví la experiencia de sobrevolar el Riachuelo y aterrizar con vista panorámica.',
    terminalCercana: 'Terminal Sur',
    imagenUrl: 'assets/images/caminito.jpg',
    codigoPromo: 'TURISMO25',
    descuentoPct: 0.25,
  ),
  LugarTuristico(
    nombre: 'Puerto Madero & Puente de la Mujer',
    subtitulo: 'Modernidad y gastronomía',
    descripcion: 'El barrio más moderno de la ciudad, famoso por sus diques y el emblemático puente peatonal.',
    terminalCercana: 'Terminal Madero',
    imagenUrl: 'assets/images/puente.jpg',
    codigoPromo: 'TURISMO25',
    descuentoPct: 0.25,
  ),
  LugarTuristico(
    nombre: 'Bosques de Palermo & Rosedal',
    subtitulo: 'Naturaleza y lagos en la ciudad',
    descripcion: 'El pulmón verde más grande de Buenos Aires, ideal para pasear entre rosaledas y lagos artificiales.',
    terminalCercana: 'Terminal Palermo',
    imagenUrl: 'assets/images/palermo.jpg',
    codigoPromo: 'TURISMO25',
    descuentoPct: 0.25,
  ),
];

final _r = Random(7);

Terminal _t(String n, String u, double lo, double la) =>
    Terminal(n, u, lo, la, EstadisticasTerminal(30 + _r.nextInt(40), 120 + _r.nextInt(200)));

class Datos extends ChangeNotifier {
  final Pasajero pas = Pasajero(101, '12345678', 'Carlos', 'carlos@email.com', '1234567890');
  int puntos = 120;
  Promo? promo;

  final List<Terminal> terminales = [
    _t('Terminal Aeroparque', 'Costanera Norte', -58.4130, -34.5600),
    _t('Terminal Núñez', 'Núñez', -58.4560, -34.5430),
    _t('Terminal Belgrano', 'Belgrano', -58.4560, -34.5620),
    _t('Terminal Palermo', 'Palermo', -58.4290, -34.5880),
    _t('Terminal Recoleta', 'Recoleta', -58.3950, -34.5880),
    _t('Terminal Retiro', 'Retiro', -58.3730, -34.5930),
    _t('Terminal Centro', 'Buenos Aires Centro', -58.3810, -34.6040),
    _t('Terminal Madero', 'Puerto Madero', -58.3630, -34.6100),
    _t('Terminal Once', 'Balvanera', -58.4060, -34.6090),
    _t('Terminal Caballito', 'Caballito', -58.4400, -34.6190),
    _t('Terminal San Telmo', 'San Telmo', -58.3720, -34.6210),
    _t('Terminal Costanera Sur', 'Reserva Ecológica', -58.3560, -34.6240),
    _t('Terminal Sur', 'Buenos Aires Sur', -58.3680, -34.6310),
    _t('Terminal Barracas', 'Barracas', -58.3820, -34.6420),
    _t('Terminal Villa Urquiza', 'Villa Urquiza', -58.4720, -34.5740),
    _t('Terminal Flores', 'Flores', -58.4650, -34.6280),
    _t('Terminal Liniers', 'Liniers', -58.5180, -34.6370),
    _t('Terminal Devoto', 'Villa Devoto', -58.5050, -34.6020),
    _t('Terminal Mataderos', 'Mataderos', -58.5000, -34.6560),
    _t('Terminal Lugano', 'Villa Lugano', -58.4700, -34.6800),
  ];

  final List<Aeronave> flota = [
    Aeronave('N12345', 500, TipoAeronave('Joby S4', 4, 1.0, 200, 45, true), SistemaSeguridad('FAA-2024', 'Activa')),
    Aeronave('N54321', 350, TipoAeronave('Lilium Jet', 6, 1.35, 250, 55, true), SistemaSeguridad('EASA-2024', 'Revisada')),
    Aeronave('N77777', 120, TipoAeronave('Volocopter VX', 2, 0.8, 90, 30, false), SistemaSeguridad('EASA-2025', 'Activa')),
    Aeronave('N88888', 210, TipoAeronave('Archer Midnight', 4, 1.15, 240, 40, true), SistemaSeguridad('FAA-2025', 'Activa')),
  ];

  final List<Piloto> pilotos = [
    Piloto(201, 'LIC-2024-ABC', 4.9, 1280, 'Juan', 'juan@email.com', '9876543210'),
    Piloto(202, 'LIC-2024-DEF', 4.8, 940, 'Sofía', 'sofia@email.com', '1122334455'),
    Piloto(203, 'LIC-2025-GHI', 4.7, 610, 'Mateo', 'mateo@email.com', '5566778899'),
    Piloto(204, 'LIC-2025-JKL', 4.9, 1530, 'Valentina', 'vale@email.com', '1166778899'),
  ];

  final List<MetodoPago> metodos = [
    TarjetaCredito('4111111111111111', 'Carlos Lopez'),
    TarjetaDebito('5555555555554444', 'Banco Argentino'),
  ];

  final List<Viaje> historial = [];

  Datos() {
    final cen = terminales.firstWhere((t) => t.nombre == 'Terminal Centro');
    final aer = terminales.first;
    var n = 1;
    for (final t in terminales) {
      final d = t == cen ? aer : cen;
      t.ruta = RutaVuelo('T-${n.toString().padLeft(3, '0')}', d.ubic, 5 + (dkm(t.p, d.p) / 200 * 60).ceil());
      n++;
    }
  }

  String get nivel => puntos < 500 ? 'Bronce' : (puntos < 1500 ? 'Plata' : 'Oro');

  void agregar(Viaje v) {
    historial.add(v);
    v.o.est.vuelos++;
    v.o.est.pasajeros++;
    puntos += v.pts;
    promo = null;
    notifyListeners();
  }

  void addMetodo(MetodoPago m) {
    metodos.add(m);
    notifyListeners();
  }

  void setPromo(Promo? p) {
    promo = p;
    notifyListeners();
  }
}

final datos = Datos();

Color nivCol(double v) => v < 0.3
    ? const Color(0xFF34A853)
    : (v < 0.55 ? const Color(0xFFFBBC04) : (v < 0.8 ? const Color(0xFFEA4335) : const Color(0xFF8E1B1B)));

class Sim extends ChangeNotifier {
  final List<Terminal> ts;
  double hora = ahoraH();
  bool auto = true;
  bool verTr = true;
  Clima? fijo;
  int tk = 0;
  final Random r = Random();
  late final List<List<double>> niv = vias.map((v) => List<double>.filled(v.p.length - 1, 0.0)).toList();
  List<List<int>> inc = [];
  Timer? tm;

  Sim(this.ts) {
    recalcular();
    tm = Timer.periodic(const Duration(seconds: 3), (_) {
      tk++;
      if (auto) hora = ahoraH();
      recalcular();
      notifyListeners();
    });
  }

  bool get noche => hora < 6.5 || hora >= 20;

  double get base {
    final h = hora;
    final w = DateTime.now().weekday >= 6 ? 0.7 : 1.0;
    final v = 0.12 +
        0.78 * max(exp(-(h - 8.8) * (h - 8.8) / 3.2), exp(-(h - 18.4) * (h - 18.4) / 4.5)) +
        0.16 * exp(-(h - 13.0) * (h - 13.0) / 3.0);
    return cl(v * w + clima.extra * 0.12);
  }

  String get trNom => base < 0.3 ? 'Fluido' : (base < 0.55 ? 'Moderado' : (base < 0.78 ? 'Denso' : 'Muy denso'));
  Color get trCol => nivCol(base);

  Clima climaPara(double h) {
    final n = DateTime.now();
    final dia = n.difference(DateTime(n.year)).inDays;
    final g = Random(dia * 31 + (h ~/ 3)).nextDouble();
    if (g < 0.42) return Clima.sol;
    if (g < 0.68) return Clima.nublado;
    if (g < 0.8) return Clima.lluvia;
    if (g < 0.88) return Clima.viento;
    if (g < 0.94) return h < 11 ? Clima.niebla : Clima.nublado;
    return Clima.tormenta;
  }

  Clima get clima => fijo ?? climaPara(hora);

  double tempH(double h, Clima k) =>
      16 + 7 * sin((h - 9) * pi / 12) + (k == Clima.lluvia ? -3 : (k == Clima.sol ? 2 : (k == Clima.tormenta ? -2 : 0)));

  double get temp => tempH(hora, clima);

  double get viento {
    final b = const [9.0, 14.0, 22.0, 40.0, 5.0, 52.0][clima.index];
    return b + Random(hora.floor() * 7 + clima.index).nextDouble() * 6;
  }

  int get cercanos => clima == Clima.tormenta ? 0 : max(3, 12 - (base * 5).round());

  String? bloqueo(Aeronave a) {
    if (clima == Clima.tormenta) return 'Suspendido por tormenta';
    if (viento > a.tipo.maxV) return 'Viento de ${viento.round()} km/h sobre el límite';
    if (clima == Clima.niebla && !a.tipo.ifr) return 'Sin visibilidad para vuelo visual';
    return null;
  }

  double surge(Terminal t) =>
      ((1 + base * 0.6 + clima.extra * 0.8 + max(0.0, t.dem - 0.35) * 0.8) * 10).round() / 10;

  String motivo(Terminal t) =>
      clima.extra >= 0.4 ? 'clima adverso' : (base > 0.6 ? 'alto tráfico terrestre' : 'alta demanda en la terminal');

  int tAuto(double km) => (km * 1.35 / (36 * (1 - 0.6 * base)) * 60).round() + 4;
  int tAire(double km, double v) => 5 + (km / (v * clima.vf) * 60).ceil();

  Cot cotizar(Terminal o, Terminal d, Aeronave a, Serv s, Promo? pr) {
    final km = dkm(o.p, d.p);
    final mins = tAire(km, a.tipo.vel) + s.extra;
    final sg = surge(o);
    final b = (1800 + km * 1500 + mins * 90) * a.tipo.factor * s.factor;
    final din = b * (sg - 1);
    final tasa = 650.0 + (km > 10 ? 250 : 0);
    final sub = b + din;
    final desc = pr == null ? 0.0 : sub * pr.pct;
    final tot = max(4800.0, ((sub - desc + tasa) / 10).round() * 10.0);
    final llega = 2 + o.cola + a.horas % 3 + (s == Serv.compartido ? 3 : 0);
    return Cot(km, b, din, tasa, desc, tot, sg, mins, llega, tAuto(km));
  }

  List<Alerta> get alertas {
    final l = <Alerta>[];
    final c = clima;
    if (c == Clima.tormenta) {
      l.add(Alerta(Icons.flash_on, 'Tormenta eléctrica: vuelos suspendidos', const Color(0xFFD32F2F)));
    } else if (viento > 30) {
      l.add(Alerta(Icons.air, 'Viento de ${viento.round()} km/h: algunas aeronaves no están disponibles', const Color(0xFFEF6C00)));
    }
    if (c == Clima.lluvia) {
      l.add(Alerta(Icons.water_drop, 'Lluvia: vuelos más lentos y tarifa dinámica. Probá LLUVIA15', const Color(0xFF1E88E5)));
    }
    if (c == Clima.niebla) {
      l.add(Alerta(Icons.blur_on, 'Niebla: solo operan aeronaves por instrumentos', const Color(0xFF607D8B)));
    }
    if (base > 0.75) {
      l.add(Alerta(Icons.traffic, 'Hora pico: tráfico muy denso en las avenidas', const Color(0xFFC62828)));
    }
    if (inc.isNotEmpty) {
      l.add(Alerta(Icons.warning_amber, '${inc.length} incidente${inc.length > 1 ? 's' : ''} vial${inc.length > 1 ? 'es' : ''} en la ciudad', const Color(0xFF6D4C41)));
    }
    if (l.isEmpty) l.add(Alerta(Icons.check_circle, 'Condiciones ideales para volar', verde));
    return l;
  }

  void recalcular() {
    final b = base;
    final cm = clima;
    if (tk % 14 == 0) {
      inc = [];
      final n = 1 + r.nextInt(3);
      for (var k = 0; k < n; k++) {
        final i = r.nextInt(vias.length);
        inc.add([i, r.nextInt(vias[i].p.length - 1)]);
      }
    }
    for (var i = 0; i < niv.length; i++) {
      final k = vias[i].t == 2 ? 1.08 : 1.0;
      for (var j = 0; j < niv[i].length; j++) {
        final w = sin(tk * 0.45 + i * 1.7 + j * 0.9) * 0.22 + (r.nextDouble() - 0.5) * 0.1;
        niv[i][j] = cl(b * k + w + (cm == Clima.lluvia ? 0.08 : 0.0));
      }
    }
    for (final x in inc) {
      niv[x[0]][x[1]] = 0.96;
    }
    for (var i = 0; i < ts.length; i++) {
      final t = ts[i];
      t.dem = cl(b * 0.6 + sin(tk * 0.3 + i) * 0.18 + 0.2 + r.nextDouble() * 0.08);
      t.cola = (t.dem * 6).round();
    }
  }

  void setAuto(bool v) {
    auto = v;
    if (v) hora = ahoraH();
    recalcular();
    notifyListeners();
  }

  void setHora(double h) {
    hora = h;
    recalcular();
    notifyListeners();
  }

  void setClima(Clima? k) {
    fijo = k;
    recalcular();
    notifyListeners();
  }

  void setTr(bool v) {
    verTr = v;
    notifyListeners();
  }
}

final sim = Sim(datos.terminales);

class Pedido {
  final Terminal? d;
  final Serv? s;
  Pedido(this.d, this.s);
}

final pedido = ValueNotifier<Pedido?>(null);
final navTab = ValueNotifier<int>(0);
final tema = ValueNotifier<ThemeMode>(ThemeMode.system);

Terminal term(String n) => datos.terminales.firstWhere((t) => t.nombre == n);

String money(num v) {
  final s = v.round().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return '\$$b';
}

String fmt(DateTime n) {
  String p(int x) => x.toString().padLeft(2, '0');
  return '${p(n.day)}/${p(n.month)}/${n.year}  ${p(n.hour)}:${p(n.minute)}';
}

String fmtH(double h) {
  final m = ((h - h.floor()) * 60).floor();
  return '${h.floor().toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

Color gris(BuildContext c) =>
    Theme.of(c).brightness == Brightness.dark ? const Color(0xFF242424) : const Color(0xFFF2F2F2);

void snack(BuildContext c, String t) => ScaffoldMessenger.of(c).showSnackBar(SnackBar(content: Text(t)));

String? promoMsg(Promo p) {
  if (p.cod == 'AERO20' && datos.historial.isNotEmpty) return 'AERO20 es solo para tu primer vuelo';
  if (p.cod == 'LLUVIA15' && sim.clima != Clima.lluvia && sim.clima != Clima.tormenta) {
    return 'LLUVIA15 solo vale en días de lluvia';
  }
  return null;
}

Future<void> dialogPromo(BuildContext c) async {
  final tc = TextEditingController();
  final r = await showDialog<String>(
    context: c,
    builder: (x) => AlertDialog(
      title: const Text('Código promocional'),
      content: TextField(
        controller: tc,
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(hintText: 'Ej: AERO20', border: OutlineInputBorder()),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(x), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.pop(x, tc.text.trim().toUpperCase()), child: const Text('Aplicar')),
      ],
    ),
  );
  if (r == null || r.isEmpty || !c.mounted) return;
  Promo? p;
  for (final x in promos) {
    if (x.cod == r) p = x;
  }
  if (p == null) {
    snack(c, 'El código no existe');
    return;
  }
  final m = promoMsg(p);
  if (m != null) {
    snack(c, m);
    return;
  }
  datos.setPromo(p);
  snack(c, 'Código ${p.cod} aplicado: ${p.txt}');
}

void abrirSim(BuildContext c) {
  showModalBottomSheet(
    context: c,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (x) => ListenableBuilder(
      listenable: sim,
      builder: (x, _) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Simulador de ciudad', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: sim.auto,
                onChanged: sim.setAuto,
                title: const Text('Hora real'),
                subtitle: const Text('Usar la hora del dispositivo'),
              ),
              Text('Hora simulada: ${fmtH(sim.hora)}  ·  Tráfico ${sim.trNom.toLowerCase()}'),
              Slider(
                value: sim.hora,
                min: 0,
                max: 24,
                divisions: 96,
                onChanged: sim.auto ? null : sim.setHora,
              ),
              const Text('Clima'),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(label: const Text('Auto'), selected: sim.fijo == null, onSelected: (_) => sim.setClima(null)),
                  for (final k in Clima.values)
                    ChoiceChip(
                      avatar: Icon(k.ic, size: 18),
                      label: Text(k.nom),
                      selected: sim.fijo == k,
                      onSelected: (_) => sim.setClima(k),
                    ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                value: sim.verTr,
                onChanged: sim.setTr,
                title: const Text('Tráfico en el mapa'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget boton(String t, VoidCallback? f) => SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: f,
        style: FilledButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );

Widget botonSec(String t, VoidCallback f) => SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: f,
        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        child: Text(t),
      ),
    );

Widget tile(BuildContext c, IconData ic, String t, String s, {VoidCallback? f, Widget? tr}) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: gris(c),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: f,
          leading: Icon(ic),
          title: Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: s.isEmpty ? null : Text(s),
          trailing: tr ?? (f != null ? const Icon(Icons.chevron_right) : null),
        ),
      ),
    );

Widget linea(String a, String b, [bool n = false]) {
  final st = TextStyle(fontWeight: n ? FontWeight.bold : FontWeight.normal, fontSize: n ? 18 : 14);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(a, style: st),
        const SizedBox(width: 12),
        Flexible(child: Text(b, style: st, textAlign: TextAlign.end)),
      ],
    ),
  );
}

Widget chipSg(double sg) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: sg >= 1.6 ? const Color(0xFFD32F2F) : const Color(0xFFEF6C00),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('x${sg.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
    );

Widget stat(IconData ic, String v, String t) => Expanded(
      child: Column(
        children: [
          Icon(ic, size: 20),
          const SizedBox(height: 2),
          Text(v, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(t, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );

Widget pill(BuildContext c, IconData ic, String t, {Color? ci}) => Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(c).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ic, size: 16, color: ci),
          const SizedBox(width: 6),
          Text(t, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );

Widget fab(BuildContext c, IconData ic, VoidCallback f) => Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Material(
        color: Theme.of(c).colorScheme.surface,
        elevation: 3,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: f,
          child: Padding(padding: const EdgeInsets.all(11), child: Icon(ic, size: 22)),
        ),
      ),
    );

Widget alertaW(Alerta a) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: a.col,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
      ),
      child: Row(
        children: [
          Icon(a.ic, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(a.t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ],
      ),
    );

Widget ticket(BuildContext c, Viaje v) {
  final g = v.pago;
  final k = v.cot;
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: gris(c), borderRadius: BorderRadius.circular(12)),
    child: Column(
      children: [
        linea('Recibo', g.recibo.nro),
        linea('Fecha', g.recibo.fecha),
        linea('Pago', g.id),
        linea('Ruta', '${v.o.nombre} → ${v.d.nombre}'),
        linea('Distancia', '${k.km.toStringAsFixed(1)} km · ${k.mins} min'),
        linea('Aeronave', '${v.ae.tipo.modelo} · ${v.ae.mat}'),
        linea('Servicio', v.sv.nom),
        linea('Piloto', v.pl.nombre),
        linea('Método', '${g.metodo.tipo} ${g.metodo.masc}'),
        const Divider(),
        linea('Tarifa base', money(k.base)),
        if (k.din > 1) linea('Tarifa dinámica x${k.sg.toStringAsFixed(1)}', money(k.din)),
        linea('Tasa de servicio', money(k.tasa)),
        if (k.desc > 0) linea('Descuento', '-${money(k.desc)}'),
        if (g.propina > 0) linea('Propina', money(g.propina)),
        const Divider(),
        linea('Total', money(g.cobro), true),
        linea('AeroPuntos', '+${v.pts}'),
      ],
    ),
  );
}

void txt(Canvas c, String s, Offset p, double sz, Color col, Color halo,
    {bool b = false, bool it = false, double rot = 0}) {
  TextPainter mk(Paint? fg) => TextPainter(
        text: TextSpan(
          text: s,
          style: TextStyle(
            fontSize: sz,
            fontWeight: b ? FontWeight.w700 : FontWeight.w500,
            fontStyle: it ? FontStyle.italic : FontStyle.normal,
            color: fg == null ? col : null,
            foreground: fg,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
  final a = mk(Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = sz * 0.28
    ..strokeJoin = StrokeJoin.round
    ..color = halo);
  final f = mk(null);
  c.save();
  c.translate(p.dx, p.dy);
  if (rot != 0) c.rotate(rot);
  final o = Offset(-f.width / 2, -f.height / 2);
  a.paint(c, o);
  f.paint(c, o);
  c.restore();
}

Path arco(Offset a, Offset b) {
  final m = (a + b) / 2;
  final v = b - a;
  final k = m + Offset(-v.dy, v.dx) * 0.18;
  return Path()
    ..moveTo(a.dx, a.dy)
    ..quadraticBezierTo(k.dx, k.dy, b.dx, b.dy);
}

void avion(Canvas c, Offset p, double ang, double r) {
  c.drawCircle(p, r * 1.18, Paint()..color = verde);
  c.drawCircle(p, r, Paint()..color = Colors.black);
  final ic = Icons.flight;
  final tp = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(ic.codePoint),
      style: TextStyle(fontSize: r * 1.35, fontFamily: ic.fontFamily, package: ic.fontPackage, color: Colors.white),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  c.save();
  c.translate(p.dx, p.dy);
  c.rotate(ang);
  tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
  c.restore();
}

void pinta(Canvas c, Offset p, Color col, double u, String lb, Color fg, Color halo) {
  final r = 13 * u;
  final h = Offset(p.dx, p.dy - 24 * u);
  final path = Path()
    ..addOval(Rect.fromCircle(center: h, radius: r))
    ..moveTo(h.dx - r * 0.75, h.dy + r * 0.66)
    ..lineTo(p.dx, p.dy)
    ..lineTo(h.dx + r * 0.75, h.dy + r * 0.66)
    ..close();
  c.drawPath(path, Paint()..color = col);
  c.drawCircle(h, r * 0.38, Paint()..color = Colors.white);
  txt(c, lb, Offset(p.dx, p.dy + 12 * u), 11.5 * u, fg, halo, b: true);
}

class Base extends CustomPainter {
  final bool dk;
  final ValueNotifier<double> esc;
  Base(this.dk, this.esc) : super(repaint: esc);

  @override
  void paint(Canvas c, Size s) {
    final sc = esc.value;
    final u = 1 / sc;
    final tx = Color(dk ? 0xFFAAB2BD : 0xFF5F6368);
    final halo = Color(dk ? 0xFF1B2027 : 0xFFFFFFFF);

    c.drawRect(Offset.zero & s, Paint()..color = Color(dk ? 0xFF1B2027 : 0xFFE6E4DE));
    c.drawPath(pAgua, Paint()..color = Color(dk ? 0xFF0F2A44 : 0xFFA9D3F2));
    c.drawPath(pCaba, Paint()..color = Color(dk ? 0xFF262D36 : 0xFFF4F2ED));

    c.save();
    c.clipPath(pCaba);

    if (sc > 0.4) {
      final g = Path();
      final paso = sc > 0.9 ? 8.0 : 16.0;
      for (var x = 0.0; x < ancho; x += paso) {
        g.moveTo(x, 0);
        g.lineTo(x, alto);
      }
      for (var y = 0.0; y < alto; y += paso) {
        g.moveTo(0, y);
        g.lineTo(ancho, y);
      }
      c.drawPath(
        g,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = max(0.8, 1.2 * u)
          ..color = Color(dk ? 0xFF28303A : 0xFFECEAE4),
      );
    }

    for (final k in parques) {
      final r = Rect.fromCenter(center: geo(k.lo, k.la), width: k.w * kpx, height: k.h * kpx);
      c.drawRRect(
        RRect.fromRectAndRadius(r, Radius.circular(min(k.w, k.h) * kpx * 0.35)),
        Paint()..color = Color(dk ? 0xFF1F3A2B : 0xFFC9E6BE),
      );
    }
    c.restore();

    c.drawPath(
      pRia,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..strokeWidth = max(8.0, 3 * u)
        ..color = Color(dk ? 0xFF0F2A44 : 0xFFA9D3F2),
    );

    final aw = max(9.0, 3.2 * u);
    final cas = Color(dk ? 0xFF2E3640 : 0xFFD3D0C8);
    final fil = Color(dk ? 0xFF48525F : 0xFFFFFFFF);
    final casA = Color(dk ? 0xFF6B5320 : 0xFFE5A83A);
    final filA = Color(dk ? 0xFF9A7A2E : 0xFFFBCB6B);

    Paint trazo(double w, Color col) => Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = w
      ..color = col;

    final paths = [for (final v in vias) poli(v.p, false)];
    for (var i = 0; i < vias.length; i++) {
      c.drawPath(paths[i], trazo(vias[i].t == 2 ? aw * 1.35 + 3 : aw + 3, vias[i].t == 2 ? casA : cas));
    }
    for (var i = 0; i < vias.length; i++) {
      c.drawPath(paths[i], trazo(vias[i].t == 2 ? aw * 1.35 : aw, vias[i].t == 2 ? filA : fil));
    }

    for (final k in regiones) {
      txt(c, k.n, geo(k.lo, k.la), 12 * u, Color(dk ? 0xFF6B7683 : 0xFF9AA0A6), halo, b: true);
    }
    txt(c, 'Río de la Plata', geo(-58.3420, -34.5700), 15 * u, Color(dk ? 0xFF6FA8DC : 0xFF4A90C4), const Color(0x00000000), it: true);

    if (sc > 0.45) {
      txt(c, 'Riachuelo', geo(-58.3980, -34.6560), 10.5 * u, Color(dk ? 0xFF6FA8DC : 0xFF4A90C4), const Color(0x00000000), it: true);
    }

    for (final k in barrios) {
      final ok = (k.pr == 0 && sc >= 0.2) || (k.pr == 1 && sc >= 0.34) || (k.pr == 2 && sc >= 0.6);
      if (ok) txt(c, k.n, geo(k.lo, k.la), (k.pr == 0 ? 12.5 : 11) * u, tx, halo, b: k.pr == 0);
    }

    if (sc > 0.65) {
      for (final k in parques) {
        txt(c, k.n, geo(k.lo, k.la), 10 * u, Color(dk ? 0xFF7FB88A : 0xFF3C7A3C), halo);
      }
    }

    if (sc > 0.45) {
      for (final v in vias) {
        if (v.q.length < 2) continue;
        final j = (v.q.length - 2) ~/ 2;
        final a = v.q[j];
        final b = v.q[j + 1];
        var ang = atan2(b.dy - a.dy, b.dx - a.dx);
        if (ang > pi / 2) ang -= pi;
        if (ang < -pi / 2) ang += pi;

        final fontSize = (v.t == 2 ? 11.0 : 9.5) * u;
        txt(
          c,
          v.n,
          (a + b) / 2,
          fontSize,
          v.t == 2 ? (dk ? const Color(0xFFFFD54F) : const Color(0xFFB78103)) : tx,
          Color(dk ? 0xFF1B2027 : 0xFFFFFFFF),
          b: v.t == 2,
          rot: ang,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant Base o) => o.dk != dk;
}

class Din extends CustomPainter {
  final Sim sm;
  final List<Terminal> ts;
  final Terminal? o;
  final Terminal? d;
  final double t;
  final int fase;
  final Offset ps;
  final bool dk;
  final ValueNotifier<double> esc;
  final AnimationController rep;
  Din(this.sm, this.ts, this.o, this.d, this.t, this.fase, this.ps, this.dk, this.esc, this.rep)
      : super(repaint: Listenable.merge([esc, rep, sm]));

  @override
  void paint(Canvas c, Size s) {
    final sc = esc.value;
    final u = 1 / sc;
    final fg = dk ? Colors.white : const Color(0xFF202124);
    final halo = dk ? const Color(0xFF1B2027) : Colors.white;

    if (sm.verTr) {
      final pt = Paint()..strokeCap = StrokeCap.round;
      final tw = max(5.0, 2.4 * u);
      for (var i = 0; i < vias.length; i++) {
        final v = vias[i];
        pt.strokeWidth = v.t == 2 ? tw + 2 : tw;
        for (var j = 0; j < v.q.length - 1; j++) {
          pt.color = nivCol(sm.niv[i][j]);
          c.drawLine(v.q[j], v.q[j + 1], pt);
        }
      }
      for (final x in sm.inc) {
        final v = vias[x[0]];
        final m = (v.q[x[1]] + v.q[x[1] + 1]) / 2;
        c.drawCircle(m, 10 * u, Paint()..color = Colors.white);
        c.drawCircle(m, 8 * u, Paint()..color = const Color(0xFFD32F2F));
        txt(c, '!', m, 11 * u, Colors.white, const Color(0x00000000), b: true);
      }
    }

    final oo = o;
    final dd = d;
    if (oo != null && dd != null) {
      final pth = arco(oo.p, dd.p);
      c.drawPath(
        pth,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 9 * u
          ..strokeCap = StrokeCap.round
          ..color = Colors.white,
      );
      c.drawPath(
        pth,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5.5 * u
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xFF4285F4),
      );
      if (fase == 2 || fase == 3) {
        final m = pth.computeMetrics().first;
        c.drawPath(
          m.extractPath(0, m.length * (fase == 3 ? 1.0 : t)),
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5.5 * u
            ..strokeCap = StrokeCap.round
            ..color = verde,
        );
      }
    }

    if (sm.clima != Clima.tormenta) {
      final ic = Icons.flight;
      final tp = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(ic.codePoint),
          style: TextStyle(
            fontSize: 17 * u,
            fontFamily: ic.fontFamily,
            package: ic.fontPackage,
            color: dk ? const Color(0xFFBDC1C6) : const Color(0xFF3C4043),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      for (var k = 0; k < sm.cercanos; k++) {
        final tm = ts[(k * 5 + 3) % ts.length];
        final dir = k.isEven ? 1.0 : -1.0;
        final ph = rep.value * 2 * pi * (1 + k % 3) * dir + k;
        final p = tm.p + Offset(cos(ph), sin(ph)) * (40.0 + (k % 4) * 28);
        c.save();
        c.translate(p.dx, p.dy);
        c.rotate(k.isEven ? ph + pi : ph);
        tp.paint(c, Offset(-tp.width / 2, -tp.height / 2));
        c.restore();
      }
    }

    final pu = 1 + 0.5 * sin(rep.value * 2 * pi * 20);
    c.drawCircle(yo, 16 * u * pu, Paint()..color = const Color(0x334285F4));
    c.drawCircle(yo, 8 * u, Paint()..color = Colors.white);
    c.drawCircle(yo, 6 * u, Paint()..color = const Color(0xFF4285F4));

    for (final x in ts) {
      if (x == oo || x == dd) continue;
      final p = x.p;
      c.drawCircle(p, 7.5 * u, Paint()..color = dk ? const Color(0xFF1B2027) : Colors.white);
      c.drawCircle(
        p,
        7.5 * u,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4 * u
          ..color = dk ? const Color(0xFF9AA0A6) : const Color(0xFF5F6368),
      );
      c.drawCircle(p, 2.6 * u, Paint()..color = dk ? const Color(0xFF9AA0A6) : const Color(0xFF5F6368));
      if (sc > 0.5) txt(c, x.nombre.replaceFirst('Terminal ', ''), p + Offset(0, 15 * u), 10.5 * u, fg, halo, b: true);
      final sg = sm.surge(x);
      if (sg >= 1.3 && sc > 0.3) {
        final r = RRect.fromRectAndRadius(
          Rect.fromCenter(center: p + Offset(0, -17 * u), width: 30 * u, height: 14 * u),
          Radius.circular(7 * u),
        );
        c.drawRRect(r, Paint()..color = sg >= 1.6 ? const Color(0xFFD32F2F) : const Color(0xFFEF6C00));
        txt(c, 'x${sg.toStringAsFixed(1)}', p + Offset(0, -17 * u), 9 * u, Colors.white, const Color(0x00000000), b: true);
      }
    }

    if (oo != null) pinta(c, oo.p, verde, u, oo.nombre.replaceFirst('Terminal ', ''), fg, halo);
    if (dd != null) pinta(c, dd.p, dk ? Colors.white : Colors.black, u, dd.nombre.replaceFirst('Terminal ', ''), fg, halo);

    if (fase == 1 && oo != null) {
      final e = Curves.easeInOut.transform(t);
      final p = Offset.lerp(ps, oo.p, e)!;
      final v = oo.p - ps;
      c.drawLine(
        ps,
        oo.p,
        Paint()
          ..color = const Color(0x884285F4)
          ..strokeWidth = 3 * u,
      );
      avion(c, p, atan2(v.dy, v.dx) + pi / 2, 16 * u);
    } else if ((fase == 2 || fase == 3) && oo != null && dd != null) {
      final m = arco(oo.p, dd.p).computeMetrics().first;
      final tg = m.getTangentForOffset(m.length * (fase == 3 ? 1.0 : t));
      if (tg != null) avion(c, tg.position, atan2(tg.vector.dy, tg.vector.dx) + pi / 2, 16 * u);
    }
  }

  @override
  bool shouldRepaint(covariant Din o) => true;
}

class Clim extends CustomPainter {
  final Clima k;
  final Animation<double> rep;
  Clim(this.k, this.rep) : super(repaint: rep);

  @override
  void paint(Canvas c, Size s) {
    final t = rep.value;
    if (k == Clima.lluvia || k == Clima.tormenta) {
      final n = k == Clima.tormenta ? 140 : 80;
      final p = Paint()
        ..color = const Color(0x99B3D4F5)
        ..strokeWidth = 1.4;
      for (var i = 0; i < n; i++) {
        final x = ((i * 97) % 211) / 211 * s.width;
        final y = ((((i * 53) % 101) / 101) + t * 60) % 1.0 * s.height;
        c.drawLine(Offset(x, y), Offset(x - 5, y + 16), p);
      }
      c.drawRect(Offset.zero & s, Paint()..color = Color(k == Clima.tormenta ? 0x40102040 : 0x1A2040A0));
      if (k == Clima.tormenta && (t * 40).floor() % 7 == 0 && (t * 40) % 1 < 0.25) {
        c.drawRect(Offset.zero & s, Paint()..color = const Color(0x55FFFFFF));
      }
    } else if (k == Clima.niebla) {
      c.drawRect(Offset.zero & s, Paint()..color = const Color(0x55FFFFFF));
    } else if (k == Clima.nublado) {
      c.drawRect(Offset.zero & s, Paint()..color = const Color(0x14455A64));
    } else if (k == Clima.viento) {
      final p = Paint()
        ..color = const Color(0x55FFFFFF)
        ..strokeWidth = 1.6;
      for (var i = 0; i < 14; i++) {
        final y = ((i * 71) % 97) / 97 * s.height;
        final x = ((((i * 37) % 53) / 53) + t * 25) % 1.0 * s.width;
        c.drawLine(Offset(x, y), Offset(x + 40, y), p);
      }
    }
  }

  @override
  bool shouldRepaint(covariant Clim o) => o.k != k;
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext c) => ValueListenableBuilder<ThemeMode>(
        valueListenable: tema,
        builder: (c, m, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'AeroTaxi',
          themeMode: m,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
                primary: Colors.black, onPrimary: Colors.white, secondary: verde, surface: Colors.white),
            scaffoldBackgroundColor: Colors.white,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(
                primary: Colors.white, onPrimary: Colors.black, secondary: verde, surface: Color(0xFF121212)),
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          home: const SplashScreen(),
        ),
      );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const Shell(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: verde,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: verde.withAlpha(128),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.flight_takeoff, size: 64, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'AeroTaxi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tu movilidad aérea urbana',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  void r() => setState(() {});

  @override
  void initState() {
    super.initState();
    navTab.addListener(r);
  }

  @override
  void dispose() {
    navTab.removeListener(r);
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: navTab.value,
          children: const [Viajar(), Servicios(), Actividad(), Ciudad(), Perfil()],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navTab.value,
        onDestinationSelected: (v) => navTab.value = v,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Viajar'),
          NavigationDestination(icon: Icon(Icons.grid_view), label: 'Servicios'),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Actividad'),
          NavigationDestination(icon: Icon(Icons.location_city), label: 'Ciudad'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class BannerD {
  String t;
  String s;
  IconData ic;
  Color a;
  Color b;
  VoidCallback f;
  BannerD(this.t, this.s, this.ic, this.a, this.b, this.f);
}

List<BannerD> banners(BuildContext c) {
  final pal = term('Terminal Palermo');
  final cen = term('Terminal Centro');
  final km = dkm(pal.p, cen.p);
  final llu = sim.clima == Clima.lluvia || sim.clima == Clima.tormenta;
  return [
    BannerD('Tu primer vuelo, 20% OFF', 'Aplicá el código AERO20', Icons.local_offer, verde, const Color(0xFF027A3E), () {
      datos.setPromo(promos[0]);
      snack(c, 'Código AERO20 listo para tu próximo vuelo');
    }),
    BannerD('Palermo → Centro en ${sim.tAire(km, 200)} min', 'En auto: ${sim.tAuto(km)} min · tráfico ${sim.trNom.toLowerCase()}',
        Icons.timer, const Color(0xFF1A73E8), const Color(0xFF0B3D91), () => navTab.value = 0),
    BannerD(
      llu ? 'Día de lluvia: 15% OFF' : 'Clima ideal para volar',
      llu ? 'Usá el código LLUVIA15' : '${sim.temp.round()}° · viento ${sim.viento.round()} km/h',
      llu ? Icons.water_drop : Icons.wb_sunny,
      llu ? const Color(0xFF1E88E5) : const Color(0xFFF9A825),
      llu ? const Color(0xFF0D47A1) : const Color(0xFFE65100),
      () {
        if (llu) {
          datos.setPromo(promos[2]);
          snack(c, 'Código LLUVIA15 aplicado');
        } else {
          navTab.value = 0;
        }
      },
    ),
    BannerD('AeroPuntos x2 los fines de semana', 'Tenés ${datos.puntos} · nivel ${datos.nivel}', Icons.emoji_events,
        const Color(0xFF8E24AA), const Color(0xFF4A148C), () => navTab.value = 4),
    BannerD('Volá compartido y ahorrá 30%', 'Compartí aeronave con otros pasajeros', Icons.people,
        const Color(0xFF00897B), const Color(0xFF004D40), () {
      pedido.value = Pedido(null, Serv.compartido);
      navTab.value = 0;
    }),
  ];
}

class Banners extends StatefulWidget {
  final List<BannerD> items;
  const Banners(this.items, {super.key});
  @override
  State<Banners> createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  final pc = PageController(viewportFraction: 0.92);
  int cur = 0;
  Timer? tm;

  @override
  void initState() {
    super.initState();
    tm = Timer.periodic(const Duration(seconds: 5), (_) {
      if (pc.hasClients) {
        pc.animateToPage((cur + 1) % widget.items.length,
            duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
      }
    });
  }

  @override
  void dispose() {
    tm?.cancel();
    pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext c) {
    return Column(
      children: [
        SizedBox(
          height: 112,
          child: PageView.builder(
            controller: pc,
            itemCount: widget.items.length,
            onPageChanged: (i) => setState(() => cur = i),
            itemBuilder: (c, i) {
              final b = widget.items[i];
              return GestureDetector(
                onTap: b.f,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(colors: [b.a, b.b]),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.t, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(b.s, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                      Icon(b.ic, color: Colors.white54, size: 44),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < widget.items.length; i++)
              Container(
                width: i == cur ? 16 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: i == cur ? Theme.of(c).colorScheme.primary : Colors.grey,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class BannersTurismo extends StatelessWidget {
  const BannersTurismo({super.key});

  void _mostrarDetallesTurismo(BuildContext context, LugarTuristico lugar) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  lugar.imagenUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[800],
                    child: const Center(child: Icon(Icons.landscape, size: 40, color: Colors.white54)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                lugar.nombre,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                lugar.subtitulo,
                style: TextStyle(fontSize: 14, color: Colors.grey[400], fontWeight: FontWeight.w500),
              ),
              const Divider(height: 24),
              const Text(
                'Descripción del atractivo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                lugar.descripcion,
                style: const TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: verde.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: verde.withAlpha(76)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer, color: verde),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Promoción activa: ${lugar.codigoPromo}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            'Obtené un ${(lugar.descuentoPct * 100).toInt()}% de descuento volando a la ${lugar.terminalCercana}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              boton('Aplicar promo y volar', () {
                for (var p in promos) {
                  if (p.cod == lugar.codigoPromo) {
                    datos.setPromo(p);
                    break;
                  }
                }
                try {
                  final tDestino = term(lugar.terminalCercana);
                  pedido.value = Pedido(tDestino, Serv.estandar);
                } catch (_) {}
                Navigator.pop(c);
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Circuitos y Lugares Turísticos',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: lugaresTuristicos.length,
            itemBuilder: (context, index) {
              final lugar = lugaresTuristicos[index];
              return GestureDetector(
                onTap: () => _mostrarDetallesTurismo(context, lugar),
                child: Container(
                  width: 220,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black12)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          lugar.imagenUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.landscape, color: Colors.white54, size: 36),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, Colors.black.withAlpha(204)],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: verde,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${(lugar.descuentoPct * 100).toInt()}% OFF',
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                lugar.nombre,
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                lugar.terminalCercana,
                                style: const TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Buscador extends StatefulWidget {
  final Terminal? ex;
  final String tit;
  const Buscador(this.ex, this.tit, {super.key});
  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
  String q = '';

  @override
  Widget build(BuildContext c) {
    final l = datos.terminales
        .where((t) => t != widget.ex && (t.nombre + t.ubic).toLowerCase().contains(q.toLowerCase()))
        .toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(c).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(c).size.height * 0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: TextField(
                onChanged: (v) => setState(() => q = v),
                decoration: InputDecoration(
                  hintText: widget.tit,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: l.length,
                itemBuilder: (c, i) {
                  final t = l[i];
                  final sg = sim.surge(t);
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.flight_land)),
                    title: Text(t.nombre),
                    subtitle: Text('${t.ubic} · ${dkm(yo, t.p).toStringAsFixed(1)} km de vos'),
                    trailing: sg >= 1.2 ? chipSg(sg) : null,
                    onTap: () => Navigator.pop(c, t),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum Etapa { elegir, opciones, buscando, llegada, viaje, recibo }

class Viajar extends StatefulWidget {
  const Viajar({super.key});
  @override
  State<Viajar> createState() => _ViajarState();
}

class _ViajarState extends State<Viajar> with TickerProviderStateMixin {
  final tc = TransformationController();
  final esc = ValueNotifier<double>(0.5);
  late final AnimationController ctl;
  late final AnimationController rep;
  late final AnimationController cam;
  Animation<Matrix4>? camA;
  Size vs = Size.zero;
  bool ini = false;
  Terminal? o;
  Terminal? d;
  Aeronave? ae;
  MetodoPago? mp;
  Piloto? pl;
  Viaje? vj;
  Serv sv = Serv.estandar;
  Etapa et = Etapa.elegir;
  bool lleg = false;
  int tk = 0;
  int est = 0;
  int pin = 0;
  int pmin = 0;
  Offset ps = Offset.zero;
  final rnd = Random();

  bool _mostrandoMapa = false;

  @override
  void initState() {
    super.initState();
    ctl = AnimationController(vsync: this);
    rep = AnimationController(vsync: this, duration: const Duration(seconds: 40))..repeat();
    cam = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    cam.addListener(() {
      final a = camA;
      if (a != null) tc.value = a.value;
    });
    tc.addListener(() => esc.value = tc.value.getMaxScaleOnAxis());
    ctl.addListener(() => setState(() {}));
    ctl.addStatusListener((s) {
      if (s == AnimationStatus.completed) fin();
    });
    pedido.addListener(recibirPedido);
    mp = datos.metodos.first;
    o = term('Terminal Centro');
  }

  @override
  void dispose() {
    pedido.removeListener(recibirPedido);
    ctl.dispose();
    rep.dispose();
    cam.dispose();
    tc.dispose();
    esc.dispose();
    super.dispose();
  }

  Promo? get pr {
    final p = datos.promo;
    return (p != null && promoMsg(p) == null) ? p : null;
  }

  Cot cot(Aeronave a) => sim.cotizar(o!, d!, a, sv, pr);

  Matrix4 mat(Offset w, double s) => Matrix4(s, 0, 0, 0, 0, s, 0, 0, 0, 0, 1, 0, vs.width / 2 - w.dx * s, vs.height / 2 - w.dy * s, 0, 1);

  void ir(Offset w, double s) {
    if (vs.isEmpty) return;
    camA = Matrix4Tween(begin: tc.value, end: mat(w, s)).animate(CurvedAnimation(parent: cam, curve: Curves.easeInOut));
    cam.forward(from: 0);
  }

  void fit(Offset a, Offset b) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || vs.isEmpty) return;
      final w = (a.dx - b.dx).abs() + 360;
      final h = (a.dy - b.dy).abs() + 460;
      ir((a + b) / 2, cl(min(vs.width / w, vs.height / h), 0.2, 2.5));
    });
  }

  void ajustar() {
    final a = o;
    final b = d;
    if (a != null && b != null) {
      fit(a.p, b.p);
    } else if (a != null || b != null) {
      final u = (a ?? b)!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ir(u.p, 0.9);
      });
    }
  }

  void recibirPedido() {
    final p = pedido.value;
    if (p == null) return;
    pedido.value = null;
    setState(() {
      _mostrandoMapa = true;
      final x = p.d;
      if (x != null) {
        if (x == o) o = null;
        d = x;
      }
      final s = p.s;
      if (s != null) sv = s;
    });
    ajustar();
  }

  void tocar(Offset p) {
    if (et != Etapa.elegir && et != Etapa.opciones) return;
    Terminal? b;
    var bd = 26 / esc.value;
    for (final t in datos.terminales) {
      final dd = (t.p - p).distance;
      if (dd < bd) {
        bd = dd;
        b = t;
      }
    }
    final x = b;
    if (x == null) return;
    setState(() {
      if (o == null) {
        o = x;
      } else if (x != o) {
        d = x;
      }
    });
    ajustar();
  }

  void rapido(String n) {
    final t = term(n);
    setState(() {
      _mostrandoMapa = true;
      if (t == o) o = null;
      d = t;
    });
    ajustar();
  }

  Future<void> elegirTerm(bool origen) async {
    setState(() => _mostrandoMapa = true);
    final r = await showModalBottomSheet<Terminal>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => Buscador(origen ? d : o, origen ? 'Buscar origen' : 'Buscar destino'),
    );
    if (r == null) return;
    setState(() {
      if (origen) {
        o = r;
      } else {
        d = r;
      }
    });
    ajustar();
  }

  Future<void> pagos() async {
    final r = await showModalBottomSheet<MetodoPago>(
      context: context,
      showDragHandle: true,
      builder: (c) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final m in datos.metodos)
              ListTile(
                leading: Icon(m is TarjetaCredito ? Icons.credit_card : Icons.account_balance),
                title: Text('${m.tipo} ${m.masc}'),
                subtitle: Text(m.detalle),
                trailing: m == mp ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(c, m),
              ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Agregar tarjeta'),
              onTap: () {
                Navigator.pop(c);
                nuevaTarjeta();
              },
            ),
          ],
        ),
      ),
    );
    if (r != null) setState(() => mp = r);
  }

  Future<void> nuevaTarjeta() async {
    final nm = TextEditingController();
    final ex = TextEditingController();
    var cr = true;
    final r = await showDialog<MetodoPago>(
      context: context,
      builder: (c) => StatefulBuilder(
        builder: (c, st) => AlertDialog(
          title: const Text('Nueva tarjeta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('Crédito')),
                  ButtonSegment(value: false, label: Text('Débito')),
                ],
                selected: {cr},
                onSelectionChanged: (s) => st(() => cr = s.first),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nm,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Número de tarjeta', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ex,
                decoration: InputDecoration(labelText: cr ? 'Titular' : 'Banco', border: const OutlineInputBorder()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                final n = nm.text.replaceAll(' ', '');
                final e = ex.text.trim();
                if (n.length < 12 || e.isEmpty) return;
                final MetodoPago m = cr ? TarjetaCredito(n, e) : TarjetaDebito(n, e);
                Navigator.pop(c, m);
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
    if (r != null) {
      datos.addMetodo(r);
      setState(() => mp = r);
    }
  }

  Future<void> buscar() async {
    final k = ++tk;
    setState(() => et = Etapa.buscando);
    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted || k != tk) return;
    pl = datos.pilotos[rnd.nextInt(datos.pilotos.length)];
    pin = 1000 + rnd.nextInt(9000);
    pmin = cot(ae!).llega;
    final ang = rnd.nextDouble() * 2 * pi;
    ps = o!.p + Offset(cos(ang), sin(ang)) * (350 + rnd.nextDouble() * 250);
    lleg = false;
    ctl.duration = const Duration(seconds: 8);
    ctl.forward(from: 0);
    setState(() => et = Etapa.llegada);
    fit(ps, o!.p);
  }

  void fin() {
    if (et == Etapa.llegada) {
      setState(() => lleg = true);
    } else if (et == Etapa.viaje) {
      terminar();
    }
  }

  void subir() {
    final c = cot(ae!);
    ctl.duration = Duration(seconds: max(12, min(28, c.mins * 2)));
    ctl.forward(from: 0);
    setState(() => et = Etapa.viaje);
    fit(o!.p, d!.p);
  }

  void terminar() {
    final n = (datos.historial.length + 1).toString().padLeft(3, '0');
    final c = cot(ae!);
    final m = mp!;
    final g = Pago('PAG-$n', c.total, m, Recibo('REC-$n', fmt(DateTime.now())));
    final msg = g.realizar();
    final pt = (c.total / 100).round() * (DateTime.now().weekday >= 6 ? 2 : 1);
    final v = Viaje(o!, d!, RutaVuelo('T-$n', d!.ubic, c.mins), ae!, pl!, g, sv, c, pt);
    datos.agregar(v);
    vj = v;
    snack(context, msg);
    setState(() {
      est = 0;
      et = Etapa.recibo;
    });
  }

  void reset() {
    tk++;
    ctl.stop();
    ctl.reset();
    setState(() {
      _mostrandoMapa = false;
      o = term('Terminal Centro');
      d = null;
      ae = null;
      pl = null;
      vj = null;
      est = 0;
      lleg = false;
      sv = Serv.estandar;
      et = Etapa.elegir;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ir(yo, 0.5);
    });
  }

  Future<void> cancelar() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('¿Cancelar el vuelo?'),
        content: const Text('Tu piloto ya está en camino.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Seguir')),
          FilledButton(onPressed: () => Navigator.pop(c, true), child: const Text('Cancelar vuelo')),
        ],
      ),
    );
    if (ok == true) reset();
  }

  Offset _centro() {
    final m = Matrix4.inverted(tc.value);
    final x = m.storage[0] * vs.width / 2 + m.storage[4] * vs.height / 2 + m.storage[12];
    final y = m.storage[1] * vs.width / 2 + m.storage[5] * vs.height / 2 + m.storage[13];
    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([sim, datos]),
      builder: (ctx, _) {
        final dk = Theme.of(ctx).brightness == Brightness.dark || sim.noche;
        final cs = Theme.of(ctx).colorScheme;
        final fase = et == Etapa.llegada ? 1 : (et == Etapa.viaje ? 2 : (et == Etapa.recibo ? 3 : 0));
        final al = sim.alertas.first;

        if (!_mostrandoMapa) {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hola, ${datos.pas.nombre}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                          Text('${sim.clima.nom} · ${sim.temp.round()}° · tráfico ${sim.trNom.toLowerCase()}',
                              style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: gris(ctx), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.emoji_events, size: 16, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text('${datos.puntos} pts'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Material(
                    color: gris(ctx),
                    borderRadius: BorderRadius.circular(30),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => elegirTerm(false),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: const [
                            Icon(Icons.search, color: verde),
                            SizedBox(width: 12),
                            Text('¿A dónde vas?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            Spacer(),
                            Chip(label: Text('Más tarde', style: TextStyle(fontSize: 11)), visualDensity: VisualDensity.compact),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: gris(ctx), borderRadius: BorderRadius.circular(14)),
                    child: Column(
                      children: [
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(radius: 14, backgroundColor: Color(0xFF333333), child: Icon(Icons.my_location, size: 14, color: Colors.blueAccent)),
                          title: Text(o?.nombre ?? 'Ubicación actual (Origen)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          trailing: const Icon(Icons.chevron_right, size: 16),
                          onTap: () => elegirTerm(true),
                        ),
                        const Divider(height: 6),
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const CircleAvatar(radius: 14, backgroundColor: Color(0xFF333333), child: Icon(Icons.location_on, size: 14, color: Colors.redAccent)),
                          title: Text(d?.nombre ?? 'Seleccionar destino', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          trailing: const Icon(Icons.chevron_right, size: 16),
                          onTap: () => elegirTerm(false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Banners(banners(ctx)),
                  const SizedBox(height: 16),
                  const BannersTurismo(),
                ],
              ),
            ),
          );
        }

        return Stack(
          children: [
            Positioned.fill(
              child: LayoutBuilder(
                builder: (c, bx) {
                  vs = Size(bx.maxWidth, bx.maxHeight);
                  if (!ini) {
                    ini = true;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) tc.value = mat(yo, 0.5);
                    });
                  }
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: InteractiveViewer(
                          transformationController: tc,
                          constrained: false,
                          minScale: 0.16,
                          maxScale: 5,
                          boundaryMargin: const EdgeInsets.all(600),
                          child: GestureDetector(
                            onTapUp: (e) => tocar(e.localPosition),
                            child: SizedBox(
                              width: ancho,
                              height: alto,
                              child: Stack(
                                children: [
                                  RepaintBoundary(
                                    child: CustomPaint(size: const Size(ancho, alto), painter: Base(dk, esc)),
                                  ),
                                  CustomPaint(
                                    size: const Size(ancho, alto),
                                    painter: Din(sim, datos.terminales, o, d, ctl.value, fase, ps, dk, esc, rep),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: Clim(sim.clima, rep)))),
                      Positioned(
                        top: 10,
                        left: 10,
                        right: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  pill(ctx, sim.clima.ic, '${sim.temp.round()}° ${sim.clima.nom}', ci: sim.clima.col),
                                  pill(ctx, Icons.air, '${sim.viento.round()} km/h'),
                                  pill(ctx, Icons.traffic, 'Tráfico ${sim.trNom.toLowerCase()}', ci: sim.trCol),
                                  pill(ctx, Icons.schedule, fmtH(sim.hora) + (sim.auto ? '' : ' (sim)')),
                                  pill(ctx, Icons.flight, '${sim.cercanos} cerca', ci: verde),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            alertaW(al),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 16,
                        top: 80,
                        child: CircleAvatar(
                          backgroundColor: cs.surface,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => setState(() => _mostrandoMapa = false),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 12,
                        bottom: 340,
                        child: Column(
                          children: [
                            fab(ctx, Icons.add, () => ir(vs.center(Offset.zero) * 0 + _centro(), cl(esc.value * 1.5, 0.16, 5))),
                            fab(ctx, Icons.remove, () => ir(_centro(), cl(esc.value / 1.5, 0.16, 5))),
                            fab(ctx, sim.verTr ? Icons.layers : Icons.layers_outlined, () => sim.setTr(!sim.verTr)),
                            fab(ctx, Icons.tune, () => abrirSim(ctx)),
                            fab(ctx, Icons.my_location, () => ir(yo, 0.9)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: const [BoxShadow(blurRadius: 16, color: Colors.black26)],
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: KeyedSubtree(key: ValueKey(et), child: cuerpo(ctx)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget cuerpo(BuildContext c) {
    switch (et) {
      case Etapa.elegir:
        return pElegir(c);
      case Etapa.opciones:
        return pOpciones(c);
      case Etapa.buscando:
        return pBuscando(c);
      case Etapa.llegada:
        return pLlegada(c);
      case Etapa.viaje:
        return pViaje(c);
      case Etapa.recibo:
        return pRecibo(c);
    }
  }

  Widget pElegir(BuildContext c) {
    final ok = o != null && d != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(d?.nombre ?? 'Seleccioná tu destino', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _mostrandoMapa = false),
            ),
          ],
        ),
        const SizedBox(height: 8),
        tile(c, Icons.my_location, o?.nombre ?? 'Ubicación actual', 'Origen', f: () => elegirTerm(true)),
        tile(c, Icons.location_on, d?.nombre ?? 'Seleccionar destino', 'Destino', f: () => elegirTerm(false)),
        const SizedBox(height: 12),
        boton('Ver aeronaves disponibles', ok ? () => setState(() => et = Etapa.opciones) : null),
      ],
    );
  }

  Widget tarjeta(BuildContext c, Aeronave a) {
    final s = ae == a;
    final bl = sim.bloqueo(a);
    final k = cot(a);
    return Opacity(
      opacity: bl == null ? 1 : 0.45,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: bl == null ? () => setState(() => ae = a) : null,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: gris(c),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: s ? Theme.of(c).colorScheme.primary : Colors.transparent, width: 2),
            ),
            child: Row(
              children: [
                const Icon(Icons.flight, size: 34),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.tipo.modelo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('${a.tipo.cap} pasajeros · ${k.mins} min de vuelo'),
                      if (bl != null)
                        Text(bl, style: const TextStyle(fontSize: 12, color: Color(0xFFD32F2F), fontWeight: FontWeight.w600))
                      else
                        Row(
                          children: [
                            const Icon(Icons.verified_user, size: 14, color: verde),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text('${a.seg.cert} · llega en ${k.llega} min', style: const TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(money(k.total), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(a.mat, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pOpciones(BuildContext c) {
    final a0 = o!;
    final b0 = d!;
    final ref = cot(datos.flota.first);
    final ahorro = ref.auto - ref.mins;
    final m = mp;
    final sel = ae;
    if (sel != null && sim.bloqueo(sel) != null) ae = null;
    final p0 = datos.promo;
    final pm = p0 == null ? null : promoMsg(p0);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(onPressed: () => setState(() => et = Etapa.elegir), icon: const Icon(Icons.arrow_back)),
            Expanded(
              child: Text(
                '${a0.nombre} → ${b0.nombre}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Text('${ref.km.toStringAsFixed(1)} km'),
          ],
        ),
        if (ahorro > 0)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0x2206C167), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.timer, color: verde, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Ahorrás $ahorro min vs auto (${ref.auto} min con tráfico ${sim.trNom.toLowerCase()})',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        if (ref.sg >= 1.2)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0x22EF6C00), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.trending_up, color: Color(0xFFEF6C00), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text('Tarifa dinámica x${ref.sg.toStringAsFixed(1)} por ${sim.motivo(a0)}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        Wrap(
          spacing: 8,
          children: [
            for (final s in Serv.values)
              ChoiceChip(
                avatar: Icon(s.ic, size: 16),
                label: Text(s.nom),
                selected: sv == s,
                onSelected: (_) => setState(() => sv = s),
              ),
          ],
        ),
        Padding(padding: const EdgeInsets.fromLTRB(4, 6, 0, 10), child: Text(sv.desc, style: const TextStyle(fontSize: 12))),
        for (final x in datos.flota) tarjeta(c, x),
        if (pr != null)
          tile(c, Icons.local_offer, 'Código ${pr!.cod} aplicado', pr!.txt,
              tr: IconButton(onPressed: () => datos.setPromo(null), icon: const Icon(Icons.close)))
        else
          tile(c, Icons.local_offer_outlined, pm == null ? 'Agregar código promocional' : '${p0!.cod} no válido', pm ?? '',
              f: () => dialogPromo(context)),
        tile(
          c,
          m is TarjetaCredito ? Icons.credit_card : Icons.account_balance,
          m == null ? 'Agregar método de pago' : '${m.tipo} ${m.masc}',
          m?.detalle ?? '',
          f: pagos,
        ),
        const SizedBox(height: 4),
        boton(
          ae == null ? 'Elige una aeronave' : 'Solicitar ${ae!.tipo.modelo} · ${money(cot(ae!).total)}',
          (ae == null || m == null) ? null : buscar,
        ),
      ],
    );
  }

  Widget pBuscando(BuildContext c) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 8),
        const CircularProgressIndicator(),
        const SizedBox(height: 16),
        const Text('Buscando piloto disponible...', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text('${ae!.tipo.modelo} · ${sim.cercanos} aeronaves cerca de ${o!.nombre.replaceFirst('Terminal ', '')}'),
        const SizedBox(height: 20),
        botonSec('Cancelar', () {
          tk++;
          setState(() => et = Etapa.opciones);
        }),
      ],
    );
  }

  Widget pilotoRow(BuildContext c) {
    final p = pl!;
    return Row(
      children: [
        CircleAvatar(radius: 26, child: Text(p.nombre[0], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.nombre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('★ ${p.nota} · ${p.viajes} vuelos · ${p.lic}', style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
        IconButton.filledTonal(onPressed: () => snack(context, 'Llamando a ${p.nombre}...'), icon: const Icon(Icons.phone)),
        IconButton.filledTonal(onPressed: () => snack(context, 'Chat con ${p.nombre}'), icon: const Icon(Icons.chat_bubble)),
      ],
    );
  }

  Widget pLlegada(BuildContext c) {
    final a = ae!;
    final rest = lleg ? 0 : (pmin * (1 - ctl.value)).ceil();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(lleg ? 'Tu piloto llegó' : 'Tu piloto llega en $rest min',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8)),
              child: Text('PIN $pin', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: ctl.value, minHeight: 6, borderRadius: BorderRadius.circular(3)),
        const SizedBox(height: 16),
        pilotoRow(c),
        const SizedBox(height: 12),
        tile(c, Icons.flight, '${a.tipo.modelo} · ${a.mat}', 'Salida desde ${o!.nombre}',
            tr: const Icon(Icons.verified_user, color: verde)),
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text('Muéstrale el PIN al piloto antes de abordar', style: TextStyle(fontSize: 12)),
          ),
        ),
        boton(lleg ? 'Subir a la aeronave' : 'Esperando a tu piloto...', lleg ? subir : null),
        const SizedBox(height: 8),
        botonSec('Cancelar vuelo', cancelar),
      ],
    );
  }

  Widget pViaje(BuildContext c) {
    final a = ae!;
    final k = cot(a);
    final v = ctl.value;
    final rest = (k.mins * (1 - v)).ceil();
    final txtEst = v < 0.1 ? 'Despegando' : (v > 0.9 ? 'Aterrizando' : 'En vuelo');
    final alt = (320 * sin(pi * v)).round();
    final vel = (a.tipo.vel * sim.clima.vf * (0.25 + 0.75 * sin(pi * v))).round();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(txtEst, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Spacer(),
            Text('$rest min', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: v, minHeight: 6, borderRadius: BorderRadius.circular(3)),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: gris(c), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              stat(Icons.height, '$alt m', 'Altitud'),
              stat(Icons.speed, '$vel km/h', 'Velocidad'),
              stat(Icons.air, '${sim.viento.round()} km/h', 'Viento'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        pilotoRow(c),
        const SizedBox(height: 12),
        tile(c, Icons.flight, '${a.tipo.modelo} · ${a.mat}', '${a.seg.cert} · ${a.seg.estado}',
            tr: const Icon(Icons.verified_user, color: verde)),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => snack(context, 'Enlace de seguimiento copiado'),
                icon: const Icon(Icons.share),
                label: const Text('Compartir viaje'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => showDialog(
                  context: context,
                  builder: (x) => AlertDialog(
                    title: const Text('Emergencia'),
                    content: const Text('Se notificó a la central y a tus contactos de confianza.'),
                    actions: [TextButton(onPressed: () => Navigator.pop(x), child: const Text('Cerrar'))],
                  ),
                ),
                icon: const Icon(Icons.warning_amber, color: Color(0xFFD32F2F)),
                label: const Text('SOS'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget pRecibo(BuildContext c) {
    final v = vj!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle, color: verde, size: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Text('¡Llegaste a ${v.d.nombre}!', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ticket(c, v),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 1; i <= 5; i++)
              IconButton(
                onPressed: () => setState(() => est = i),
                icon: Icon(i <= est ? Icons.star : Icons.star_border, color: Colors.amber, size: 32),
              ),
          ],
        ),
        Wrap(
          spacing: 8,
          children: [
            for (final x in [0, 500, 1000, 2000])
              ChoiceChip(
                label: Text(x == 0 ? 'Sin propina' : money(x)),
                selected: v.pago.propina == x.toDouble(),
                onSelected: (_) => setState(() => v.pago.propina = x.toDouble()),
              ),
          ],
        ),
        const SizedBox(height: 10),
        boton('Listo', reset),
      ],
    );
  }
}

class Servicios extends StatelessWidget {
  const Servicios({super.key});

  Widget serv(BuildContext c, IconData ic, String t, String s, VoidCallback f) => Material(
        color: gris(c),
        borderRadius: BorderRadius.circular(14),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: f,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(ic, size: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(s, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  void ped(Terminal? d, Serv? s) {
    pedido.value = Pedido(d, s);
    navTab.value = 0;
  }

  @override
  Widget build(BuildContext c) {
    return ListenableBuilder(
      listenable: Listenable.merge([sim, datos]),
      builder: (c, _) {
        final cen = term('Terminal Centro');
        final pop = ['Terminal Aeroparque', 'Terminal Madero', 'Terminal Palermo', 'Terminal Recoleta', 'Terminal Belgrano'];
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Hola, ${datos.pas.nombre}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text('${sim.clima.nom} · ${sim.temp.round()}° · tráfico ${sim.trNom.toLowerCase()}'),
            const SizedBox(height: 16),
            tile(c, Icons.search, '¿A dónde vas?', 'Planificá tu próximo vuelo', f: () => navTab.value = 0),
            const SizedBox(height: 4),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.45,
              children: [
                serv(c, Icons.flight, 'Taxi aéreo', 'Vuelo directo', () => ped(null, Serv.estandar)),
                serv(c, Icons.people, 'Compartido', 'Hasta 30% menos', () => ped(null, Serv.compartido)),
                serv(c, Icons.star, 'Premium', 'Prioridad y lounge', () => ped(null, Serv.premium)),
                serv(c, Icons.local_airport, 'Aeroparque', 'Salida directa', () => ped(term('Terminal Aeroparque'), Serv.estandar)),
              ],
            ),
            const SizedBox(height: 18),
            Banners(banners(c)),
            const SizedBox(height: 18),
            const Text('Lugares guardados', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            tile(c, Icons.home, 'Casa', 'Terminal Palermo', f: () => ped(term('Terminal Palermo'), null)),
            tile(c, Icons.work, 'Trabajo', 'Terminal Madero', f: () => ped(term('Terminal Madero'), null)),
            const SizedBox(height: 10),
            const Text('Destinos populares', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SizedBox(
              height: 130,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final n in pop)
                    Builder(builder: (c) {
                      final t = term(n);
                      final km = dkm(cen.p, t.p);
                      final sg = sim.surge(cen);
                      return Container(
                        width: 190,
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: gris(c), borderRadius: BorderRadius.circular(14)),
                        child: InkWell(
                          onTap: () => ped(t, null),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(t.nombre, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              Text('${sim.tAire(km, 200)} min en aire\n${sim.tAuto(km)} min en auto',
                                  style: const TextStyle(fontSize: 12)),
                              if (sg >= 1.2) chipSg(sg) else const Text('Tarifa normal', style: TextStyle(fontSize: 12, color: verde)),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class Actividad extends StatelessWidget {
  const Actividad({super.key});

  @override
  Widget build(BuildContext c) {
    return ListenableBuilder(
      listenable: datos,
      builder: (c, _) {
        final h = datos.historial.reversed.toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('Actividad', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: h.isEmpty
                  ? const Center(child: Text('Todavía no hiciste ningún viaje'))
                  : ListView.separated(
                      itemCount: h.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (c, i) {
                        final v = h[i];
                        return ListTile(
                          leading: const CircleAvatar(child: Icon(Icons.flight)),
                          title: Text('${v.o.nombre} → ${v.d.nombre}'),
                          subtitle: Text('${v.pago.recibo.fecha} · ${v.sv.nom}'),
                          trailing: Text(money(v.pago.cobro), style: const TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () => showModalBottomSheet(
                            context: c,
                            isScrollControlled: true,
                            showDragHandle: true,
                            builder: (c) => SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                              child: Column(
                                children: [
                                  const Text('Detalle del viaje', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  ticket(c, v),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class Ciudad extends StatelessWidget {
  const Ciudad({super.key});

  Widget card(BuildContext c, Widget w, {Gradient? g}) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: g == null ? gris(c) : null, gradient: g, borderRadius: BorderRadius.circular(16)),
        child: w,
      );

  @override
  Widget build(BuildContext c) {
    return ListenableBuilder(
      listenable: sim,
      builder: (c, _) {
        final cm = sim.clima;
        final ts = [...datos.terminales]..sort((a, b) => b.dem.compareTo(a.dem));
        const w = TextStyle(color: Colors.white);
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text('Estado de la ciudad', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),
            card(
              c,
              Column(
                children: [
                  Row(
                    children: [
                      Icon(cm.ic, color: Colors.white, size: 54),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${sim.temp.round()}° ${cm.nom}',
                                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                            Text('Viento ${sim.viento.round()} km/h · ${fmtH(sim.hora)}', style: w),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var i = 1; i <= 6; i++)
                        Builder(builder: (c) {
                          final h = (sim.hora + i) % 24;
                          final k = sim.fijo ?? sim.climaPara(h);
                          return Column(
                            children: [
                              Text('${h.floor().toString().padLeft(2, '0')}h', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              Icon(k.ic, color: Colors.white, size: 22),
                              Text('${sim.tempH(h, k).round()}°', style: w),
                            ],
                          );
                        }),
                    ],
                  ),
                ],
              ),
              g: LinearGradient(colors: [cm.col, cm.col.withAlpha(150)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            card(
              c,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.traffic, color: sim.trCol),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Tráfico ${sim.trNom.toLowerCase()}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                      Text('${(sim.base * 100).round()}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: sim.base,
                    minHeight: 8,
                    color: sim.trCol,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 10),
                  Text('Velocidad media en auto: ${(36 * (1 - 0.6 * sim.base)).round()} km/h'),
                  Text('Incidentes activos: ${sim.inc.length}'),
                  Text('Aeronaves disponibles: ${sim.cercanos}'),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (final e in [(0.1, 'Fluido'), (0.4, 'Moderado'), (0.7, 'Denso'), (0.95, 'Detenido')])
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            children: [
                              Icon(Icons.circle, size: 10, color: nivCol(e.$1)),
                              const SizedBox(width: 4),
                              Text(e.$2, style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const Text('Alertas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final a in sim.alertas) Padding(padding: const EdgeInsets.only(bottom: 8), child: alertaW(a)),
            const SizedBox(height: 10),
            const Text('Terminales por demanda', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final t in ts)
              tile(
                c,
                Icons.location_city,
                t.nombre,
                'Cola ${t.cola} min · ${t.est.vuelos} vuelos · ${t.est.pasajeros} pasajeros por día\nRuta ${t.ruta.codigo} a ${t.ruta.destino} (${t.ruta.min} min)',
                tr: sim.surge(t) >= 1.2 ? chipSg(sim.surge(t)) : const Text('Normal', style: TextStyle(color: verde)),
              ),
          ],
        );
      },
    );
  }
}

class Perfil extends StatelessWidget {
  const Perfil({super.key});

  @override
  Widget build(BuildContext c) {
    final p = datos.pas;
    return ListenableBuilder(
      listenable: Listenable.merge([datos, sim, tema]),
      builder: (c, _) {
        final sig = datos.puntos < 500 ? 500 : (datos.puntos < 1500 ? 1500 : datos.puntos);
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(
              child: CircleAvatar(
                radius: 42,
                child: Text(p.nombre[0], style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 12),
            Center(child: Text(p.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
            Center(child: Text(p.email)),
            const SizedBox(height: 8),
            Center(
              child: Chip(avatar: const Icon(Icons.circle, size: 10, color: verde), label: Text(p.conectar())),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF8E24AA), Color(0xFF4A148C)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.emoji_events, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text('AeroPuntos · ${datos.nivel}',
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Text('${datos.puntos}', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: datos.puntos / sig,
                    minHeight: 6,
                    color: Colors.amber,
                    backgroundColor: Colors.white24,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 6),
                  Text(datos.puntos >= sig ? 'Nivel máximo alcanzado' : 'Te faltan ${sig - datos.puntos} para el próximo nivel',
                      style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            tile(c, Icons.badge, 'ID Pasajero', '${p.id}'),
            tile(c, Icons.description, 'Documento', p.doc),
            tile(c, Icons.phone, 'Teléfono', p.telefono),
            const SizedBox(height: 8),
            const Text('Métodos de pago', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (final m in datos.metodos)
              tile(c, m is TarjetaCredito ? Icons.credit_card : Icons.account_balance, '${m.tipo} ${m.masc}', m.detalle),
            const SizedBox(height: 8),
            const Text('Ajustes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: Theme.of(c).brightness == Brightness.dark,
              onChanged: (v) => tema.value = v ? ThemeMode.dark : ThemeMode.light,
              title: const Text('Modo oscuro'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: sim.verTr,
              onChanged: sim.setTr,
              title: const Text('Tráfico en el mapa'),
            ),
            tile(c, Icons.local_offer, 'Código promocional',
                datos.promo == null ? 'Ingresar un código' : 'Activo: ${datos.promo!.cod}', f: () => dialogPromo(c)),
            tile(c, Icons.tune, 'Simulador de ciudad', 'Hora, clima y tráfico', f: () => abrirSim(c)),
          ],
        );
      },
    );
  }
}

class MapaOpenStreetMap extends StatelessWidget {
  const MapaOpenStreetMap({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos un SizedBox para darle un tamaño fijo y asegurar que se renderice correctamente en pantalla.
    // (Si está dentro de una Column y quieres que ocupe todo el espacio disponible, puedes cambiar SizedBox por Expanded).
    return SizedBox(
      height: 400, // Altura de ejemplo, ajústala según el diseño de tu app de AeroTaxi
      child: FlutterMap(
        options: MapOptions(
          initialCenter: const LatLng(-34.6037, -58.3816), // Coordenadas iniciales (ej. Buenos Aires)
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.aerotaxi', // Debe coincidir exactamente con el applicationId de tu AndroidManifest.xml
          ),
        ],
      ),
    );
  }
}
