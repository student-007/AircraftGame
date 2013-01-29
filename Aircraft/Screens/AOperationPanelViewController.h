//
//  AOperationPanelViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 1/14/13.
//  Copyright (c) 2013 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AGameOrganizer.h"
#import "AAircraftHolderImageView.h"
#import "NSString+Format.h"

@protocol AOperationPanelViewControllerViewDelegate;
@protocol  AOperationPanelViewControllerOperationDelegate;

@interface AOperationPanelViewController : UIViewController

@property (assign, nonatomic) id<AOperationPanelViewControllerViewDelegate>viewDelegate;
@property (assign, nonatomic) id<AOperationPanelViewControllerOperationDelegate>operationDelegate;

@property (strong, nonatomic) IBOutlet UIView *aircraftHolderView;
@property (strong, nonatomic) IBOutlet UIImageView *aircraftHolderBkgd;
@property (strong, nonatomic) IBOutlet UIView *operationPanelView;
@property (strong, nonatomic) IBOutlet UIImageView *operationPanelBkgd;
@property (strong, nonatomic) IBOutlet UIView *statusView;
@property (strong, nonatomic) IBOutlet UIImageView *turnIndicatorImgView;
@property (strong, nonatomic) IBOutlet UIImageView *timeIndicatorImgView;
@property (strong, nonatomic) IBOutlet UILabel *turnLabel;
@property (strong, nonatomic) IBOutlet UILabel *turnTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *playTotalTimeLabel;

@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGestureRecognizerUp;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGestureRecognizerDown;
// aircraft holders
@property (strong, nonatomic) IBOutlet AAircraftHolderImageView *aircraftUpHolderImgView;
@property (strong, nonatomic) IBOutlet AAircraftHolderImageView *aircraftDownHolderImgView;
@property (strong, nonatomic) IBOutlet AAircraftHolderImageView *aircraftLeftHolderImgView;
@property (strong, nonatomic) IBOutlet AAircraftHolderImageView *aircraftRightHolderImgView;

@property (strong, nonatomic) IBOutlet AUIButton *readyButton;
@property (strong, nonatomic) IBOutlet AUIButton *exitButton;
@property (strong, nonatomic) IBOutlet AUIButton *switchButton;
@property (strong, nonatomic) IBOutlet AUIButton *tool1Button;
@property (strong, nonatomic) IBOutlet AUIButton *tool2Button;
@property (strong, nonatomic) IBOutlet AUIButton *attackButton;

/*!
 @discussion start timeing the time
 */
- (void)startTheGame;

/*!
 @discussion stop timeing the time
 */
- (void)endTheGame;

/*!
 @discussion based on the property "whosTurn" in game organizer
 */
- (void)switchTurn;

@end

#pragma mark - view delegate

@protocol AOperationPanelViewControllerViewDelegate <NSObject>
@required
- (void)userWantsToExit;
- (void)pressedAircraftHolderImg:(UILongPressGestureRecognizer *)longPressRecognizer;
- (void)aircraftHolderDraging:(UIPanGestureRecognizer *)panRecognizer;
@end

#pragma mark - operation delegate

@protocol  AOperationPanelViewControllerOperationDelegate <NSObject>
@required
- (BOOL)userReadyPlacingAircrafts;
- (void)userWantsToExit;
- (void)userPressedTool1Button;
- (void)userPressedTool2Button;
- (void)userPressedAttackButton;

@end