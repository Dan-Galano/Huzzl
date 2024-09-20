import 'package:flutter/material.dart';
import 'package:huzzl_web/views/recruiters/branches/widgets/branch_tile_widget.dart';

class ActiveBranchesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Branch Manager and Date Established Text
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                child: Text(""),
              ),
              SizedBox(
                width: 200,
                child: Text(
                  "Branch Manager",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Galano',
                  ),
                ),
              ),
              Text(
                "Date Established",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Galano',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              BranchTile(
                  name: 'Jollibee - Urdaneta Bypass',
                  manager: 'Add branch manager',
                  date: '05/12/2024',
                  location: 'San Vicente, Urdaneta City, Pangasinan'),
              BranchTile(
                  name: 'Jollibee - Urdaneta Magic Mall',
                  manager: 'Juan Karlos',
                  date: '06/17/2024',
                  location: 'Nancaysan, Urdaneta City, Pangasinan'),
              BranchTile(
                  name: 'Jollibee - Urdaneta SM',
                  manager: 'Ebe Dancel',
                  date: '05/18/2024',
                  location: 'Nancaysan, Urdaneta City, Pangasinan'),
              BranchTile(
                  name: 'Jollibee - Urdaneta CB Mall',
                  manager: 'Dionela',
                  date: '02/28/2024',
                  location: 'San Vicente, Urdaneta City, Pangasinan'),
            ],
          ),
        ),
      ],
    );
  }
}
