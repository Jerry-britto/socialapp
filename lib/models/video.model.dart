class Video {
  String url;
  String videoTitle;
  String description;
  String category;
  String location;
  String user;

  Video({
    required this.url,
    required this.videoTitle,
    required this.description,
    required this.category,
    required this.location,
    required this.user
  });

  Map<String,dynamic>toJson()=>{
    "user":user,
    "url":url,
    "videoTitle":videoTitle,
    "description":description,
    "category":category,
    "location":location
  };
}
