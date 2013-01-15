//
//  CHViewController.m
//  ColorHarmonization
//
//  Created by Evelyn on 1/14/13.
//  Copyright (c) 2013 Evelyn. All rights reserved.
//


#import "CHViewController.h"
using namespace cv;

@interface CHViewController ()
{
    float _curRed;
    BOOL _increasing;
}
@property (strong, nonatomic) EAGLContext *context;

@end

@implementation CHViewController
@synthesize context = _context;
@synthesize photo;

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

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
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    Mat test =  [self cvMatFromUIImage: self.photo.image];

    cvtColor(test, test, CV_BGR2HSV);
    
    //int hueColor = 180, sCol = 1;
    int hisSize[180] = {0};

    for (int i=0; i < test.rows ; i++)
    {
        for(int j=0; j <  test.cols; j++)
        {
            int hue = test.at<cv::Vec3b>(i,j)[0];
            int sat = test.at<cv::Vec3b>(i,j)[1];
            
            hisSize[hue] += sat;
        }
    }
    
//    int ialpha = 0;
//    int it = [self iType:hisSize alphaAngle:&ialpha];
   
//    int Valpha = 0;
//    int Vt = [self VType:hisSize alphaAngle:&Valpha];
    
//    int Talpha = 0;
//    int Tt = [self TType:hisSize alphaAngle:&Talpha];
    
//    int Xalpha = 0;
//    int Xt = [self XType:hisSize alphaAngle:&Xalpha];
    
//    int Ialpha = 0;
//    int It = [self IType:hisSize alphaAngle:&Ialpha];
    
//    int Yalpha = 0;
//    int Yt = [self YType:hisSize alphaAngle:&Yalpha];
    
    int Lalpha = 0;
    int Lt = [self LType:hisSize alphaAngle:&Lalpha];
    
    NSLog(@"VType: %d , %d" , Lt, Lalpha);
    
    [self LTypeHarm:test alpha:Lalpha];
    
    cvtColor(test, test, CV_HSV2BGR);
    self.photo.image = [self UIImageFromCVMat: test];

}

-(int)iType:(int *)hisSize alphaAngle:(int *)m
{
    int iTAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            if((alpha+9)%180 < hue && hue <=(alpha+94)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+9) + 180)% 180);  
            else if((alpha+94)%180 < hue && hue <=(alpha+179)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+179)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(iTAlpha > sum)
        {
            iTAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }

    return iTAlpha ;
}

-(int)VType:(int *)hisSize alphaAngle:(int *)m
{
    int VTAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+47)%180 < hue && hue <=(alpha+114)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+47) + 180)% 180);
            else if((alpha+114)%180 < hue && hue <=(alpha+179)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+179)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(VTAlpha > sum)
        {
            VTAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return VTAlpha ;
}

-(int)TType:(int *)hisSize alphaAngle:(int *)m
{
    int TTAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+90)%180 < hue && hue <=(alpha+135)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+90) + 180)% 180);
            else if((alpha+135)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(TTAlpha > sum)
        {
            TTAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return TTAlpha ;
}

-(int)IType:(int *)hisSize alphaAngle:(int *)m
{
    int IAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+9)%180 < hue && hue <=(alpha+50)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+9) + 180)% 180);
            else if((alpha+50)%180 < hue && hue <=(alpha+90)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+90)- hue + 180)% 180);
            else if((alpha+99)%180 < hue && hue <=(alpha+140)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+99) + 180)% 180);
            else if((alpha+140)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(IAlpha > sum)
        {
            IAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return IAlpha ;
}

-(int)YType:(int *)hisSize alphaAngle:(int *)m
{
    int YAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+47)%180 < hue && hue <=(alpha+78)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+47) + 180)% 180);
            else if((alpha+78)%180 < hue && hue <=(alpha+109)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+109)- hue + 180)% 180);
            else if((alpha+118)%180 < hue && hue <=(alpha+149)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+118) + 180)% 180);
            else if((alpha+149)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(YAlpha > sum)
        {
            YAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return YAlpha ;
}



-(int)XType:(int *)hisSize alphaAngle:(int *)m
{
    int XAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+47)%180 < hue && hue <=(alpha+69)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+47) + 180)% 180);
            else if((alpha+69)%180 < hue && hue <=(alpha+90)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+90)- hue + 180)% 180);
            else if((alpha+137)%180 < hue && hue <=(alpha+159)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+137) + 180)% 180);
            else if((alpha+159)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(XAlpha > sum)
        {
            XAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return XAlpha ;
}

-(int)LType:(int *)hisSize alphaAngle:(int *)m
{
    int LAlpha = 99999999999999999;
    int sum = 0;
    int tmpAlpha[180]= {0};
    
    for(int alpha = 0; alpha < 180; alpha++)
    {
        for(int hue = 0; hue < 180; hue++)
        {
            
            if((alpha+40)%180 < hue && hue <=(alpha+50)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+40) + 180)% 180);
            else if((alpha+50)%180 < hue && hue <=(alpha+60)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+60)- hue + 180)% 180);
            else if((alpha+69)%180 < hue && hue <=(alpha+124)%180)
                tmpAlpha[hue] = hisSize[hue]*((hue - (alpha+69) + 180)% 180);
            else if((alpha+124)%180 < hue && hue <=(alpha+180)%180)
                tmpAlpha[hue] = hisSize[hue]*(((alpha+180)- hue + 180)% 180);
            sum += tmpAlpha[hue];
        }
        
        if(LAlpha > sum)
        {
            LAlpha = sum;
            *m = alpha;
        }
        sum = 0;
        for(int i = 0; i < 180; i++)
            tmpAlpha[i] = 0;
    }
    
    return LAlpha ;
}


-(void)iTypeHarm:(Mat)image alpha:(int)ialpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((ialpha+4)%180 < hue && hue <=(ialpha+94)%180)
                image.at<cv::Vec3b>(i,j)[0] = (ialpha + 4 + (image.at<cv::Vec3b>(i,j)[0] - (ialpha+4)+180)%180/90*4)%180;
            else if((ialpha+94)%180 < hue && hue <=(ialpha+184)%180)
                image.at<cv::Vec3b>(i,j)[0] = (ialpha + 4 - ((ialpha+184)-image.at<cv::Vec3b>(i,j)[0]+180)%180/90*4+180)%180;
        }
    }

}

-(void)VTypeHarm:(Mat)image alpha:(int)Valpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Valpha+24)%180 < hue && hue <=(Valpha+114)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Valpha + 24 + (image.at<cv::Vec3b>(i,j)[0] - (Valpha+24)+180)%180/90*24)%180;
            else if((Valpha+114)%180 < hue && hue <=(Valpha+204)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Valpha + 24 - ((Valpha+204)-image.at<cv::Vec3b>(i,j)[0]+180)%180/90*24+180)%180;
        }
    }
    
}

-(void)TTypeHarm:(Mat)image alpha:(int)Talpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
                      
            if((Talpha+45)%180 < hue && hue <=(Talpha+135)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Talpha + 45 + (image.at<cv::Vec3b>(i,j)[0] - (Talpha+45)+180)%180/90*90)%180;
            else //if((Talpha+135)%180 < hue && hue <=(Talpha+225)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Talpha + 45 - ((Talpha+225)-image.at<cv::Vec3b>(i,j)[0]+180)%180/90*90+180)%180;
        }
    }
    
}
-(void)XTypeHarm:(Mat)image alpha:(int)Xalpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Xalpha+24)%180 < hue && hue <=(Xalpha+69)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Xalpha + 24 + (image.at<cv::Vec3b>(i,j)[0] - (Xalpha+24)+180)%180/45*24)%180;
            else if((Xalpha+69)%180 < hue && hue <=(Xalpha+114)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Xalpha + 114 - ((Xalpha+114)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*24+180)%180;
            else if((Xalpha+114)%180 < hue && hue <=(Xalpha+159)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Xalpha + 114 + (image.at<cv::Vec3b>(i,j)[0] - (Xalpha+114)+180)%180/45*24)%180;
            else //if((Xalpha+159)%180 < hue && hue <=(Xalpha+204)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Xalpha + 204 - ((Xalpha+204)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*24+180)%180;
        }
    }
    
}


-(void)ITypeHarm:(Mat)image alpha:(int)Ialpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Ialpha+4)%180 < hue && hue <=(Ialpha+50)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Ialpha + 4 + (image.at<cv::Vec3b>(i,j)[0] - (Ialpha+4)+180)%180/45*4)%180;
            else if((Ialpha+50)%180 < hue && hue <=(Ialpha+94)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Ialpha + 94 - ((Ialpha+94)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*4+180)%180;
            else if((Ialpha+94)%180 < hue && hue <=(Ialpha+147)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Ialpha + 94 + (image.at<cv::Vec3b>(i,j)[0] - (Ialpha+94)+180)%180/45*4)%180;
            else //if((Xalpha+140)%180 < hue && hue <=(Xalpha+184)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Ialpha + 184 - ((Ialpha+184)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*4+180)%180;
        }
    }
    
}

-(void)YTypeHarm:(Mat)image alpha:(int)Yalpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Yalpha+24)%180 < hue && hue <=(Yalpha+78)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Yalpha + 24 + (image.at<cv::Vec3b>(i,j)[0] - (Yalpha+24)+180)%180/54*23)%180;
            else if((Yalpha+78)%180 < hue && hue <=(Yalpha+114)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Yalpha + 114 - ((Yalpha+114)-image.at<cv::Vec3b>(i,j)[0]+180)%180/36*5+180)%180;
            else if((Yalpha+114)%180 < hue && hue <=(Yalpha+149)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Yalpha + 114 + (image.at<cv::Vec3b>(i,j)[0] - (Yalpha+114)+180)%180/35*4)%180;
            else //if((Yalpha+149)%180 < hue && hue <=(Yalpha+204)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Yalpha + 204 - ((Yalpha+204)-image.at<cv::Vec3b>(i,j)[0]+180)%180/55*24+180)%180;
        }
    }
    
}

-(void)LTypeHarm:(Mat)image alpha:(int)Lalpha
{
    
    for (int i=0; i < image.rows ; i++)
    {
        for(int j=0; j <  image.cols; j++)
        {
            int hue = image.at<cv::Vec3b>(i,j)[0];
            
            if((Lalpha+20)%180 < hue && hue <=(Lalpha+50)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Lalpha + 20 + (image.at<cv::Vec3b>(i,j)[0] - (Lalpha+20)+180)%180/30*20)%180;
            else if((Lalpha+50)%180 < hue && hue <=(Lalpha+65)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Lalpha + 65 - ((Lalpha+65)-image.at<cv::Vec3b>(i,j)[0]+180)%180/15*5+180)%180;
            else if((Lalpha+65)%180 < hue && hue <=(Lalpha+124)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Lalpha + 65 + (image.at<cv::Vec3b>(i,j)[0] - (Lalpha+65)+180)%180/45*4)%180;
            else //if((Xalpha+140)%180 < hue && hue <=(Xalpha+184)%180)
                image.at<cv::Vec3b>(i,j)[0] = (Lalpha + 200 - ((Lalpha+200)-image.at<cv::Vec3b>(i,j)[0]+180)%180/45*4+180)%180;
        }
    }
    
}


- (void)viewDidUnload
{
    
    [self setPhoto:nil];
    [super viewDidUnload];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
    self.context = nil;
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.paused = !self.paused;
}




@end
