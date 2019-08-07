class Todo {
  Todo({ this.id, this.isComplete, this.title, this.text });

  int id;
  bool isComplete;
  String title;
  String text;

  Todo.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        isComplete = json['isComplete'],
        title = json['title'],
        text = json['text'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'isComplete': isComplete,
    'title': title,
    'text': text,
  };
}