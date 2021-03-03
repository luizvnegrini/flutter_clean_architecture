import 'package:faker/faker.dart';

import 'package:home_automation/domain/entities/entities.dart';
import 'package:home_automation/ui/pages/pages.dart';

class FakeSurveyResultFactory {
  static Map makeCacheJson() => {
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'true',
            'percent': '40',
          },
          {
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'false',
            'percent': '60',
          }
        ],
      };

  static Map makeInvalidCacheJson() => {
        'surveyId': faker.guid.guid(),
        'question': faker.lorem.sentence(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.lorem.sentence(),
            'isCurrentAnswer': 'invalid bool',
            'percent': 'invalid int',
          }
        ],
      };

  static Map makeIncompleteCacheJson() => {
        'surveyId': faker.guid.guid(),
      };

  static SurveyResultEntity makeEntity() => SurveyResultEntity(
        surveyId: faker.guid.guid(),
        question: faker.lorem.sentence(),
        answers: [
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: true,
            percent: 40,
            image: faker.internet.httpUrl(),
          ),
          SurveyAnswerEntity(
            answer: faker.lorem.sentence(),
            isCurrentAnswer: false,
            percent: 60,
          )
        ],
      );

  static SurveyResultViewModel makeViewModel() => const SurveyResultViewModel(
        surveyId: 'Any id',
        question: 'Question',
        answers: [
          SurveyAnswerViewModel(
            answer: 'Answer 0',
            isCurrentAnswer: true,
            percent: '60%',
            image: 'Image 0',
          ),
          SurveyAnswerViewModel(
            answer: 'Answer 1',
            isCurrentAnswer: false,
            percent: '40%',
          ),
        ],
      );

  static Map makeApiJson() => {
        'surveyId': faker.guid.guid(),
        'question': faker.randomGenerator.string(50),
        'date': faker.date.dateTime().toIso8601String(),
        'answers': [
          {
            'image': faker.internet.httpUrl(),
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
          {
            'answer': faker.randomGenerator.string(20),
            'percent': faker.randomGenerator.integer(100),
            'count': faker.randomGenerator.integer(1000),
            'isCurrentAccountAnswer': faker.randomGenerator.boolean(),
          },
        ]
      };

  static Map makeInvalidApiJson() => {'invalid_key': 'invalid_value'};
}
