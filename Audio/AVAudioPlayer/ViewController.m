//
//  ViewController.m
//  AVAudioPlayer
//
//  Created by Mac on 15-8-10.
//  Copyright (c) 2015年 wqf. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "selectionController.h"
@interface ViewController ()<AVAudioPlayerDelegate>
{
    AVAudioPlayer * _player;
    NSMutableArray *_dataArr;
    NSInteger _index;
    int i;
}
@property(nonatomic, copy)NSString *musicName;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISlider *processSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumSlider;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _dataArr = [[NSMutableArray alloc] init];
    
    NSString * pathStr = [[NSBundle mainBundle] pathForResource:@"musicList" ofType:@"plist"];
    //将plist里的数据全部放到数组中
    NSArray * tmpArr = [NSArray arrayWithContentsOfFile:pathStr];
    
    
    _dataArr.array = tmpArr;
    if (_musicName.length == 0) {
        _musicName = @"蓝莲花";
       
    }
    _nameLabel.text = _musicName;
    _index = [_dataArr indexOfObject:_musicName];
    NSString * path = [[NSBundle mainBundle] pathForResource:_musicName ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
   // _player.delegate = self;
    _player.volume = 1.0;
   // _player.numberOfLoops = -1;
    [_player prepareToPlay];
    [self updata];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
}
-(void)startTimer
{
    i++;
//    if (_player.isPlaying == NO) {
//        [_player play];
//    }
    NSLog(@"%d",i);
}
-(void)updata
{
    
    NSTimeInterval allTime = _player.duration;
    NSTimeInterval currentTime = _player.currentTime;
    int mm = (int)currentTime/60;
    int ss = (int)currentTime%60;
    NSString * currentStr = [NSString stringWithFormat:@"%.2d:%.2d",mm,ss];
    int MM = (int)allTime/60;
    int SS = (int)allTime%60;
    NSString * allStr = [NSString stringWithFormat:@"%.2d:%.2d",MM,SS];
    
    NSString * time = [currentStr stringByAppendingPathComponent:allStr];
    
    _timeLabel.text = time;
    _processSlider.value = currentTime/allTime;
}
#pragma mark 设置后台播放音乐
+(void)initialize{
    //后台播放，设置会话类型。
    AVAudioSession *session = [AVAudioSession sharedInstance];
    //类型是:播放和录音。
    //[session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //而且要激活，音频会话。
    [session setActive:YES error:nil];
    //后台播放音频设置
     //AVAudioSession *session = [AVAudioSession sharedInstance];
     [session setActive:YES error:nil];
     [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}
- (IBAction)playBtn:(UIButton *)sender
{
    [_player setVolume:_volumSlider.value];
    [_player play];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updata) userInfo:nil repeats:YES];
}
- (IBAction)stopBtn:(UIButton *)sender
{
    if ([_player isPlaying]) {
        [_player pause];
    }
}
- (IBAction)processChange:(UISlider *)sender
{
    [self stopBtn:nil];
    _player.currentTime = sender.value*_player.duration;
    
    [_player prepareToPlay];
}
- (IBAction)processDidChange:(UISlider *)sender
{
    [self playBtn:nil];
}
- (IBAction)volumChange:(UISlider *)sender
{
    [_player setVolume:sender.value];
}
- (IBAction)selectMusic:(UIButton *)sender
{
    selectionController * sc = [[selectionController alloc] init];
    [sc setBlock:^(NSString * nameStr) {
        _musicName = nameStr;
        [self stopBtn:nil];
        _nameLabel.text = _musicName;
        NSString * path = [[NSBundle mainBundle] pathForResource:_musicName ofType:@"mp3"];
        NSURL * url = [NSURL fileURLWithPath:path];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _player.delegate = self;
        [_player prepareToPlay];
        [_player setVolume:_volumSlider.value];
        [_player play];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updata) userInfo:nil repeats:YES];
        
    }];
    [self presentViewController:sc animated:YES completion:nil];
}
- (IBAction)backClick:(UIButton *)sender
{
    _index--;
    if (_index == -1) {
        _index = _dataArr.count - 1;
    }
    _musicName = [_dataArr objectAtIndex:_index];
    _nameLabel.text = _musicName;
    NSString * path = [[NSBundle mainBundle] pathForResource:_musicName ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    [_player prepareToPlay];
    [_player setVolume:_volumSlider.value];
    [_player play];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updata) userInfo:nil repeats:YES];
    
}
- (IBAction)nextClick:(UIButton *)sender
{
    _index++;
    if (_index == _dataArr.count) {
        _index = 0;
    }
    _musicName = [_dataArr objectAtIndex:_index];
    _nameLabel.text = _musicName;
    NSString * path = [[NSBundle mainBundle] pathForResource:_musicName ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    [_player prepareToPlay];
    [_player setVolume:_volumSlider.value];
    [_player play];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updata) userInfo:nil repeats:YES];
    
}
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _index++;
    if (_index == _dataArr.count) {
        _index = 0;
    }
    _musicName = [_dataArr objectAtIndex:_index];
    _nameLabel.text = _musicName;
    NSString * path = [[NSBundle mainBundle] pathForResource:_musicName ofType:@"mp3"];
    NSURL * url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    [_player prepareToPlay];
    [_player setVolume:_volumSlider.value];
    [_player play];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updata) userInfo:nil repeats:YES];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
