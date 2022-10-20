part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const home = _Paths.home;
  static const notFound = _Paths.notFound;
}

abstract class _Paths {
  _Paths._();

  static const home = '/home';
  static const notFound = '/unknown';
}
