//
//  EquationSender.h
//  MathFriendzy
//
//  Created by Siddhi-macmini-2 on 12/08/15.
//
//


#define senderSeprator @"&&&"

typedef enum : NSUInteger {
    type_student =1,
    type_teacher,
    type_tutor,
} senderType;

#import <Foundation/Foundation.h>

@interface EquationSender : NSObject

@property (nonatomic,strong) NSString *equation;
@property (nonatomic,strong) NSString *senderType;
@property (nonatomic) senderType senderTypeID;

-(id)initWithEquation:(NSString*)eq_str andSenderType:(senderType)type;
-(EquationSender*)getEquationObjectWithEquationString:(NSString*)eq_string;
-(NSString*)getEquationStringWithEqationAndSenderType:(EquationSender*)eq_sender;

@end
