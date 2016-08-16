//
//  DYJHeartRateDetectionModel.h
//  DYJheartRate
//
//  Created by ShuYu002 on 16/8/16.
//  Copyright © 2016年 study. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HeartRateDetectionModelDelegate

- (void)heartRateStart;
- (void)heartRateUpdate:(int)bpm atTime:(int)seconds;
- (void)heartRateEnd;

- (void)zhuangtai:(BOOL)neirong;
@end

@interface DYJHeartRateDetectionModel : NSObject


@property (nonatomic, weak) id<HeartRateDetectionModelDelegate> delegate;

- (void)startDetection;
- (void)stopDetection;
@end
