//
//  LAStudentCustomAnswerCell.m
//  MathFriendzyDummies
//
//  Created by Gaurav Rajput on 2014-08-25.
//  Copyright (c) 2014 Gaurav Rajput. All rights reserved.
//

#import "LAStudentCustomAnswerCell.h"

@implementation LAStudentCustomAnswerCell

@synthesize btnPlus;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initializeWithOwner:(id)owner type:(LAStudentCustomAnswerCellType)type{
    self.isSingleAnswerCell = NO ;
    self.cellType = type ;
    self.multiAnswerView.hidden = YES ;
    self.trueFalseView.hidden   = YES ;
    self.singleAnswerView.hidden = YES ;
    self.equationAnswerView.hidden = YES ;  // changed 06-02-2016 siddhi
    
    if (type == LAStudentCustomAnswerCellSingleAnswerType) {
        self.isSingleAnswerCell = YES ;
        self.txtMeasurementUnit.delegate = owner ;
        self.txtMeasurementUnitLeft.delegate = owner;
        self.txtQuestionNum.delegate     = owner ;
        self.txtStudentAnswer.delegate   = owner ;
        self.singleAnswerView.hidden = NO ;
    }else if(type == LAStudentCustomAnswerCellMultiChoiceType){
        self.multiAnswerView.hidden = NO ;
        self.txtMQuestionNumber.delegate = owner ;
    }else if (type == LAStudentCustomAnswerCellTrueFalseType || type == LAStudentCustomAnswerCellYesNoType){
        self.trueFalseView.hidden = NO ;
        self.txtTQuestionNumber.delegate = owner ;
    }else if (type == LAStudentCustomAnswerCellEquationType) { // changed 06-02-2016 siddhi added condition
        self.equationAnswerView.hidden = NO ;
        self.txtEQuestionNum.delegate = owner ;
    }
    
}
/*
- (void)setIsLeftPositionSelected:(BOOL)isLeftPositionSelected{
    NSLog(@"setIsLeftPositionSelected");
    _isLeftPositionSelected = isLeftPositionSelected ;
    [_btnLeftPosition setSelected:isLeftPositionSelected];
    [_btnRightPosition setSelected:!isLeftPositionSelected];
}*/


- (void)setEditable:(BOOL)editable
{
    self.txtQuestionNum.enabled     = NO ;
    self.txtTQuestionNumber.enabled = NO ;
    self.txtMQuestionNumber.enabled = NO ;
    UIImage *tempImage = nil ;
    if (editable) {
        tempImage = [UIImage imageNamed:@"unchecked_box.png"];
    }
    
    if (_cellType == LAStudentCustomAnswerCellSingleAnswerType) {
        
        self.txtMeasurementUnit.enabled = editable ;
        [self.txtMeasurementUnit setBackground:tempImage];
        
        self.txtMeasurementUnitLeft.enabled = editable;
        [self.txtMeasurementUnitLeft setBackground:tempImage];
        
        [self.txtQuestionNum setBackground:tempImage];
        
        self.txtStudentAnswer.enabled   = editable ;
        [self.txtStudentAnswer setBackground:tempImage];
    
        if(self.isLeftPositionSelected){
            self.txtMeasurementUnit.background = nil ;
            self.txtMeasurementUnitLeft.background   = nil ;
        }else{
            self.txtMeasurementUnit.background = nil ;
            self.txtMeasurementUnitLeft.background   = nil ;
        }
        
    }else if(_cellType == LAStudentCustomAnswerCellMultiChoiceType){
        [self.txtMQuestionNumber setBackground:tempImage];
        
//        for (LACheckboxButton *chBox in _buttons) {
//            chBox.userInteractionEnabled = editable;
//        }
        
        
    }else if (_cellType == LAStudentCustomAnswerCellTrueFalseType || _cellType == LAStudentCustomAnswerCellYesNoType){
        [self.txtTQuestionNumber setBackground:tempImage];
        
        self.btnChoiceFalse.userInteractionEnabled = editable ;
        self.btnChoiceTrue.userInteractionEnabled  = editable ;
    }
}


- (IBAction)onTapOption:(UIButton*)sender{
    [self endEditing:YES];
    if (sender == _btnChoiceTrue) {
        [_btnChoiceFalse setSelected:sender.selected];
        [sender setSelected:!sender.selected];
    }else if (sender == _btnChoiceFalse){
        [_btnChoiceTrue setSelected:sender.selected];
        [sender setSelected:!sender.selected];
    }
//    if ([_delegate respondsToSelector:@selector(trueFalseChoicesCell:selectedChoice:)]) {
//        [_delegate trueFalseChoicesCell:self selectedChoice:sender.titleLabel.text];
//    }
    
}

- (IBAction)onTapMultiOption:(UIButton*)sender{
    [self endEditing:YES];
    [sender setSelected:!sender.selected];
    if (sender.selected)
    {
//        if ([_choiceDelegate respondsToSelector:@selector(multipleChoiceCell:selectedChoice:)]) {
//            [_choiceDelegate multipleChoiceCell:self selectedChoice:sender.titleLabel.text];
//        }
    }else{
//        if ([_choiceDelegate respondsToSelector:@selector(multipleChoiceCell:deselectedChoice:)]) {
//            [_choiceDelegate multipleChoiceCell:self deselectedChoice:sender.titleLabel.text];
//        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
