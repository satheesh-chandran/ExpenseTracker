enum FilterCategory {
  all("All"),
  since("Since"),
  dateRange("Date Range"),
  thisMonth("This Month"),
  lastMonth("Last Month"),
  lastWeek("Last Week"),
  lastThreeMonths("Last Three Months"),
  lastSixMonths("Last Six months");

  final String qualifiedName;

  const FilterCategory(this.qualifiedName);
}
