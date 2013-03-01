//
//  ALoadSavedGameScreenViewController.h
//  Aircraft
//
//  Created by Yufei Lang on 13-2-20.
//  Copyright (c) 2013年 Yufei Lang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGameRecordManager.h"
#import "ASavedRecordItem.h"
#import "APlayScreenViewController.h"

@interface ALoadSavedGameScreenViewController : UIViewController
{
    NSMutableArray *_recentUnsavedRecords;
    NSMutableArray *_savedRecords;
}
@property (strong, nonatomic) IBOutlet ATableViewAdapter *tableViewAdapter;

@property (weak, nonatomic) IBOutlet UIImageView *bkgImageView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *recentUnsavedPanel;
@property (strong, nonatomic) IBOutlet UIView *savedGamePanel;

@property (strong, nonatomic) IBOutlet UILabel *recentUnsavedGameLabel;
@property (strong, nonatomic) IBOutlet UILabel *savedGameLabel;

@end
