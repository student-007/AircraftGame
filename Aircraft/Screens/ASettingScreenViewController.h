//
//  ASettingScreenViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-10.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGuideViewController.h"
#import "ASetting.h"

@interface ASettingScreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet ATableViewAdapter *tableViewAdapter;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *bkgImageView;

@property (strong, nonatomic) IBOutlet UISwitch *showGuideSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *soundMusicSwitch;

@property (strong, nonatomic) IBOutlet UIView *userPreferenceSessionTitlePanel;
@property (strong, nonatomic) IBOutlet UIView *informationSessionTitlePanel;

@property (strong, nonatomic) IBOutlet UIView *showGuidesPanel;
@property (strong, nonatomic) IBOutlet UIView *soundMusicPanel;
@property (strong, nonatomic) IBOutlet UIView *languagePanel;
@property (strong, nonatomic) IBOutlet UIView *aboutPanel;
@property (strong, nonatomic) IBOutlet UIView *helpSupportPanel;

@end
