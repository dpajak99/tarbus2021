import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tarbus2021/model/entity/bus_stop_arguments_holder.dart';
import 'package:tarbus2021/model/entity/departure.dart';
import 'package:tarbus2021/presentation/views/schedule/factory_schedule_view.dart';

import 'controller/track_detailis_view_controller.dart';

class TrackDetailsItemView extends StatelessWidget {
  final Departure departure;
  final int currentIndex;
  final int index;

  const TrackDetailsItemView({Key key, this.departure, this.index, this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewController = TrackDetailsViewController(index, currentIndex)..checkIfCurrentBusStop();

    return ButtonTheme(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minWidth: 0,
      height: 0,
      child: FlatButton(
        onPressed: () {
          Navigator.of(
            context,
            rootNavigator: true,
          ).pushNamed(FactoryScheduleView.route, arguments: BusStopArgumentsHolder(busStop: departure.busStop));
        },
        padding: EdgeInsets.all(0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Image(image: AssetImage(viewController.getTrackIconPath()), height: 35, fit: BoxFit.fitHeight),
              ),
              Expanded(
                flex: 7,
                child: Text(
                  departure.busStop.name,
                  style: TextStyle(fontWeight: viewController.isCurrent ? FontWeight.bold : FontWeight.normal),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  departure.timeInString,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
