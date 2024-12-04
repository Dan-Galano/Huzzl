// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

// void main() {
//   runApp(const PaypalPaymentDemo());
// }

// class PaypalPaymentDemo extends StatelessWidget {
//   const PaypalPaymentDemo({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PaypalPaymentDemo',
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: Center(
//           child: Builder(
//             builder: (BuildContext innerContext) {
//               return TextButton(
//                 onPressed: () {
//                   Navigator.of(innerContext).push(MaterialPageRoute(
//                     builder: (BuildContext context) => PaypalCheckoutView(
//                       sandboxMode: true,
//                       clientId:
//                           "AcL8BbADUSwnDrWBpPI8jk1nLGYChY_3WrxOq7NTmI3hFbRrWEfMw8q6QKEkq81uDMaUcYMrMTCdkmW2",
//                       secretKey:
//                           "EP93Yh1dvZ4lX3NDdYlgEg1b9NNB1ktv-OrAQgrg0gKqQaaeBjCl_L7H0BuZNT_sSH1c2J6Fdv4aaU9z",
//                       transactions: const [
//                         {
//                           "amount": {
//                             "total": '100',
//                             "currency": "USD",
//                             "details": {
//                               "subtotal": '100',
//                               "shipping": '0',
//                               "shipping_discount": 0
//                             }
//                           },
//                           "description": "The payment transaction description.",
//                           "item_list": {
//                             "items": [
//                               {
//                                 "name": "Apple",
//                                 "quantity": 4,
//                                 "price": '10',
//                                 "currency": "USD"
//                               },
//                               {
//                                 "name": "Pineapple",
//                                 "quantity": 5,
//                                 "price": '12',
//                                 "currency": "USD"
//                               }
//                             ],
//                           }
//                         }
//                       ],
//                       note: "Contact us for any questions on your order.",
//                       onSuccess: (Map params) async {
//                         log("onSuccess: $params");
//                         Navigator.pop(innerContext);
//                       },
//                       onError: (error) {
//                         log("onError: $error");
//                         Navigator.pop(innerContext);
//                       },
//                       onCancel: () {
//                         log('Cancelled');
//                         Navigator.pop(innerContext);
//                       },
//                     ),
//                   ));
//                 },
//                 child: const Text('Pay with PayPal'),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
