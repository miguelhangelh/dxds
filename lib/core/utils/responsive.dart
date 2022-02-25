
part of 'utils.dart';

class Responsive {

  double? _width, _height, _diagonal;
  bool? _isTable;

  double? get width    => this._width;
  double? get height   => this._height;
  double? get diagonal => this._diagonal;
  bool?   get isTable  => _isTable;

  static Responsive of( BuildContext context ) => Responsive( context );

  Responsive( BuildContext context ) {
    final Size size = MediaQuery.of( context ).size;
    this._width = size.width;
    this._height = size.height;
    
    this._diagonal = math.sqrt( math.pow( this._width!, 2 ) + math.pow( this._height!, 2 ) );

    this._isTable = size.shortestSide >= 600;

  }

  double wp( double percent ) => this._width! * percent / 100;
  double hp( double percent ) => this._height! * percent / 100;
  double dp( double percent ) => this._diagonal! * percent / 100;

}