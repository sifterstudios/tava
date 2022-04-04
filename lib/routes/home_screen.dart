import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tava/widgets/date_picker.dart';
import '../widgets/home_mood.dart';
import '../widgets/home_stats.dart';
import '../widgets/home_today.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef watch) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        const DatePickerHorizontal(),
        const SizedBox(
          height: 5,
        ),
        const HomeStats(),
        const HomeToday(),
        const HomeMood(),
        FloatingActionButton(onPressed: () => context.push('/tava')),
      ],
    );
  }
}
