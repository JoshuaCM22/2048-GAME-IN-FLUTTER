class Score {
  final int id;
  final String scoreDate;
  final int userScore;

  Score({this.id, this.scoreDate, this.userScore});

  Map<String, dynamic> toMap() {
    return {
      'scoreDate': scoreDate,
      'userScore': userScore,
    };
  }

  @override
  String toString() {
    return '$userScore,$scoreDate,$id';
  }
}
