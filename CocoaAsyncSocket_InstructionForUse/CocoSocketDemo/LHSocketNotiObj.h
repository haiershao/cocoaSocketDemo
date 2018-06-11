//
//  LHSocketNotiObj.h
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/29.
//  Copyright © 2018年 LGQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LHSocketNotiObj : NSObject
@property (nonatomic, strong) NSData *notiData;

@property (nonatomic, strong) NSString *noti_header1;
@property (nonatomic, strong) NSString *noti_header2;

@property (nonatomic, strong) NSString *noti_length;

@property (nonatomic, strong) NSArray  *noti_values;

@property (nonatomic, strong) NSString *noti_check;
@end
