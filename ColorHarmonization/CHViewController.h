//
//  CHViewController.h
//  ColorHarmonization
//
//  Created by Evelyn on 1/14/13.
//  Copyright (c) 2013 Evelyn. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface CHViewController : GLKViewController

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
- (cv::Mat)cvMatFromUIImage:(UIImage *)image;
-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

@property (strong, nonatomic) IBOutlet UIImageView *photo;



@end
