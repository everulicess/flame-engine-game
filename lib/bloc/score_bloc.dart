

import 'package:flutter_bloc/flutter_bloc.dart';

class ScoreBloc extends Bloc<ScoreIncremented, int>{
    
    ScoreBloc() : super(0);
    

}
//Events
class ScoreIncremented {}