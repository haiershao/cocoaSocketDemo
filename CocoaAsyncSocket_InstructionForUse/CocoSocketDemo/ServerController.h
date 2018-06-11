//
//  ServerController.h
//  CocoSocketDemo
//
//  Created by lanouhn on 16/3/16.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LHSeverSendDataType) {
    LHSeverSendDataTypeText = 1, //文本
    LHSeverSendDataTypeImage,    //图片
};

typedef void(^LHUnpackingDataBlock)(NSUInteger packetLength, NSString *packetType, NSString *error);
@interface ServerController : UIViewController

@end
