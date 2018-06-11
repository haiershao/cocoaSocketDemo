//
//  NSString+LHString.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/29.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "NSString+LHString.h"

@implementation NSString (LHString)
+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

//不区分大小写的字符串比较
- (BOOL)isEqualToStringWithoutCase:(NSString *)string{
    if (nil == string) return NO;
    return [self compare:string options:NSCaseInsensitiveSearch |NSNumericSearch] == NSOrderedSame;
}

//不区分大小写是否包含字符串
- (BOOL)containsStringWithoutCase:(NSString *)string{
    if (nil == string) return NO;
    return [[self lowercaseString] rangeOfString:[string lowercaseString]].location != NSNotFound;
}

+ (NSNumber *)numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString)
    {
        return nil;
    }
    
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    
    return hexNumber;
    
}

- (BOOL)compareWithHexint:(int)hexInt{
    NSMutableData* dataStr = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= self.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [self substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [dataStr appendBytes:&intValue length:1];
    }
    
    Byte byte[2] = {};
    byte[1] =  (Byte) ((hexInt>>8) & 0xFF);
    byte[0] =  (Byte) (hexInt & 0xFF);
    NSData *dataValue = [NSData dataWithBytes:byte length:sizeof(byte)];
    if ([dataStr isEqualToData:dataValue]) {
        return YES;
    }else{
        return NO;
    }
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

+ (NSString *)hexStringFromData:(NSData *)data {
    NSAssert(data.length > 0, @"data.length <= 0");
    NSMutableString *hexString = [[NSMutableString alloc] init];
    const Byte *bytes = data.bytes;
    for (NSUInteger i=0; i<data.length; i++) {
        Byte value = bytes[i];
        Byte high = (value & 0xf0) >> 4;
        Byte low = value & 0xf;
        [hexString appendFormat:@"%x%x", high, low];
    }//for
    return hexString;
}

+ (NSData *)dataFromHexString:(NSString *)hexString {
    NSAssert((hexString.length > 0) && (hexString.length % 2 == 0), @"hexString.length mod 2 != 0");
    NSMutableData *data = [[NSMutableData alloc] init];
    for (NSUInteger i=0; i<hexString.length; i+=2) {
        NSRange tempRange = NSMakeRange(i, 2);
        NSString *tempStr = [hexString substringWithRange:tempRange];
        NSScanner *scanner = [NSScanner scannerWithString:tempStr];
        unsigned int tempIntValue;
        [scanner scanHexInt:&tempIntValue];
        [data appendBytes:&tempIntValue length:1];
    }
    return data;
}
@end
