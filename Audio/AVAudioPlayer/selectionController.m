//
//  selectionController.m
//  AVAudioPlayer
//
//  Created by Mac on 15-8-10.
//  Copyright (c) 2015年 wqf. All rights reserved.
//

#import "selectionController.h"

@interface selectionController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArr;
    UITableView *_myTableView;
}
@end

@implementation selectionController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArr = [[NSMutableArray alloc] init];
    NSString * path = [[NSBundle mainBundle] pathForResource:@"musicList" ofType:@"plist"];
    _dataArr = [NSMutableArray arrayWithContentsOfFile:path];
    _myTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    UIView * backView = [[UIView alloc] initWithFrame:_myTableView.frame];
    backView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"king1"]];
    [_myTableView setBackgroundView:backView];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    
    [self.view  addSubview:_myTableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"qqq"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"qqq"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_dataArr objectAtIndex:indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_block) {
        _block([_dataArr objectAtIndex:indexPath.row]);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
