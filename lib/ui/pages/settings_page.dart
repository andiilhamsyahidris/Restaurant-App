import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app_new/common/result_state.dart';
import 'package:restaurant_app_new/provider/scheduling_provider.dart';
import 'package:restaurant_app_new/ui/screen/loading_screen.dart';
import 'package:restaurant_app_new/ui/theme/color_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SchedulingProvider>(
      builder: (context, scheduledProvider, child) {
        if (scheduledProvider.state == ResultState.loading) {
          return const LoadingScreen();
        }
        return _buildScaffoldBody(scheduledProvider);
      },
    );
  }

  Scaffold _buildScaffoldBody(SchedulingProvider schedulingProvider) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: backgroundColor,
      ),
      body: _buildSwitch(schedulingProvider),
    );
  }

  Padding _buildSwitch(SchedulingProvider schedulingProvider) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListTile(
        title: Text(
          'Restaurant Notification',
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        ),
        subtitle: Text(
          'Akan muncul tiap pukul 11.00 AM',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white54),
        ),
        trailing: Switch(
          activeColor: secondaryColor,
          value: schedulingProvider.isScheduled,
          onChanged: (value) async {
            await schedulingProvider.scheduledRestaurant(value);
            await schedulingProvider.setSwitchValue(value);
          },
        ),
      ),
    );
  }
}
