//
//  LHPacketData.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/28.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LHPacketDataType) {
    LHPacketDataTypeText = 1, //文本
    LHPacketDataTypeImage,    //图片
    LHPacketDataTypeHex,      //16进制
    LHPacketDataTypeData,     //data
};
@interface LHPacketData : NSObject
//封包
+ (NSData *)packetDataWithData:(NSData *)command commandType:(LHPacketDataType)packetDataType;
//心跳
+ (NSData *)heartBeatParam;

+ (NSData *)heartBeatParamWithData:(NSData *)data;

+ (NSData *)encodeCommandCode:(int)code;
+ (NSData *)encodeCommandCode:(int)code param0:(int)p0;
+ (NSData *)encodeCommandCode:(int)code param1:(int)p1 param2:(int)p2;
+ (NSData *)encodeCommandCodeAndCommandData:(int)code param1:(int)p1 param2:(int)p2;
+ (NSData *)encodeCommandCode:(int)code param1:(int)p1 param2:(int)p2 param3:(int)p3;
@end
