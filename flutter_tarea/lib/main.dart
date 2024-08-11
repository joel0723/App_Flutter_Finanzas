import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(MyApp());
}

class User {
  final String email;
  final String name;
  final String password;

  User({required this.email, required this.name, required this.password});
}

void saveUserData(String email, String name, String password) {
  var box = Hive.box('userBox');
  box.put('email', email);
  box.put('name', name);
  box.put('password', password);
}

String getUserEmail() {
  var box = Hive.box('userBox');
  return box.get('email', defaultValue: '');
}

String getUserName() {
  var box = Hive.box('userBox');
  return box.get('name', defaultValue: '');
}

String getUserPassword() {
  var box = Hive.box('userBox');
  return box.get('password', defaultValue: '');
}

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('$baseUrl'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        hintColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            disabledForegroundColor: Colors.white.withOpacity(0.38),
            disabledBackgroundColor: Colors.white.withOpacity(0.12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide(color: Colors.green),
          ),
          labelStyle: TextStyle(color: Colors.green),
        ),
      ),
      home: InitialPage(),
      routes: {
        '/loanCalculator': (context) => LoanCalculatorPage(),
        '/paymentCapacity': (context) => PaymentCapacityPage(),
        '/improveCreditScore': (context) => ImproveCreditScorePage(),
        '/investments': (context) => InvestmentsPage(),
        '/savingsMethods': (context) => SavingsMethodsPage(),
      },
    );
  }
}

class InitialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FinanzasFlex'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Bienvenido \na \nFinanzasFlex',
                style: TextStyle(
                  fontSize: 33,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              Image.asset(
                'images/background.jpg',
                height: 250,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Registrarse', style: TextStyle(color: Colors.black)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Iniciar Sesión',style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Crear Cuenta',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  saveUserData(emailController.text, nameController.text, passwordController.text);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Registrar', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar Sesión'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Iniciar Sesión',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Correo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String savedEmail = getUserEmail();
                  String savedPassword = getUserPassword();
                  if (emailController.text == savedEmail && passwordController.text == savedPassword) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('Correo o contraseña incorrectos'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cerrar'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Iniciar Sesión', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String email;
  late String name;

  @override
  void initState() {
    super.initState();
    email = getUserEmail();
    name = getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finanzas Flex'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calculadora de Préstamos'),
              onTap: () {
                Navigator.pushNamed(context, '/loanCalculator');
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment),
              title: Text('Capacidad de Pago'),
              onTap: () {
                Navigator.pushNamed(context, '/paymentCapacity');
              },
            ),
            ListTile(
              leading: Icon(Icons.credit_score),
              title: Text('Mejorar tu Score Crediticio'),
              onTap: () {
                Navigator.pushNamed(context, '/improveCreditScore');
              },
            ),
            ListTile(
              leading: Icon(Icons.show_chart),
              title: Text('Inversiones'),
              onTap: () {
                Navigator.pushNamed(context, '/investments');
              },
            ),
            ListTile(
              leading: Icon(Icons.savings),
              title: Text('Métodos de Ahorro'),
              onTap: () {
                Navigator.pushNamed(context, '/savingsMethods');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
  padding: EdgeInsets.all(16.0),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Colors.green, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  ),
  child: Text(
    'Hola, $name',
    style: TextStyle(
      color: const Color.fromARGB(255, 3, 3, 3),
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  ),
)
,
            SizedBox(height: 20),
            Text(
              'Bienvenido a Finanzas Flex',
              style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'La primera app del mercado\nque te recomienda las\nmejores recomendaciones\npara un mejor futuro\nfinanciero',
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/loanCalculator');
              },
              child: Text('Calculadora de Préstamos', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/paymentCapacity');
              },
              child: Text('Calcular Capacidad de Pago', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/improveCreditScore');
              },
              child: Text('Mejorar tu Score Crediticio', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/investments');
              },
              child: Text('Conoce Sobre Inversiones', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/savingsMethods');
              },
              child: Text('Métodos de Ahorro Seguro', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
class LoanCalculatorPage extends StatefulWidget {
  @override
  _LoanCalculatorPageState createState() => _LoanCalculatorPageState();
}

class _LoanCalculatorPageState extends State<LoanCalculatorPage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();
  final TextEditingController interestRateController = TextEditingController();
  List<Map<String, dynamic>> paymentSchedule = [];

  void calculateLoanPayments() {
    double principal = double.tryParse(amountController.text) ?? 0;
    int months = int.tryParse(monthsController.text) ?? 0;
    double annualRate = double.tryParse(interestRateController.text) ?? 0;
    double monthlyRate = annualRate / 12 / 100;

    paymentSchedule.clear();

    for (int i = 1; i <= months; i++) {
      double interestPayment = principal * monthlyRate;
      double principalPayment = principal / months;
      double totalPayment = interestPayment + principalPayment;

      paymentSchedule.add({
        'month': i,
        'interest': interestPayment,
        'principal': principalPayment,
        'total': totalPayment,
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Préstamos', style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              decoration: InputDecoration(labelText: 'Cantidad a tomar prestada'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: monthsController,
              decoration: InputDecoration(labelText: 'Tiempo en meses'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: interestRateController,
              decoration: InputDecoration(labelText: 'Tasa de interés anual (%)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateLoanPayments,
              child: Text('Calcular Pagos'),
            ),
            SizedBox(height: 20),
            if (paymentSchedule.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Mes')),
                      DataColumn(label: Text('Interés')),
                      DataColumn(label: Text('Principal')),
                      DataColumn(label: Text('Total')),
                    ],
                    rows: paymentSchedule.map((payment) {
                      return DataRow(cells: [
                        DataCell(Text(payment['month'].toString())),
                        DataCell(Text(payment['interest'].toStringAsFixed(2))),
                        DataCell(Text(payment['principal'].toStringAsFixed(2))),
                        DataCell(Text(payment['total'].toStringAsFixed(2))),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class PaymentCapacityPage extends StatefulWidget {
  @override
  _PaymentCapacityPageState createState() => _PaymentCapacityPageState();
}

class _PaymentCapacityPageState extends State<PaymentCapacityPage> {
  final TextEditingController incomeController = TextEditingController();
  final TextEditingController debtController = TextEditingController();

  String result = '';

  void calculateCapacity() {
    double income = double.parse(incomeController.text);
    double debt = double.parse(debtController.text);
    double capacity = (debt / income) * 100;

    setState(() {
      if (capacity > 50) {
        result = 'Su deuda actual es mayor al 50% de sus ingresos mensuales, su capacidad de pago está al tope. "No es Recomendable endeudarte mas".';
      } else if (capacity > 30 && capacity <= 50) {
        result = 'Su capacidad de pago es media.';
      } else {
        result = 'Su capacidad de pago es buena.';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capacidad de Pago'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: incomeController,
              decoration: InputDecoration(labelText: 'Ingresos mensuales'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            TextField(
              controller: debtController,
              decoration: InputDecoration(labelText: 'Monto de deuda actual'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateCapacity,
              child: Text('Calcular'),
            ),
            SizedBox(height: 20),
            Text(
              result,
              style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 0, 0, 0)),
              textAlign: TextAlign.center,
            ),
            Image.asset('images/capa.jpg'),
          ],
        ),
      ),
    );
  }
}

class ImproveCreditScorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mejorar tu Score Crediticio'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Consejos para Mejorar tu Score Crediticio',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '1. Paga tus facturas a tiempo: El historial de pagos es uno de los factores más importantes en tu score crediticio.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '2. Mantén bajos los saldos de tus tarjetas de crédito: Intenta mantener tus balances por debajo del 30% del límite de crédito.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Image.asset('images/score.png'),
            SizedBox(height: 10),
            Text(
              '3. No cierres cuentas antiguas: La longitud de tu historial crediticio también afecta tu score.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '4. Limita las solicitudes de crédito nuevas: Cada vez que solicitas un nuevo crédito, puede afectar temporalmente tu score.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '5. Revisa tu informe de crédito regularmente: Asegúrate de que no haya errores que puedan afectar tu score.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class InvestmentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inversiones en RD'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Bolsa de Valores de la República Dominicana',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset('images/Bolsa.jpg'),
            Text(
              'La Bolsa de Valores de la República Dominicana (BVRD) ofrece una plataforma para que empresas y gobiernos emitan valores y los inversionistas los compren. Los beneficios incluyen:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '- Diversificación de inversiones.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '- Posibilidad de obtener rendimientos atractivos.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '- Transparencia en las transacciones.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Fondos de Inversión (AFI) en RD',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Las Administradoras de Fondos de Inversión (AFI) gestionan fondos para diferentes perfiles de inversionistas. Beneficios incluyen:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '- Gestión profesional del dinero.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '- Diversificación de activos.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '- Acceso a diferentes mercados y sectores.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Image.asset('images/background.jpg'),
          ],
        ),
      ),
    );
  }
}


class SavingsMethodsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Métodos de Ahorro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Consejos para Ahorrar y Mejorar tu Vida Financiera',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              '1. Establece un presupuesto: Conoce tus ingresos y gastos para identificar oportunidades de ahorro.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '2. Automatiza tus ahorros: Configura transferencias automáticas a tu cuenta de ahorros.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Image.asset('images/ahorro.png'),
            SizedBox(height: 10),
            Text(
              '3. Reduce gastos innecesarios: Revisa tus gastos y elimina aquellos que no sean esenciales.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '4. Aprovecha los descuentos y ofertas: Compra de manera inteligente y aprovecha las promociones.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              '5. Crea un fondo de emergencia: Ahorra al menos tres a seis meses de gastos para imprevistos.',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
