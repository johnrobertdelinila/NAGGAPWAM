
import 'package:jiffy/jiffy.dart';
import 'package:stacked/stacked.dart';


enum TestReportState { Initial, Positive, Nagative }

class TestReportViewModel extends BaseViewModel {
  // final NavigationService _navigationService = locator<NavigationService>();
  TestReportState _reportState = TestReportState.Initial;
  DateTime _reportDate = DateTime.now();

  TestReportState get reportState {
    return _reportState;
  }

  set reportState(TestReportState result) {
    _reportState = result;
    notifyListeners();
  }

  set reportDate(DateTime date) {
    _reportDate = date;
    notifyListeners();
  }

  String getReportDate() {
    DateTime date = _reportDate;
    return Jiffy(date.toString()).yMMMMd;
  }

  void closePage() {
    // _navigationService.back();
  }

  Future navigateToConfirmReportPage() async {
    // await _navigationService.navigateWithTransition(ConfirmReportView(), transition: 'downToUp');
  }
}
