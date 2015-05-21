//
//  ViewController.m
//  AutoHideCells_Tableview
//
//  Created by Vy Systems - iOS1 on 5/14/15.
//  Copyright (c) 2015 Vy Systems - iOS1. All rights reserved.
//

#import "ViewController.h"
#import "SubCateViewController.h"
#import "CateTableCell.h"
@interface ViewController ()<UIFolderTableViewDelegate>
@property (strong, nonatomic) SubCateViewController *subVc;
@property (strong, nonatomic) NSDictionary *currentCate;
@end

@implementation ViewController
@synthesize cates=_cates;
@synthesize subVc=_subVc;
@synthesize currentCate=_currentCate;
@synthesize tableView=_tableView;


-(NSArray *)cates
{
    if (_cates == nil){
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Category" withExtension:@"plist"];
        _cates = [NSArray arrayWithContentsOfURL:url];
        
    }
    
    return _cates;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.cates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cate_cell";
    
    CateTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CateTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    NSDictionary *cate = [self.cates objectAtIndex:indexPath.row];
    cell.logo.image = [UIImage imageNamed:[[cate objectForKey:@"imageName"] stringByAppendingString:@".png"]];
    cell.title.text = [cate objectForKey:@"name"];
    
    NSMutableArray *subTitles = [[NSMutableArray alloc] init];
    NSArray *subClass = [cate objectForKey:@"subClass"];
    for (int i=0; i < MIN(4,  subClass.count); i++) {
        [subTitles addObject:[[subClass objectAtIndex:i] objectForKey:@"name"]];
    }
    cell.subTtile.text = [subTitles componentsJoinedByString:@"/"];
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SubCateViewController *subVc = [[SubCateViewController alloc]
                                     initWithNibName:NSStringFromClass([SubCateViewController class])
                                     bundle:nil];
    NSDictionary *cate = [self.cates objectAtIndex:indexPath.row];
    subVc.subCates = [cate objectForKey:@"subClass"];
    self.currentCate = cate;
    subVc.cateVC = self;
    
    self.tableView.scrollEnabled = NO;
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:subVc.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                }
                           completionBlock:^{
                               // completed actions
                               self.tableView.scrollEnabled = YES;
                           }];
    
}

-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)subCateBtnAction:(UIButton *)btn
{
    
    NSDictionary *subCate = [[self.currentCate objectForKey:@"subClass"] objectAtIndex:btn.tag];
    NSString *name = [subCate objectForKey:@"name"];
    UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"子类信息"
                                                         message:[NSString stringWithFormat:@"名称:%@, ID: %@", name, [subCate objectForKey:@"classID"]]
                                                        delegate:nil
                                               cancelButtonTitle:@"确认"
                                               otherButtonTitles:nil];
    [Notpermitted show];
   
}


@end
