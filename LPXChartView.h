//
//  LPXChartView.h
//  HMJK
//
//  Created by hmyd on 16/7/22.
//  Copyright © 2016年 hmyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPXChartViewHeader.h"

#define LPXPointMake(x,y,c)  [LPXPoint makeLPXPointX:x Y:y Color:c]

@interface LPXPoint : NSObject
@property (nonatomic) int x;
@property (nonatomic) CGFloat y;
@property (nonatomic, strong) UIColor *color;
+(instancetype)makeLPXPointX:(int)x Y:(float)y Color:(UIColor *)color;
@end



@interface LPXChartView : UIView

@property (nonatomic) LPXChartStyle chartStyle;
@property (nonatomic, strong) NSArray *Y_Colors;//Y轴颜色数组，
@property (strong, nonatomic) NSArray *yCoords;//Y轴坐标数组，
@property (strong, nonatomic) NSArray *xCoords;//X轴坐标数组，
@property (strong, nonatomic) NSArray *colors;
@property (strong, nonatomic) NSArray *points;
@property (strong, nonatomic) NSArray *groupedPoints;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) BOOL isDrawV;//是否划竖线

@property (nonatomic, assign) CGRange markRange;

- (id)initWithFrame:(CGRect)rect style:(LPXChartStyle)style;
- (void)showInView:(UIView *)view;
@end
