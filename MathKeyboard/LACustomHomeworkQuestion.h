//
//  LACustomQuestion.h
//  MathFriendzyDummies
//
//  Created by Gaurav Rajput on 2014-08-19.
//  Copyright (c) 2014 Gaurav Rajput. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSObject+DictionaryRepresentation.h"

typedef NS_ENUM(NSUInteger, LAMultipleChoiceQuestionType){
    LAMultipleChoiceQuestionTypeNone = 0,
    LAMultipleChoiceQuestionTypeMultiChoice = 1,
    LAMultipleChoiceQuestionTypeTrueFalse   = 2,
    LAMultipleChoiceQuestionTypeYesNo      = 3
};

typedef enum
{
    LATeacherCreditNone = 1,
    LATeacherGivenNoCredit,
    LATeacherGivenHalfCredit,
    LATeacherGivenFullCredit
} LATEacherCreditGivenToStudentAnswer;

@interface LACustomHomeworkQuestion : NSObject

@property(copy,nonatomic)   NSString                      *questionNum ;
@property(assign,nonatomic) BOOL                          isFillInBlank ;
@property(assign,nonatomic) LAMultipleChoiceQuestionType  multipleChoiceQuestionType ;
@property(assign,nonatomic) BOOL                          isLeftMeasurement ;
@property(copy,nonatomic)   NSString                      *measurementUnit ;
@property(retain,nonatomic)   NSMutableArray                *answers ;
@property(retain,nonatomic)   NSMutableArray                *correctAnswers ;
@property (nonatomic, retain) NSString *workImage;
@property (nonatomic, retain) NSString *quesImage;
@property (nonatomic, retain) NSString *workTeacherMessage;

//Added by Siddhi infosoft.
@property(assign,nonatomic) BOOL isEquation;
@property(copy,nonatomic)   NSString *equationAnswer;

//end by Siddhi infosoft.

@property(assign,nonatomic) BOOL                          isAnswerAvailable;


@property short correctAttemptedStudentsCounter;
@property short wrongAttemptedStudentsCounter;

-(id)initWithDict:(NSDictionary *)dict;
-(id)initWithUserDefaultDict:(NSDictionary *)dict;

@end


@interface LACustomHwStudentAnswer : NSObject

@property   (copy,nonatomic)   NSString                      *questionNum ;
@property   (retain,nonatomic)   NSMutableArray              *answersGiven ;
@property   BOOL isAnswerGivenCorrect;
@property   (nonatomic, retain) NSString                     *workImageName;
@property   (nonatomic) BOOL wasAnswerWrongFirstTime;
@property   (nonatomic, strong) NSString *teacherCreditGiven;
@property   (nonatomic, strong) NSString *workAreaMessage;
@property   (nonatomic) BOOL gotHelpFromOthers;
@property   BOOL isWorkAreaPublic;
@property   BOOL haveSeenAnswer;
@property   (nonatomic, retain) NSString *questionImage;
@property   (nonatomic, strong) NSString *chatRequestId;

//second work area changes
@property   (nonatomic, retain) NSString *fwaWorkImageName;         //fwa means first work area or fixed work area on which user will not able to make any changes.
@property   (nonatomic, retain) NSString *fwaWorkAreaMessage;
@property   (nonatomic, retain) NSString *fwaQuestionImage;
@property BOOL opponentInput;           //To indicate if something was changes in tutor area by opponent (student or tutor).
@property BOOL workInput;               //To indicate if sowmthing was changed in the work area by student or teacher.

// Code Start By Siddhi infosoft.
@property   (nonatomic, retain) NSString *equationAnswersGiven;
@property   (retain,nonatomic)   NSMutableArray *equationStep ;
@property   (retain,nonatomic)   NSMutableArray *fixed_equationStep ;
// Code end By Siddhi infosoft.


-(id)initWithDict:(NSDictionary *)dict;
-(id)updateWithDict:(NSDictionary *)dict;

@end