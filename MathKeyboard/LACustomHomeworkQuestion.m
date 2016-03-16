//
//  LACustomQuestion.m
//  MathFriendzyDummies
//
//  Created by Gaurav Rajput on 2014-08-19.
//  Copyright (c) 2014 Gaurav Rajput. All rights reserved.
//

#import "LACustomHomeworkQuestion.h"

@implementation LACustomHomeworkQuestion

- (id)init{
    self = [super init];
    if (self) {
        self.questionNum                = @"" ;
        self.answers                    = [NSMutableArray new] ;
        self.correctAnswers             = [NSMutableArray new] ;
        self.measurementUnit            = @"" ;
        self.multipleChoiceQuestionType = LAMultipleChoiceQuestionTypeNone ;
        self.isFillInBlank              = YES ;
        self.isLeftMeasurement          = NO ;
        self.workImage                  = @"";
        self.quesImage                  = @"";
        self.workTeacherMessage         = @"";
        self.isAnswerAvailable          = YES;
        
        //code start by Siddhi infosoft.
        
        self.equationAnswer            = @"" ;
        self.isEquation                 = NO ;
        
        //code end by Siddhi infosoft.
    }
    return self ;
}

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.questionNum                = [dict objectForKey:@"quesNum"] ;
        self.answers                    = [[[dict objectForKey:@"options"] componentsSeparatedByString:@","] mutableCopy] ;
        self.correctAnswers             = [[[dict objectForKey:@"correctAns"] componentsSeparatedByString:@","] mutableCopy] ;
        self.measurementUnit            = [dict objectForKey:@"ansSuffix"] ;
        self.multipleChoiceQuestionType = [[dict objectForKey:@"answerType"] integerValue] ;
        self.isFillInBlank              = [[dict objectForKey:@"fillInType"] boolValue] ;
        self.isLeftMeasurement          = [[dict objectForKey:@"isLeftUnit"] boolValue] ;
        self.isAnswerAvailable          = [[dict objectForKey:@"ansAvailable"] boolValue];
        
        //code start by Siddhi infosoft.
        
        self.equationAnswer            = [dict objectForKey:@"equationAnswer"] ;
        self.isEquation                 = [[dict objectForKey:@"isEquation"] boolValue] ;
        
        //code end by Siddhi infosoft.
    }
    return self ;
}


-(id)initWithUserDefaultDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.questionNum                = [dict objectForKey:@"questionNum"] ;
        self.answers                    = [dict objectForKey:@"answers"] ;
        self.correctAnswers             = [dict objectForKey:@"correctAnswers"] ;
        self.measurementUnit            = [dict objectForKey:@"measurementUnit"] ;
        self.multipleChoiceQuestionType = [[dict objectForKey:@"multipleChoiceQuestionType"] integerValue] ;
        self.isFillInBlank              = [[dict objectForKey:@"isFillInBlank"] boolValue] ;
        self.isLeftMeasurement          = [[dict objectForKey:@"isLeftMeasurement"] boolValue] ;
        self.workImage                  = [dict objectForKey:@"workImage"] ;
        self.quesImage                  = [dict objectForKey:@"quesImage"] ;
        self.workTeacherMessage         = [dict objectForKey:@"workTeacherMessage"] ;
        self.isAnswerAvailable          = [[dict objectForKey:@"isAnswerAvailable"] boolValue];
    }
    return self ;
}

@end


@implementation LACustomHwStudentAnswer

@synthesize questionNum, answersGiven, isAnswerGivenCorrect, workImageName, wasAnswerWrongFirstTime, teacherCreditGiven, workAreaMessage, gotHelpFromOthers, isWorkAreaPublic, haveSeenAnswer, questionImage, chatRequestId;
//second work area changes
@synthesize fwaQuestionImage, fwaWorkAreaMessage, fwaWorkImageName, workInput;

-(id)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.questionNum                = [dict objectForKey:@"quesNum"] ;
        
        //siddhi infosoft - Start
        
        self.equationAnswersGiven = [dict objectForKey:@"equAns"] ;
        if (self.equationAnswersGiven==nil)
        {
            self.equationAnswersGiven = @"";
        }
        
        self.equationStep               = [dict objectForKey:@"equation"] ;
        if (self.equationStep==nil||[self.equationStep isKindOfClass:[NSNull class]])
        {
            self.equationStep = [[NSMutableArray alloc]init];
        }
        if ([self.equationStep isKindOfClass:[NSMutableArray class]]) {
            
        }
        else
        {
            self.equationStep = [[NSMutableArray alloc]init];
        }
        self.fixed_equationStep         = [dict objectForKey:@"fixed_equation"];
        
        //Siddhi infosoft - end.
        
        self.answersGiven               = [[[dict objectForKey:@"answer"] componentsSeparatedByString:@","] mutableCopy] ;
        self.isAnswerGivenCorrect       = [[dict objectForKey:@"isCorrect"] boolValue] ;
        self.workImageName              = [dict objectForKey:@"workImage"];
        self.wasAnswerWrongFirstTime    = [[dict objectForKey:@"firstTimeWrong"] boolValue];
        self.teacherCreditGiven         = [dict objectForKey:@"teacher_credit"];
        self.workAreaMessage            = [dict objectForKey:@"message"];
        self.gotHelpFromOthers          = [[dict objectForKey:@"getHelp"] boolValue];
        self.isWorkAreaPublic           = [[dict objectForKey:@"workAreaPublic"] boolValue];
        self.questionImage              = [dict objectForKey:@"questionImage"];
        self.chatRequestId              = [dict objectForKey:@"chatRequestId"];
        
        //second work area changes
        self.fwaWorkImageName           = [dict objectForKey:@"fixedWorkImage"];
        self.fwaWorkAreaMessage         = [dict objectForKey:@"fixedMessage"];
        self.fwaQuestionImage           = [dict objectForKey:@"fixedQuestionImage"];
        //added by ashiwani
//        if(LOGS_ON) NSLog(@"dic print of pppp%@",dict);
        
        self.opponentInput = [[dict objectForKey:@"opponentInput"] boolValue];
        self.workInput = [[dict objectForKey:@"workInput"] boolValue];
        
        //code start by siddhi infosoft.
        self.equationAnswersGiven = [dict objectForKey:@"equAns"] ;
        self.equationStep               = [dict objectForKey:@"equation"] ;
        self.fixed_equationStep               = [dict objectForKey:@"fixed_equation"];
        //code end by siddhi infosoft.
        
    }
    return self ;
}

-(id)updateWithDict:(NSDictionary *)dict
{
    if (self) {
        self.questionNum                = [dict objectForKey:@"quesNum"] ;
        self.answersGiven               = [[[dict objectForKey:@"answer"] componentsSeparatedByString:@","] mutableCopy] ;
        self.isAnswerGivenCorrect       = [[dict objectForKey:@"isCorrect"] boolValue] ;
        self.workImageName              = [dict objectForKey:@"workImage"];
        self.wasAnswerWrongFirstTime    = [[dict objectForKey:@"firstTimeWrong"] boolValue];
        self.teacherCreditGiven         = [dict objectForKey:@"teacher_credit"];
        self.workAreaMessage            = [dict objectForKey:@"message"];
        self.gotHelpFromOthers          = [[dict objectForKey:@"getHelp"] boolValue];
        self.isWorkAreaPublic           = [[dict objectForKey:@"workAreaPublic"] boolValue];
        self.questionImage              = [dict objectForKey:@"questionImage"];
        self.chatRequestId              = [dict objectForKey:@"chatRequestId"];
        
        //second work area changes
        self.fwaWorkImageName           = [dict objectForKey:@"fixedWorkImage"];
        self.fwaWorkAreaMessage         = [dict objectForKey:@"fixedMessage"];
        self.fwaQuestionImage           = [dict objectForKey:@"fixedQuestionImage"];
        
        self.opponentInput = [[dict objectForKey:@"opponentInput"] boolValue];
    }
    return self ;
}


//second work area changes
-(void)setGotHelpFromOthers:(BOOL)gotHelp
{
    NSString *fixedWorkAreaPrefix = @"fwa_";
    //If user got the help first time for the question then work area image, messages in text area and question image will be copied over to fixed work area (fwa) properties so that we can create second work area for the player which will be used for further changes.
    if(gotHelpFromOthers == 0)
    {
        gotHelpFromOthers = gotHelp;
        if(workImageName != nil && [workImageName isEqualToString:@""] == NO)
            fwaWorkImageName = [NSString stringWithFormat:@"%@%@", fixedWorkAreaPrefix, workImageName];
        fwaWorkAreaMessage = workAreaMessage;
        if(questionImage != nil && [questionImage isEqualToString:@""] == NO)
            fwaQuestionImage = [NSString stringWithFormat:@"%@%@", fixedWorkAreaPrefix, questionImage];
    }
}

-(void)setWasAnswerWrongFirstTime:(BOOL)wasWrongInitially
{
    NSString *fixedWorkAreaPrefix = @"fwa_";
    //If user got the help first time for the question then work area image, messages in text area and question image will be copied over to fixed work area (fwa) properties so that we can create second work area for the player which will be used for further changes.
    if(wasAnswerWrongFirstTime == 0 && wasWrongInitially)
    {
        wasAnswerWrongFirstTime = wasWrongInitially;
        if(workImageName != nil && [workImageName isEqualToString:@""] == NO)
            fwaWorkImageName = [NSString stringWithFormat:@"%@%@", fixedWorkAreaPrefix, workImageName];
        fwaWorkAreaMessage = workAreaMessage;
        if(questionImage != nil && [questionImage isEqualToString:@""] == NO)
            fwaQuestionImage = [NSString stringWithFormat:@"%@%@", fixedWorkAreaPrefix, questionImage];
    }
}

@end


