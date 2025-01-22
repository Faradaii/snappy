import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:snappy/presentation/bloc/shared_preferences/shared_preference_bloc.dart';
import 'package:snappy/presentation/pages/onboarding/onboarding_data.dart';

import '../../../common/localizations/common.dart';
import '../../../config/route/router.dart';
import '../../widgets/flag_language.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _controller;
  List<OnboardingData> onboardingData = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _loadOnboardingData();
  }

  Future<void> _loadOnboardingData() async {
    final String response = await rootBundle.loadString(
      'assets/onboarding_data.json',
    );
    final List<dynamic> data = json.decode(response);

    setState(() {
      onboardingData =
          data.map((item) => OnboardingData.fromJson(item)).toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              FlagLanguage(),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: 3,
                  onPageChanged: (value) =>
                      setState(() => currentIndex = value),
                  itemBuilder: (context, index) => onboardingData.isEmpty
                      ? null
                      : OnboardingSection(
                          onboardingData: onboardingData.elementAt(
                            index,
                          ),
                          index: index,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              _buildIndicator(context),
              const SizedBox(height: 20),
              _buildActionButton(context),
              _buildSkipButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 10,
      child: Center(
        child: ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: currentIndex == index ? 20 : 10,
            height: 5,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          if (currentIndex < 2) {
            _controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        },
        style: currentIndex == 2
            ? TextButton.styleFrom(overlayColor: Colors.transparent)
            : TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
        child: Text(
          currentIndex == 2 ? '' : AppLocalizations.of(context)!.next,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
    );
  }

  Widget _buildSkipButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: () {
          if (currentIndex == 2) {
            BlocProvider.of<SharedPreferenceBloc>(
              context,
            ).add(SharedPreferenceSetIsFirstTimeEvent(true));
            context.go(PageRouteName.login);
            return;
          }
          _controller.animateToPage(
            2,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
          );
        },
        style: currentIndex == 2
            ? TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              )
            : null,
        child: Text(
          currentIndex == 2
              ? AppLocalizations.of(context)!.startSnappy
              : AppLocalizations.of(context)!.skip,
          style: currentIndex == 2
              ? Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
              : null,
        ),
      ),
    );
  }
}

class OnboardingSection extends StatelessWidget {
  final OnboardingData onboardingData;
  final int index;

  const OnboardingSection(
      {super.key, required this.onboardingData, required this.index});

  String getOnboardingTitle(BuildContext context, int step) {
    switch (step) {
      case 0:
        return AppLocalizations.of(context)!.onboardingTitleStep1;
      case 1:
        return AppLocalizations.of(context)!.onboardingTitleStep2;
      case 2:
        return AppLocalizations.of(context)!.onboardingTitleStep3;
      default:
        return '';
    }
  }

  String getOnboardingDesc(BuildContext context, int step) {
    switch (step) {
      case 0:
        return AppLocalizations.of(context)!.onboardingDescStep1;
      case 1:
        return AppLocalizations.of(context)!.onboardingDescStep2;
      case 2:
        return AppLocalizations.of(context)!.onboardingDescStep3;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Flexible(child: SvgPicture.asset(onboardingData.image)),
                const SizedBox(height: 40),
                Text(
                  getOnboardingTitle(context, index),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 40),
                Text(
                  getOnboardingDesc(context, index),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
