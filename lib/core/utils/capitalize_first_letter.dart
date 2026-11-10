
String capitalizeFirstLetter(String name){
  if (name.isEmpty) return '';
  var n = name[0];
  var ame = name.substring(1);
  return n.toUpperCase()+ame.toLowerCase();
}