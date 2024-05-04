class Video {
  String url;
  String videoTitle;
  String description;
  String category;
  String location;

  Video({
    required this.url,
    required this.videoTitle,
    required this.description,
    required this.category,
    required this.location,
  });

  Map<String,dynamic>toJson()=>{
    "url":url,
    "videoTitle":videoTitle,
    "description":description,
    "category":category,
    "location":location
  };
}
