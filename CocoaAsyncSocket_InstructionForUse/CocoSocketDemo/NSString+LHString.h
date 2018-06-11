//
//  NSString+LHString.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/29.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LHString)
+ (NSString *)convertDataToHexStr:(NSData *)data;

//不区分大小写的字符串比较
- (BOOL)isEqualToStringWithoutCase:(NSString *)string;

//不区分大小写是否包含字符串
- (BOOL)containsStringWithoutCase:(NSString *)string;

+ (NSNumber *)numberHexString:(NSString *)aHexString;

//字符串与16进制int比较
- (BOOL)compareWithHexint:(int)hexInt;

+ (NSArray *)snalysisWithResponseTwoString:(NSString *)responseStr;

+ (NSString *)hexStringFromData:(NSData *)data;
+ (NSData *)dataFromHexString:(NSString *)hexString;
@end
