//
//  LAStudentCustomAnswerCell.h
//  MathFriendzyDummies
//
//  Created by Gaurav Rajput on 2014-08-25.
//  Copyright (c) 2014 Gaurav Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, LAStudentCustomAnswerCellType){
    LAStudentCustomAnswerCellSingleAnswerType = 1,
    LAStudentCustomAnswerCellMultiChoiceType  = 2,
    LAStudentCustomAnswerCellTrueFalseType    = 3,
    LAStudentCustomAnswerCellYesNoType        = 4,
    LAStudentCustomAnswerCellEquationType        = 5//added by siddhi infosoft
};

@interface LAStudentCustomAnswerCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIView *equationAnswerView;//added by siddhi infosoft
@property (retain, nonatomic) IBOutlet UITextField *txtEQuestionNum;//added by siddhi infosoft
@property (weak, nonatomic) IBOutlet UIScrollView *updateScroll;//added by siddhi infosoft also changes done in XIB
@property (retain, nonatomic) IBOutlet UILabel *lblmeasurementUnit;//added by siddhi infosoft also changes done in XIB

@property (retain, nonatomic) IBOutlet UIView *singleAnswerView;

@property (retain, nonatomic) IBOutlet UITextField *txtQuestionNum;
@property (retain, nonatomic) IBOutlet UITextField *txtStudentAnswer;
@property (retain, nonatomic) IBOutlet UITextField *txtMeasurementUnit;
@property (retain, nonatomic) IBOutlet UITextField *txtMeasurementUnitLeft;
@property(assign,nonatomic) BOOL isLeftPositionSelected ;

@property (retain, nonatomic) IBOutlet UIView *multiAnswerView;
@property (retain, nonatomic) IBOutlet UITextField *txtMQuestionNumber;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;

@property (retain, nonatomic) IBOutlet UIButton *btnPlus;

@property (retain, nonatomic) IBOutlet UIView *trueFalseView;
@property (retain, nonatomic) IBOutlet UITextField *txtTQuestionNumber;
@property (retain, nonatomic) IBOutlet UIButton *btnChoiceTrue;
@property (retain, nonatomic) IBOutlet UIButton *btnChoiceFalse;

@property(assign,nonatomic) BOOL isTrueAnswer ;
@property(assign,nonatomic) BOOL isSingleAnswerCell ;

@property(assign,nonatomic) LAStudentCustomAnswerCellType cellType ;


@property (strong, nonatomic) UIView *editMenu ;


@property (weak, nonatomic) IBOutlet UIButton *btnCounterStudents;

// Methods

- (void)initializeWithOwner:(id)owner type:(LAStudentCustomAnswerCellType)type ;

- (void)setEditable:(BOOL)editable ;

@end
