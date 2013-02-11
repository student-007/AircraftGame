//
//  ALanguageScreenViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-11.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASetting.h"

@interface ALanguageScreenViewController : UIViewController

@property (strong, nonatomic) IBOutlet ATableViewAdapter *tableViewAdapter;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet UIView *languageEnglishPanel;
@property (strong, nonatomic) IBOutlet UIView *languageSimplifiedChinesePanel;

@property (strong, nonatomic) IBOutlet UIImageView *checkMarkImgViewSimplifiedChinese;
@property (strong, nonatomic) IBOutlet UIImageView *checkMarkImgViewEnglish;

@end
