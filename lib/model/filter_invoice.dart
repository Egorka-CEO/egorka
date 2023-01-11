class Filter {
  String? type;
  String? direction;
  FilterDate? filterDate;

  Filter({
    this.type,
    this.direction,
    this.filterDate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Type'] = type;
    data['Direction'] = direction;
    data['Date'] = filterDate?.toJson();

    return data;
  }
}

class FilterDate {
  String? from;
  String? to;

  FilterDate({
    this.from,
    this.to,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['From'] = from;
    data['To'] = to;

    return data;
  }
}
