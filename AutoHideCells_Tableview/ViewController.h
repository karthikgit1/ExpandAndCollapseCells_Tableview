//
//  ViewController.h
//  AutoHideCells_Tableview
//
//  Created by Vy Systems - iOS1 on 5/14/15.
//  Copyright (c) 2015 Vy Systems - iOS1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFolderTableView.h"
@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIFolderTableView *tableView;
@property (strong, nonatomic) NSArray *cates;
@end

