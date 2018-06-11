//
//  LHSocketSender.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/22.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import "LHSocketSender.h"

@implementation LHSocketSender
#pragma mark - 通用
+ (void)sendData:(NSData *)data commandType:(LHPacketDataType)type withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    if ([LHSocketManager shareSocketManager].connectState != LHSocketConnectState_ConnectSuccess) {
        return;
    }
    NSData *command = [LHPacketData packetDataWithData:data commandType:type];
    [[LHSocketManager shareSocketManager] sendCommand:command withTimeout:timeout tag:tag];
}

+ (void)sendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag{
    if ([LHSocketManager shareSocketManager].connectState != LHSocketConnectState_ConnectSuccess) {
        return;
    }
    [[LHSocketManager shareSocketManager] sendCommand:data withTimeout:timeout tag:tag];
}
@end
