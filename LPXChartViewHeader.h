//
//  Header.h
//  HMJK
//
//  Created by hmyd on 16/7/22.
//  Copyright © 2016年 hmyd. All rights reserved.
//

#ifndef Header_h
#define Header_h


#define chartMargin         10
#define xLabelMargin        15
#define yLabelMargin        15
#define UULabelHeight       10
#define UUYLabelwidth       30
#define UUTagLabelwidth     80

#define RGBA(r,g,b,a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define GreyColor           RGBA(215,215,215,1)
#define RedColor            RGBA(252,148,148,1)
#define YellorColor         RGBA(253,232,6,1)
#define GreenColor          RGBA(152,220,96,1)
#define OrgColor            RGBA(255,175,0,1)
#define BlueColor           RGBA(130,150,230,1)
#define CanyColor           RGBA(100,200,220,1)
#define MaskColor           RGBA(217,240,194,1)

//范围
struct Range {
    CGFloat max;
    CGFloat min;
};
typedef struct Range CGRange;
CG_INLINE CGRange CGRangeMake(CGFloat max, CGFloat min);

CG_INLINE CGRange
CGRangeMake(CGFloat max, CGFloat min){
    CGRange p;
    p.max = max;
    p.min = min;
    return p;
}
typedef NS_ENUM(NSInteger, LPXChartStyle){
    LPXChartStyleLine = 0,
    LPXChartStyleBar
};

#endif /* Header_h */
