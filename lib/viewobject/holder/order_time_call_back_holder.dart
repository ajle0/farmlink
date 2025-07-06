
class OrderTimeCallBackHolder {
  const OrderTimeCallBackHolder({
    required this.firstOrderTime,
    required this.secondOrderTime,
    this.selectedDateTime,
    this.selectedTimes,
  });
  final String firstOrderTime;
  final String secondOrderTime;
  final String? selectedTimes;
  final String? selectedDateTime;
}