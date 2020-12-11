class AppNotification{
  final String id;
  final String title;
  final String body;
  final String activityId;
  final String userId;

  AppNotification({this.id, this.title, this.body, this.activityId, this.userId});

  AppNotification.fromData(Map<String, dynamic> data)
      :id= data['id'],
        title= data['title'],
      body = data['body'],
      activityId= data['activityId'],
      userId= data['userId'];

  Map<String, dynamic> toJson(){
    return {
      'title': title,
      'body': body,
      'activityId' : activityId,
      'userId' : userId,
    };
  }

  static AppNotification fromMap(Map<String, dynamic> map, String id) {
    if (map == null) return null;
    return AppNotification(
        id: id,
        title: map['title'],
        body: map['body'],
        activityId: map['activityId'],
        userId: map['userId']
    );
  }
}