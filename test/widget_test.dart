import 'package:flutter_test/flutter_test.dart';
import 'package:menu_comida/main.dart';

void main() {
  testWidgets('Test de la aplicación', (WidgetTester tester) async {
    // Bombea el widget con MyApp sin pasar la conexión
    await tester.pumpWidget(MyApp());

    // Tus pruebas a continuación...
  });
}
