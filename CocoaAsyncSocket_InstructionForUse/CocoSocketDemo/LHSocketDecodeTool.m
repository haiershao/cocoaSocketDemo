//
//  LHSocketDecodeTool.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/29.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "LHSocketDecodeTool.h"

@implementation LHSocketDecodeTool
+ (NSArray *)snalysisWithResponseString:(NSString *)responseStr {
    //去掉字符串的空格和回车
    NSString *temp = [responseStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSInteger length = temp.length;
    NSMutableArray *arr = [NSMutableArray array];
    
    //把字符串截取成两位
    for (int i = 0; i < length/4; i++) {
        NSRange range = NSMakeRange(i*4, 4);
        NSString *tempSub = [temp substringWithRange:range];
        [arr addObject:tempSub];
    }
    
    return [arr copy];
}

+ (NSArray *)snalysisWithResponseTwoString:(NSString *)responseStr {
    //去掉字符串的空格和回车
    NSString *temp = [responseStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    NSInteger length = temp.length;
    NSMutableArray *arr = [NSMutableArray array];
    
    //把字符串截取成两位
    for (int i = 0; i < length/2; i++) {
        NSRange range = NSMakeRange(i*2, 2);
        NSString *tempSub = [temp substringWithRange:range];
        [arr addObject:tempSub];
    }
    
    return [arr copy];
}
@end
