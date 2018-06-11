//
//  LHSocketSender.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/22.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LHPacketData.h"
#import "LHSocketManager.h"
@interface LHSocketSender : NSObject
+ (void)sendData:(NSData *)data commandType:(LHPacketDataType)type withTimeout:(NSTimeInterval)timeout tag:(long)tag;
+ (void)sendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
@end
