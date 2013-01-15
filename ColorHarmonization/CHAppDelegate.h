//
//  CHAppDelegate.h
//  ColorHarmonization
//
//  Created by Evelyn on 1/14/13.
//  Copyright (c) 2013 Evelyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CHAppDelegate : UIResponder <UIApplicationDelegate>
{
    float _curRed;
    BOOL _increasing;
}

@property (strong, nonatomic) UIWindow *window;

@end
