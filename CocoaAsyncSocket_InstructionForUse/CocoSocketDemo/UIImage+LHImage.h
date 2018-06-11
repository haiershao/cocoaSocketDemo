//
//  UIImage+LHImage.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/6/5.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LHImage)
+ (UIImage *)imageFromBRGABytes:(unsigned char *)imageBytes imageSize:(CGSize)imageSize;
@end
