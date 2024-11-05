

class InfoText {

  String title;  
  String value;
  String date;
  InfoText({required this.title, required this.value, this.date = ""});


  @override
  toString() {
    return "$title.$value.$date";
  }
}