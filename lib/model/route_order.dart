class RouteOrder {
  String id;
  String adress;
  String? pod;
  String? etaj;
  String? offic;
  String? name;
  String? phone;
  String? comment;

  RouteOrder({
    required this.id,
    required this.adress,
    this.pod,
    this.etaj,
    this.offic,
    this.name,
    this.phone,
    this.comment,
  });
}
