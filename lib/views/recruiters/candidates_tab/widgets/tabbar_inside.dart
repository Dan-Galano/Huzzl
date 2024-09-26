import 'package:flutter/material.dart';

class TabBarInside extends StatefulWidget {
  final TabController tabController;
  final List<Tab> tabs; 
  final List<Widget> views;

  const TabBarInside({
    Key? key,
    required this.tabController,
    required this.tabs,
    required this.views,
  })  : assert(tabs.length == views.length, 'Tabs and views must have the same length'),
        super(key: key);

  @override
  _TabBarInsideState createState() => _TabBarInsideState();
}

class _TabBarInsideState extends State<TabBarInside> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    widget.tabController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          controller: widget.tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF3b7dff),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'Galano',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontFamily: 'Galano',
          ),
          tabs: widget.tabs, 
        ),
        const SizedBox(height: 16),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: IndexedStack(
            index: widget.tabController.index,
            children: widget.views
                .map((view) => ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 100),
                      child: view,
                    ))
                .toList(), 
          ),
        ),
      ],
    );
  }
}
