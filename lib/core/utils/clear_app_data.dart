
import 'package:hive_flutter/adapters.dart';

Future clearAppData(Box<bool> bools, Box<Map> maps)async{
  // bools.put('sessionExpired', true);
  // bools.put('isSignedIn', false);
}


void logout(context,{required Box iNPAYBox,required Box<bool> boolsBox,required Box<Map> mapsBox,
required Box<List> listsBox,required Box<int> intsBox})async{
  try{
    // Clear all the data in each box
    await iNPAYBox.clear();
    await boolsBox.clear();
    await mapsBox.clear();
    await listsBox.clear();
    await intsBox.clear();

    // navigateBackTo(context, OnboardingAll());
  }catch(e){}
}