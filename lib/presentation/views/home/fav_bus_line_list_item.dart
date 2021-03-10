import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tarbus2021/app/app_colors.dart';
import 'package:tarbus2021/app/app_consts.dart';
import 'package:tarbus2021/app/app_string.dart';
import 'package:tarbus2021/model/entity/bus_line.dart';
import 'package:tarbus2021/model/entity/custop_popup_menu.dart';
import 'package:tarbus2021/presentation/views/bus_routes/bus_routes_view.dart';
import 'package:tarbus2021/utils/shared_preferences_utils.dart';

class FavBusLineListItem extends StatelessWidget {
  final BusLine favBusLine;
  final Function onUpdate;

  const FavBusLineListItem({Key key, this.favBusLine, this.onUpdate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var choices = [
      CustomPopupMenu(
        title: AppString.labelDelete,
        icon: Icons.delete_outline,
        action: () {
          SharedPreferencesUtils.remove(AppConsts.SharedPreferencesFavLine, favBusLine.id.toString());
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(AppString.alertSucessufullyDeletedBusLine),
            ),
          );
        },
      ),
    ];

    return Card(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: ListTile(
        onTap: () async {
          await Navigator.of(context).push(
            PageRouteBuilder<void>(
              pageBuilder: (context, animation1, animation2) {
                return BusRoutesView(busLine: favBusLine);
              },
              transitionsBuilder: (context, animation1, animation2, child) {
                return FadeTransition(
                  opacity: animation1,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 150),
            ),
          );
          onUpdate();
        },
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              'assets/icons/icon_bus.svg',
              width: 25,
              height: 25,
              color: AppColors.instance(context).iconColor,
            ),
          ],
        ),
        title: Text(favBusLine.name),
        subtitle: Text(AppString.companyMichalus),
        trailing: PopupMenuButton(
          elevation: 3.2,
          onSelected: (dynamic value) {
            value.action();
          },
          itemBuilder: (BuildContext context) {
            return choices.map((choice) {
              return PopupMenuItem(
                height: 20.0,
                value: choice,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    choice.action();
                    onUpdate();
                  },
                  child: Row(
                    children: [
                      Icon(
                        choice.icon,
                        color: AppColors.instance(context).iconColor,
                      ),
                      Container(
                        width: 10,
                      ),
                      Text(choice.title),
                    ],
                  ),
                ),
              );
            }).toList();
          },
          child: Icon(
            Icons.more_vert,
            color: AppColors.instance(context).iconColor,
          ),
        ),
      ),
    );
  }
}
