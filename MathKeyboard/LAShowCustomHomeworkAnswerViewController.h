//
//  LAShowCustomHomeworkAnswerViewController.h
//  MathFriendzyDummies
//
//  Created by Gaurav Rajput on 2014-08-22.
//  Copyright (c) 2014 Gaurav Rajput. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BJImageCropper.h" // 14-03-2016

//#import "ChatViewController.h" // 14-03-2016
//#import "LAChatRequest.h"           //Chatting Changes // 14-03-2016

typedef enum{
    LAAlertShowForTeacherCredit,
    LAAlertShowForCalculate,
    LAAlertShowForStudentWorkArea,
    LAAlertShowFOrAnswerSubmitOnBack
} AlertType;

@interface LAShowCustomHomeworkAnswerViewController : UIViewController<UIScrollViewDelegate> // // 14-03-2016 remove HTTPConnectDelegate

{
    IBOutlet UIButton *btnSubmit;
    
    IBOutlet UIView     *hwScoreView;
    IBOutlet UILabel    *lblTotalQuestions;
    IBOutlet UILabel    *lblZeroCredit;
    IBOutlet UILabel    *lblHalfCredit;
    IBOutlet UILabel    *lblFullCredit;
    IBOutlet UILabel    *lblAverageScore;
    
    IBOutlet UILabel    *lblZeroColor;
    IBOutlet UILabel    *lblHalfColor;
    IBOutlet UILabel    *lblFullColor;
    IBOutlet UILabel    *lblZeroColorIndicator;
    IBOutlet UILabel    *lblHalfColorIndicator;
    IBOutlet UILabel    *lblFullColorIndicator;
    IBOutlet UILabel    *lblStudentViewAnswer;
    IBOutlet UILabel    *lblViewAnswerColor;
    
    IBOutlet UILabel *lblCorrectAnswer;
    IBOutlet UILabel *lblYouMustNowGoToWork;
    
    IBOutlet UIButton *btnGetHelp;
    IBOutlet UIButton *btnWorkArea;
    IBOutlet UIView   *seeAnswerView;
    
    //Add photo changes
    IBOutlet UIButton *btnViewSheets;
    IBOutlet UIButton *btnSelectPhoto;
    IBOutlet UIView   *cutCopyImgView;
    
    IBOutlet UIButton *btnCounterInfo;
    IBOutlet UIButton *btnSortQuestions;
    IBOutlet UIButton *btnRequestTutor;
    IBOutlet UIButton *btnSeeAnswer;
    
    UIWebView *pdfWebView;
    short pdfPageCounter, pdfPageNumber;
    BOOL shouldShowPopUpForCrop;
    
//    LAKeyboardForCustomHw *keypad; // 14-03-2016
//    LACustomHomeworkStudentRecord *customHwDetails; // 14-03-2016
    
    NSMutableIndexSet *tempIndexesForAnswers, *tempNotesAddedToAnswers, *workAreaSavedIndexes;
    
//    HTTPConnect *con; // 14-03-2016
    
    short currentRowSelected, score;
//    LAAlertView *alertView ; // 14-03-2016
    short currentTxtFieldRowNum;
    
    BOOL isCalledFromCalculateBtn, shouldSaveOnBack;
    UIImageView *imgView;
    
//    LAChatRequest *chatRequest;     //Chatting Changes // 14-03-2016
//    CustomActivityIndicator *customHudView; // 14-03-2016
    
//    LAAnswerCheckView *tempAnsView; // 14-03-2016
//    ChatViewController *chatViewCtr; // 14-03-2016
//    HTTPConnect *conUploadImage, *conUploadQuesImage; // 14-03-2016
    
//    WorkAreaViewController *firstWorkAreaViewController; // 14-03-2016
    
    //Code start by siddhi infosoft.
    
    LANewCustomKeyboard *new_keypad;
    UIScrollView *updateView;
    UITextField *activeTextfield;
    UITextField *updateTextField;
    
    CAShapeLayer *layer;
    float verticalContentOffsetForTable ;
    BOOL isFromKeyboardHide;
    
    //Code end by siddhi infosoft.
    
    BOOL    isIpad;
}

@property (retain, nonatomic) IBOutlet UILabel *lblTeacherName;
@property (retain, nonatomic) IBOutlet UILabel *lblGrade;
@property (retain, nonatomic) IBOutlet UILabel *lblDueDate;
@property (retain, nonatomic) IBOutlet UILabel *lblUnitMeasureMsg;

@property (retain, nonatomic) IBOutlet UILabel *lblTeacherNameVal;
@property (retain, nonatomic) IBOutlet UILabel *lblGradeVal;
@property (retain, nonatomic) IBOutlet UILabel *lblDueDateVal;
@property (retain, nonatomic) IBOutlet UILabel *lblStudentAnswer;

@property(retain,nonatomic) NSMutableArray        *tableDataSource ;

@property(assign,nonatomic) BOOL isEditable ;

@property (nonatomic, copy) NSString *studentName;
@property short hwGrade;
@property (nonatomic, copy) NSString *hwDate;
@property (nonatomic, retain) NSMutableArray *playerAnswers;
@property (nonatomic, copy) NSString *hwTitle;

@property BOOL isTeacherView;
@property long long selectedHwId;
@property short numOfProblems;

@property long customHomeworkId;

//@property LAHomeworkPlayerInfo *playerInfo;  // 14-03-2016

//@property (nonatomic, retain) LAHomeworkScoreDetails *tempScoreInfo;  // 14-03-2016



-(IBAction)getHelpBtnClicked:(id)sender;
-(IBAction)workAreaBtnClicked:(id)sender;

-(IBAction)submitBtnClicked:(id)sender;

//-(void)assignCustomHwDetails:(LACustomHomeworkStudentRecord *)custHw; // 14-03-2016

//Add photo changes
//@property (nonatomic, retain) BJImageCropper *imageCropper; // 14-03-2016

-(IBAction)viewHomeworkSheetsBtnClicked:(id)sender;
-(IBAction)selectOrCutPhotoBtnClicked:(UIButton *)sender;

//Chatting Changes
-(IBAction)connectWithTutorBtnClicked:(id)sender;

-(IBAction)counterInfoBtnClicked:(id)sender;

//second work area changes
-(void)addSecondWorkAreaToWorkAreaScreen;
-(void)setGotHelpForQuestionAfterTutorSessionCreated;

//update the pencil color when student visit once in tutor area
-(void)updateOpponentInputValue;

-(void)setTutorResponseFromNotificationForQuestionWithReqId:(NSString *)chatReqId;

@end
