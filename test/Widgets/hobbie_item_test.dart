import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inside/Models/Hobbie.dart';
import 'package:inside/Widget/Elements/HobbieItem.dart';

void main() {
  testWidgets(
      "The HobbieItem widget is not displayed if no hobbie is given to it ",
      (WidgetTester tester) async {
    await tester.pumpWidget(HobbieItem(
      hobbie: null,
    ));

    var column = find.byType(Column);
    expect(column, findsNothing);
  });
  testWidgets("The HobbieItem is displayed if a hobbie is given to it ",
      (WidgetTester tester) async {
    final String documentId = "documentId";
    Map<String, dynamic> hobbieMaped = Map();
    hobbieMaped['backgroundColor'] = 'red';
    hobbieMaped['name'] = 'Football';
    hobbieMaped['icon'] = 'rugby.png';

    final widget = makeTesteableWidget(
      child: HobbieItem(
        hobbie: Hobbie.fromMap(hobbieMaped, documentId),
      ),
    );

    await tester.pumpWidget(widget);

    var column = find.byType(Column);
    expect(column, findsOneWidget);
  });
}

Widget makeTesteableWidget({Widget child}) {
  return MaterialApp(
    home: child,
  );
}
