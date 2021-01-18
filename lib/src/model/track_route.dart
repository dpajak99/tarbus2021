class TrackRoute {
  String id;
  String destinationName;
  int busLineId;

  TrackRoute({this.id, this.destinationName, this.busLineId});

  factory TrackRoute.fromJson(Map<String, dynamic> json) {
    return TrackRoute(
      id: json['r_id'],
      destinationName: json['r_destination_name'],
      busLineId: json['r_bus_line_id'],
    );
  }
}
