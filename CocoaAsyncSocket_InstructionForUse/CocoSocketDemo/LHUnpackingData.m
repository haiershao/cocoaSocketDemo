//
//  LHUnpackingData.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/28.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "LHUnpackingData.h"
@interface LHUnpackingData ()
@property (nonatomic, strong) NSDictionary *currentPacketHead;
@property (nonatomic, copy) LHUnpackingDataBlock unpackingDataBlock;
@end
@implementation LHUnpackingData
+ (instancetype)shareUnpackingData{
    static dispatch_once_t onceTocken;
    static LHUnpackingData *_unpackingData = nil;
    dispatch_once(&onceTocken, ^{
        _unpackingData = [[super allocWithZone:NULL] init];
    });
    return _unpackingData;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [LHUnpackingData shareUnpackingData];
}

//拆包
- (void)unpackingDataWithData:(NSData *)readData unpackingDataBlock:(LHUnpackingDataBlock)unpackingDataBlock {
    //先读取到当前数据包头部信息
    if (!unpackingData.currentPacketHead) {
        unpackingData.currentPacketHead = [NSJSONSerialization JSONObjectWithData:readData options:NSJSONReadingMutableContainers error:nil];
        if (!unpackingData.currentPacketHead) {
            NSLog(@"sever error：当前数据包的头为空");
            unpackingDataBlock(0, nil,@"当前数据包的头为空");
            return;
        }
        NSUInteger packetLength = [unpackingData.currentPacketHead[@"size"] integerValue];
        unpackingDataBlock(packetLength, nil,nil);
        return;
    }
    //正式的包处理
    NSUInteger packetLength = [unpackingData.currentPacketHead[@"size"] integerValue];
    //说明数据有问题
    if (packetLength <= 0 || readData.length != packetLength) {
        NSLog(@"sever error：当前数据包数据大小不正确");
        unpackingDataBlock(0, nil,@"当前数据包数据大小不正确");
        return;
    }
    NSString *type = unpackingData.currentPacketHead[@"type"];
    unpackingDataBlock(0, type,nil);
    unpackingData.currentPacketHead = nil;
}
@end
