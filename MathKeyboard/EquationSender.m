//
//  EquationSender.m
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 12/08/15.
//
//

#import "EquationSender.h"

#define val_student @"Student"
#define val_teacher @"Teacher"
#define val_tutor @"Tutor"


@implementation EquationSender

-(id)initWithEquation:(NSString*)eq_str andSenderType:(senderType)type
{
    if (!self) {
        self = [[EquationSender alloc]init];
    }
    self.equation = eq_str;
    self.senderTypeID = type;
    switch (type) {
        case type_student:
        {
            self.senderType = val_student;
            break;
        }
        case type_teacher:
        {
            self.senderType = val_teacher;
            break;
        }
        case type_tutor:
        {
            self.senderType = val_tutor;
            break;
        }
        default:
            break;
    }
    return self;
}

-(NSString*)getEquationStringWithEqationAndSenderType:(EquationSender*)eq_sender
{
    return [NSString stringWithFormat:@"%@%@%@",eq_sender.senderType,senderSeprator,eq_sender.equation];
}
-(EquationSender*)getEquationObjectWithEquationString:(NSString*)eq_string
{
    NSArray *a = [eq_string componentsSeparatedByString:senderSeprator];
    self.equation = [a objectAtIndex:1];
    self.senderType = [a objectAtIndex:0];
    return self;
}
@end
