import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class JobPreScreenApplicants extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;
  final VoidCallback cancel;
  List<String> prescreenQuestions;
  JobPreScreenApplicants(
      {super.key,
      required this.nextPage,
      required this.previousPage,
      required this.cancel,
      required this.prescreenQuestions});

  @override
  State<JobPreScreenApplicants> createState() => _JobPreScreenApplicantsState();
}

class _JobPreScreenApplicantsState extends State<JobPreScreenApplicants> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();
  // final List<String> _questions = [];

  void _addQuestion() {
    final questionText = _controller.text.trim();
    if (questionText.isNotEmpty) {
      setState(() {
        widget.prescreenQuestions.add(questionText);
        _controller.clear();
      });
    }
  }

  void _deleteClickedItem(int index) {
    setState(() {
      widget.prescreenQuestions.removeAt(index);
    });
  }

  void _submitJobPreScreen() {
    // if (_formKey.currentState!.validate()) {
    widget.nextPage();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Gap(40),
          Center(
            child: Container(
              alignment: Alignment.centerLeft,
              height: 35,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 400,
                    width: 630,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gap(20),
                        const Text(
                          'Pre-screen applicants',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff202855),
                          ),
                        ),
                        const Text(
                          'Write your own question to ask applicants.',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Question/s ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff202855),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 30),
                              onPressed: _addQuestion,
                            ),
                          ],
                        ),
                        Gap(10),
                        TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: 'Type your question here',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 5.0,
                              horizontal: 10.0,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffD1E1FF),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xffD1E1FF),
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.prescreenQuestions.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffD1E1FF),
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      widget.prescreenQuestions[index],
                                      style: const TextStyle(),
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        _deleteClickedItem(index);
                                      },
                                      icon: const Icon(Icons.delete_rounded),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: widget.cancel,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Color(0xffFE9703)),
                          )),
                      Gap(10),
                      ElevatedButton(
                        onPressed: () => _submitJobPreScreen(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0038FF),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        child: const Text('Next',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
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
