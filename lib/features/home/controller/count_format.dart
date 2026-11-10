String countFormat(String value){
  if(value.length <= 3) {
    return value;
  }
  else {
    return '${value[0]} ${value.substring(1)}';
  }
}