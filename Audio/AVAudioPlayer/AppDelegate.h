//
//  AppDelegate.h
//  AVAudioPlayer
//
//  Created by Mac on 15-8-10.
//  Copyright (c) 2015年 wqf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)CLLocationManager *locationManager;
@end
