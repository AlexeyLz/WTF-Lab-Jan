class Event {
  int eventId;
  int currentNoteId;
  String text;
  String time;
  int circleAvatarIndex;
  String imagePath;
  String date;

  Event({
    this.eventId,
    this.currentNoteId,
    this.text,
    this.time,
    this.circleAvatarIndex,
    this.imagePath,
    this.date,
  });

  Map<String, dynamic> convertEventToMap() {
    return {
      'current_note_id': currentNoteId,
      'text': text,
      'time': time,
      'event_circle_avatar_index': circleAvatarIndex,
      'image_path': imagePath,
      'date': date,
    };
  }

  Map<String, dynamic> convertEventToMapWithId() {
    return {
      'event_id': eventId,
      'current_note_id': currentNoteId,
      'text': text,
      'time': time,
      'event_circle_avatar_index': circleAvatarIndex,
      'image_path': imagePath,
      'date': date,
    };
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      eventId: map['event_id'],
      currentNoteId: map['current_note_id'],
      text: map['text'],
      time: map['time'],
      circleAvatarIndex: map['event_circle_avatar_index'],
      imagePath: map['image_path'],
      date: map['date'],
    );
  }
}
