import 'package:uuid/uuid.dart';
import 'package:varenya_mobile/models/daily_progress_data/daily_progress_data.model.dart';
import 'package:varenya_mobile/models/daily_progress_data/question_answer/question_answer.model.dart';

List<DailyProgressData> dummyData = [
  DailyProgressData(answers: [
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Little interest or pleasure in doing things?',
      answer: 'Today was better than yesterday actually',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling down, depressed, or hopeless?',
      answer: 'Nope not today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Trouble falling or staying asleep, or sleeping too much?',
      answer: 'Woke up early today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling tired or having little energy?',
      answer: 'Nope feeling energetic',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Poor appetite or overeating?',
      answer: 'Ate properly today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Feeling bad about yourself - or that you are a failure or have let yourself or your family down?',
      answer: 'Did a lot of stuff today so not today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Trouble concentrating on things, such as reading the newspaper or watching television?',
      answer: 'Yes',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?',
      answer: 'Nope',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Thoughts that you would be better off dead, or of hurting yourself in some way?',
      answer: 'Nope',
    ),
  ], moodRating: 5, createdAt: DateTime.now().subtract(Duration(days: 7))),
  DailyProgressData(answers: [
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Little interest or pleasure in doing things?',
      answer: 'Yeah...',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling down, depressed, or hopeless?',
      answer: 'Not much but yes',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Trouble falling or staying asleep, or sleeping too much?',
      answer: 'Could not sleep at al',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling tired or having little energy?',
      answer: 'Very very tired',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Poor appetite or overeating?',
      answer: 'Did not anything today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Feeling bad about yourself - or that you are a failure or have let yourself or your family down?',
      answer: 'Felt like shit today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Trouble concentrating on things, such as reading the newspaper or watching television?',
      answer: 'Yes, a lot',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?',
      answer: 'Yes...',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Thoughts that you would be better off dead, or of hurting yourself in some way?',
      answer: 'I wish I could die easily',
    ),
  ], moodRating: 2, createdAt: DateTime.now().subtract(Duration(days: 6))),
  DailyProgressData(answers: [
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Little interest or pleasure in doing things?',
      answer: 'Could not bring myself to do anything.',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling down, depressed, or hopeless?',
      answer: 'Yes alot',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Trouble falling or staying asleep, or sleeping too much?',
      answer: 'Could not sleep at all',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling tired or having little energy?',
      answer: 'Very very tired',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Poor appetite or overeating?',
      answer: 'Did not anything today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Feeling bad about yourself - or that you are a failure or have let yourself or your family down?',
      answer: 'Felt like shit today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Trouble concentrating on things, such as reading the newspaper or watching television?',
      answer: 'Yes, a lot',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?',
      answer: 'Yes...',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Thoughts that you would be better off dead, or of hurting yourself in some way?',
      answer: 'I wish I could die easily',
    ),
  ], moodRating: 1, createdAt: DateTime.now().subtract(Duration(days: 5))),
  DailyProgressData(answers: [
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Little interest or pleasure in doing things?',
      answer: 'Today was better than yesterday actually',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling down, depressed, or hopeless?',
      answer: 'Nope not today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Trouble falling or staying asleep, or sleeping too much?',
      answer: 'Woke up early today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling tired or having little energy?',
      answer: 'Nope feeling energetic',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Poor appetite or overeating?',
      answer: 'Ate properly today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Feeling bad about yourself - or that you are a failure or have let yourself or your family down?',
      answer: 'Did a lot of stuff today so not today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Trouble concentrating on things, such as reading the newspaper or watching television?',
      answer: 'Yes',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?',
      answer: 'Nope',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Thoughts that you would be better off dead, or of hurting yourself in some way?',
      answer: 'Nope',
    ),
  ], moodRating: 4, createdAt: DateTime.now().subtract(Duration(days: 4))),
  DailyProgressData(answers: [
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Little interest or pleasure in doing things?',
      answer: 'Could not bring myself to do anything.',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling down, depressed, or hopeless?',
      answer: 'Yes alot',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Trouble falling or staying asleep, or sleeping too much?',
      answer: 'Could not sleep at all',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling tired or having little energy?',
      answer: 'Very very tired',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Poor appetite or overeating?',
      answer: 'Did not anything today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Feeling bad about yourself - or that you are a failure or have let yourself or your family down?',
      answer: 'Felt like shit today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Trouble concentrating on things, such as reading the newspaper or watching television?',
      answer: 'Yes, a lot',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?',
      answer: 'Yes...',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Thoughts that you would be better off dead, or of hurting yourself in some way?',
      answer: 'I wish I could die easily',
    ),
  ], moodRating: 1, createdAt: DateTime.now().subtract(Duration(days: 3))),
  DailyProgressData(answers: [
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Little interest or pleasure in doing things?',
      answer: 'Could not bring myself to do anything.',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling down, depressed, or hopeless?',
      answer: 'Yes alot',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Trouble falling or staying asleep, or sleeping too much?',
      answer: 'Could not sleep at all',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling tired or having little energy?',
      answer: 'Very very tired',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Poor appetite or overeating?',
      answer: 'Did not anything today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Feeling bad about yourself - or that you are a failure or have let yourself or your family down?',
      answer: 'Felt like shit today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Trouble concentrating on things, such as reading the newspaper or watching television?',
      answer: 'Yes, a lot',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?',
      answer: 'Yes...',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Thoughts that you would be better off dead, or of hurting yourself in some way?',
      answer: 'I wish I could die easily',
    ),
  ], moodRating: 2, createdAt: DateTime.now().subtract(Duration(days: 2))),
  DailyProgressData(answers: [
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Little interest or pleasure in doing things?',
      answer: 'Today was better than yesterday actually',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling down, depressed, or hopeless?',
      answer: 'Nope not today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Trouble falling or staying asleep, or sleeping too much?',
      answer: 'Woke up early today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Feeling tired or having little energy?',
      answer: 'Nope feeling energetic',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question: 'Poor appetite or overeating?',
      answer: 'Ate properly today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Feeling bad about yourself - or that you are a failure or have let yourself or your family down?',
      answer: 'Did a lot of stuff today so not today',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Trouble concentrating on things, such as reading the newspaper or watching television?',
      answer: 'Yes',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Moving or speaking so slowly that other people could have noticed? Or the opposite - being so fidgety or restless that you have been moving around a lot more than usual?',
      answer: 'Nope',
    ),
    QuestionAnswer(
      id: Uuid().v4(),
      question:
          'Thoughts that you would be better off dead, or of hurting yourself in some way?',
      answer: 'Nope',
    ),
  ], moodRating: 5, createdAt: DateTime.now().subtract(Duration(days: 1))),
];
