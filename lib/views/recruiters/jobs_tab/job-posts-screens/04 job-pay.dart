import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:huzzl_web/views/recruiters/jobs_tab/widgets/custom_input.dart';

class JobPay extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback cancel;

  const JobPay(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.cancel});

  @override
  State<JobPay> createState() => _JobPayState();
}

class _JobPayState extends State<JobPay> {
  final _formKey = GlobalKey<FormState>();

  List<String> supplementalPay = [
    '13th month salary',
    'Overtime pay',
    'Commission pay',
    'Yearly bonus',
    'Bonus pay',
    'Performance bonus',
    'Tips',
    'Quarterly bonus',
    'Anniversary bonus'
  ];
  String selectedSupplementalPay = '';

  List<String> rateOptions = ['Per Hour', 'Per Day', 'Per Week', 'Per Month'];
  String selectedRate = 'Per Hour'; // Default selection

  var minimumController = TextEditingController();
  var maximumController = TextEditingController();

  void _submitJobPay() {
    if (_formKey.currentState!.validate()) {
      widget.nextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Gap(20),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              width: 860,
              child: IconButton(
                onPressed: widget.previousPage,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color(0xFFFE9703),
                ),
              ),
            ),
          ),
          Container(
            width: 630,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Gap(30),
                  Text(
                    'Add Pay',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff202855),
                    ),
                  ),
                  Text(
                    'Please provide the following to complete a job post.',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 16,
                    ),
                  ),
                  Gap(10),
                  Text(
                    'Pay',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff202855),
                    ),
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate',
                            style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff202855),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: DropdownButtonFormField<String>(
                              decoration: customInputDecoration(),
                              value: selectedRate,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedRate = newValue!;
                                });
                              },
                              items: rateOptions.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontFamily: 'Galano',
                                      fontSize: 16,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      Gap(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Minimum',
                            style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff202855),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: TextFormField(
                              controller: minimumController,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 5.0),
                                  child: Text(
                                    '₱ ',
                                    style: TextStyle(
                                      fontFamily: 'Galano',
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 0,
                                  minHeight: 0,
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xff8d898f),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xff8d898f),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xff8d898f),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(10),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'To',
                          style: TextStyle(fontFamily: 'Galano'),
                        ),
                      ),
                      Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Maximum',
                            style: TextStyle(
                              fontFamily: 'Galano',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff202855),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.12,
                            child: TextFormField(
                              controller: maximumController,
                              decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 5.0),
                                  child: Text(
                                    '₱ ',
                                    style: TextStyle(
                                      fontFamily: 'Galano',
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                prefixIconConstraints: BoxConstraints(
                                  minWidth: 0,
                                  minHeight: 0,
                                ),
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xff8d898f),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xff8d898f),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xff8d898f),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(20),
                  Divider(
                    color: Colors.grey,
                  ),
                  Gap(20),
                  Text(
                    'Supplemental Pay',
                    style: TextStyle(
                      fontFamily: 'Galano',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff202855),
                    ),
                  ),
                  Gap(10),
                  Wrap(
                    spacing: 12.0, // Spacing between chips
                    runSpacing: 8.0, // Spacing for wrapping
                    children: supplementalPay.map((sPay) {
                      bool isSelected = selectedSupplementalPay == sPay;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSupplementalPay = isSelected ? '' : sPay;
                            print(
                                'Selected supplemental pay: $selectedSupplementalPay');
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFF21254A)),
                            borderRadius: BorderRadius.circular(20),
                            color:
                                isSelected ? Color(0xFF21254A) : Colors.white,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add,
                                  size: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : Color(0xFF21254A)),
                              Gap(4),
                              Text(
                                sPay,
                                style: TextStyle(
                                  fontFamily: 'Galano',
                                  color: isSelected
                                      ? Colors.white
                                      : Color(0xFF21254A),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: widget.cancel,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                                fontFamily: 'Galano', color: Color(0xffFE9703)),
                          )),
                      Gap(10),
                      ElevatedButton(
                        onPressed: () => _submitJobPay(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0038FF),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        child: const Text('Next',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontFamily: 'Galano',
                              fontWeight: FontWeight.w700,
                            )),
                      ),
                    ],
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
