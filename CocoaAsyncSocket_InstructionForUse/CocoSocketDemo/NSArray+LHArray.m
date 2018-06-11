//
//  NSArray+LHArray.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/6/7.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "NSArray+LHArray.h"
#import "NSString+LHString.h"
@implementation NSArray (LHArray)
+ (int)arrayConverIntWithArray:(NSArray *)array{
    NSString *appendStr = @"";
    for (NSString *tempStr in array) {
        appendStr = [appendStr stringByAppendingString:tempStr];
    }
    NSArray *tempArr = [NSString snalysisWithResponseTwoString:appendStr];
    tempArr = [[tempArr reverseObjectEnumerator] allObjects];
    NSString *text = [tempArr componentsJoinedByString:@""];
    NSNumber *tempResult = [NSString numberHexString:text];
    //    NSString *text = @"0x0373db";
    int result = [tempResult intValue];
    return result;
}
@end
