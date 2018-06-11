//
//  LHSocketManager.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/21.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GCDAsyncSocket;
/**
 *  连接状态
 */
typedef NS_ENUM(NSInteger, LHSocketConnectState) {
    LHSocketConnectState_NotConnect = 1,  //未连接
    LHSocketConnectState_ConnectSuccess,  //连接成功
    LHSocketConnectState_ConnectFail,     //连接失败
    LHSocketConnectState_Connecting,      //正在连接
    LHSocketConnectState_ReConnecting,    //正在重新连接中
    
};

typedef void(^SocketConnectResponseBlock)(NSError *error, NSDictionary *result);
typedef void(^SocketWithReadDataBlock)(NSData *result);

#define socketManager [LHSocketManager shareSocketManager]

@interface LHSocketManager : NSObject
@property(nonatomic,assign)LHSocketConnectState connectState;
+ (instancetype)shareSocketManager;
+ (void)disConnectSocket;
+ (void)receiveMessage;
+ (void)startHeartTimer;
+ (void)stopHeartTimer;

- (void)connectToHost:(NSString *)host port:(uint16_t)port viaInterface:(NSString *)viaInterface timeout:(NSTimeInterval)timeout;
- (void)responseConnectBlock:(SocketConnectResponseBlock)connectBlock;
- (void)responseReadDataBlock:(SocketWithReadDataBlock)readDataBlock;
- (void)sendCommand:(NSData *)command withTimeout:(NSTimeInterval)timeout tag:(long)tag;

@end
