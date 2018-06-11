//
//  LHSocketNotiObj.m
//  CocoSocketDemo
//
//  Created by 海二少 on 2018/5/29.
//  Copyright © 2018年 LGQ. All rights reserved.
//

/*
 00000044 32000000 02000200 00000a0a 0100a904 cf314361 6e6f6e20 496e632e 0043616e 6f6e2044 69676974 616c2043 616d6572 61000c00 00000300 01200000 0a0a0000
 */

#import "LHSocketNotiObj.h"
#import "NSString+LHString.h"
#import "LHSocketDecodeTool.h"
@implementation LHSocketNotiObj
- (void)setNotiData:(NSData *)notiData
{
    _notiData = notiData;
    
    //解析data
    NSString *dataString = [NSString convertDataToHexStr:notiData];
    NSArray *noti_array = [LHSocketDecodeTool snalysisWithResponseString:dataString];
//    if (4 <= noti_array.count) {
        self.noti_header1 = noti_array[0];
        self.noti_header2 = noti_array[1];
        self.noti_length  = noti_array[2];
        self.noti_check   = [noti_array lastObject];
        self.noti_values  = [noti_array subarrayWithRange:NSMakeRange(0, noti_array.count)];
//    }
}


@end
