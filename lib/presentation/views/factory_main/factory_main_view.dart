import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tarbus2021/app/app_colors.dart';
import 'package:tarbus2021/app/app_string.dart';
import 'package:tarbus2021/model/api/response/response_welcome_dialog.dart';
import 'package:tarbus2021/model/entity/app_start_settings.dart';
import 'package:tarbus2021/presentation/custom_widgets/extended_banner.dart';
import 'package:tarbus2021/presentation/custom_widgets/horizontal_line.dart';
import 'package:tarbus2021/presentation/views/about_us/about_us_view.dart';
import 'package:tarbus2021/presentation/views/factory_main/welcome_dialog.dart';
import 'package:tarbus2021/presentation/views/settings/settings_view.dart';
import 'package:tarbus2021/utils/navigation_provider.dart';

class FactoryMainView extends StatefulWidget {
  static const route = '/';
  final AppStartSettings appStartSettings;

  const FactoryMainView({Key key, this.appStartSettings}) : super(key: key);

  @override
  _FactoryMainViewState createState() => _FactoryMainViewState();
}

class _FactoryMainViewState extends State<FactoryMainView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.appStartSettings.hasDialog) {
        var dialog = widget.appStartSettings.dialogContent;
        _showDialog(dialog);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        final bottomNavigationBarItems = provider.screens
            .map((screen) => BottomNavigationBarItem(icon: Icon(screen.icon), label: screen.title))
            .toList();

        final screens = provider.screens
            .map(
              (screen) => Navigator(
                key: screen.navigatorState,
                onGenerateRoute: screen.onGenerateRoute,
              ),
            )
            .toList();
        return WillPopScope(
          onWillPop: () async => provider.onWillPop(context),
          child: Scaffold(
            drawer: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DrawerHeader(
                    child: SvgPicture.asset(
                      'assets/logo_tarbus_main.svg',
                      width: 130,
                      height: 130,
                      color: AppColors.instance(context).homeLinkColor,
                    ),
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.info_outline,
                            color: AppColors.instance(context).iconColor,
                          ),
                          title: Text(AppString.labelInfoAboutApp),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute<String>(builder: (context) => AboutUsView()));
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.settings,
                            color: AppColors.instance(context).iconColor,
                          ),
                          title: Text(AppString.labelSettings),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute<String>(builder: (context) => SettingsView()));
                          },
                        ),
                        HorizontalLine(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                          child: Text('tarBUS ${AppString.appInfoVersion}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: ClipRect(
                child: ExtendedBanner(
                  location: BannerLocation.topEnd,
                  isVisible: !widget.appStartSettings.isOnline,
                  message: AppString.labelOffline,
                  color: AppColors.instance(context).primaryColor,
                  child: IndexedStack(
                    index: provider.currentTabIndex,
                    children: screens,
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: true,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              items: bottomNavigationBarItems,
              currentIndex: provider.currentTabIndex,
              onTap: provider.setTab,
            ),
          ),
        );
      },
    );
  }

  void _showDialog(ResponseWelcomeDialog dialog) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => WelcomeDialog(dialog: dialog),
    );
  }
}
