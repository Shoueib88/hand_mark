import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_mark/core/constants/style.dart';
import 'package:hand_mark/features/infected/presentation/cubit/infected_cubit.dart';
import 'package:hand_mark/features/infected/presentation/pages/infected_screen.dart';
import 'package:hand_mark/features/not_infected/presentation/cubit/not_infected_cubit.dart';
import 'package:hand_mark/features/not_infected/presentation/pages/not_infected_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
        backgroundColor: S.primaryColor.withOpacity(0.5),
      ),

      //body

      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (_) => InfectedCubit(),
                          child: const InfectedScreen(),
                        )));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 10.w, color: S.blackColor)),
                transform: Matrix4.rotationZ(0.2),
                width: 240.w,
                height: 150.h,
                child: Image.asset('asset/images/photo1.png', fit: BoxFit.fill),
              ),
            ),
            SizedBox(height: 100.h),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                          create: (_) => NotInfectedCubit(),
                          child: const NotInfectedScreen(),
                        )));
              },
              child: Container(
                transform: Matrix4.rotationZ(-0.2),
                width: 240.w,
                height: 150.h,
                decoration: BoxDecoration(
                    border: Border.all(width: 10.w, color: S.blackColor)),
                child: Image.asset('asset/images/photo2.png', fit: BoxFit.fill),
              ),
            ),
          ])),
    );
  }
}
