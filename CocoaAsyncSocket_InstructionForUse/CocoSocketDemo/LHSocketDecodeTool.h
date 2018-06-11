//
//  LHSocketDecodeTool.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/29.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHSocketDecodeTool : NSObject
+ (NSArray *)snalysisWithResponseString:(NSString *)responseStr;
+ (NSArray *)snalysisWithResponseTwoString:(NSString *)responseStr;
@end
