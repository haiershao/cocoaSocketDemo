//
//  LHUnpackingData.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/28.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LHUnpackingDataType) {
    LHUnpackingDataTypeText = 1, //文本
    LHUnpackingDataTypeImage,    //图片
};

#define unpackingData [LHUnpackingData shareUnpackingData]
typedef void(^LHUnpackingDataBlock)(NSUInteger packetLength, NSString *packetType, NSString *error);
@interface LHUnpackingData : NSObject
+ (instancetype)shareUnpackingData;
//拆包
- (void)unpackingDataWithData:(NSData *)readData unpackingDataBlock:(LHUnpackingDataBlock)unpackingDataBlock;
@end
