//
//  LPXChartView.m
//  HMJK
//
//  Created by hmyd on 16/7/22.
//  Copyright © 2016年 hmyd. All rights reserved.
//

#import "LPXChartView.h"

@interface UUChartLabel : UILabel

@end


@interface LPXChartView ()

@property (strong, nonatomic) NSMutableArray * yLabels;
@property (strong, nonatomic) NSMutableArray * xLabels;
@property (strong, nonatomic) NSMutableArray * pointViews;
@property (strong, nonatomic) CAShapeLayer * yLayer;//坐标轴layer
@property (nonatomic) CGFloat chartSocle;
@end

@implementation LPXChartView

- (instancetype)initWithFrame:(CGRect)rect  style:(LPXChartStyle)style{
    
    self.chartStyle = style;
    return [self initWithFrame:rect];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
    }
    return self;
}
- (void)showInView:(UIView *)view{
    [self setUpChart];
    [view addSubview:self];
}
-(void)setUpChart{
    if (_yCoords)[self setYLabels:_yCoords.mutableCopy];
    if (_xCoords)[self setXLabels:_xCoords.mutableCopy];
    if (self.chartStyle == LPXChartStyleLine) {
        if (_points)[self addPoints];
        if (_groupedPoints) [self addGroupedPoints];
    }else if (self.chartStyle == LPXChartStyleBar){
        if (_points)[self addBars];
    }
}
-(void)addGroupedPoints{
    _pointViews = [NSMutableArray array];
    for (int i = 0 ;i< _groupedPoints.count ;i++) {
        NSArray *group = _groupedPoints[i];
         NSMutableArray *groupViews = [NSMutableArray array];
        for (LPXPoint *point in group) {
            CGFloat center_x  = ((UILabel *)_xLabels[i]).center.x;
            CGFloat center_y = ((UILabel *)_yLabels[0]).center.y + ([_yCoords[0] floatValue]-point.y)*_chartSocle;
            CGPoint center = CGPointMake(center_x, center_y);
            UIView *pv = [self addPoint:center color:point.color];
            if (point.x == 1)[_pointViews addObject:pv];
            [groupViews addObject:pv];
        }
        [self addLineToGroupViews:groupViews];
    }
    [self addFoldLineToPointViews];
}
-(void)addBars{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 0.2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    for (LPXPoint *point in _points) {
        CGFloat center_x  = ((UILabel *)_xLabels[point.x]).center.x;
        CGFloat center_y = ((UILabel *)_yLabels[0]).center.y + ([_yCoords[0] floatValue]-point.y)*_chartSocle;
        CGPoint center = CGPointMake(center_x, center_y);
        CAShapeLayer *_chartLine = [CAShapeLayer layer];
        _chartLine.lineJoin = kCALineJoinBevel;
        _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
        _chartLine.strokeColor = point.color.CGColor;
        _chartLine.lineWidth   = 10.0;
        [self.layer addSublayer:_chartLine];
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        [progressline setLineWidth:2.0];
        [progressline moveToPoint:CGPointMake(center_x, self.frame.size.height-20)];
        [progressline addLineToPoint:center];
        [progressline moveToPoint:center];
        _chartLine.path = progressline.CGPath;
        [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
        _chartLine.strokeEnd = 1.0;
    }
    
}
-(void)addPoints{
    _pointViews = [NSMutableArray array];
    for (LPXPoint *point in _points) {
        CGFloat center_x  = ((UILabel *)_xLabels[point.x]).center.x;
        CGFloat center_y = ((UILabel *)_yLabels[0]).center.y + ([_yCoords[0] floatValue]-point.y)*_chartSocle;
        CGPoint center = CGPointMake(center_x, center_y);
        [_pointViews addObject:[self addPoint:center color:point.color]];
    }
    [self addFoldLineToPointViews];
    
}
-(void)addLineToGroupViews:(NSArray *)views{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = views.count*0.2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    for (int i= 0; i<views.count-1; i++) {
        UIView *pointView = views[i];
        UIView *nextPointView = views[i+1];
        if (i==0) {
            CAShapeLayer *_chartLine = [CAShapeLayer layer];
            _chartLine.lineCap = kCALineCapRound;
            _chartLine.lineJoin = kCALineJoinBevel;
            _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
            _chartLine.strokeColor = BlueColor.CGColor;
            _chartLine.lineWidth   = 1.0;
            [self.layer addSublayer:_chartLine];
            UIBezierPath *progressline = [UIBezierPath bezierPath];
            [progressline setLineWidth:2.0];
            [progressline moveToPoint:pointView.center];
            [progressline addLineToPoint:nextPointView.center];
            [progressline moveToPoint:nextPointView.center];
            _chartLine.path = progressline.CGPath;
            [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            _chartLine.strokeEnd = 1.0;
        }else {
            CAShapeLayer *_chartLine = [CAShapeLayer layer];
            _chartLine.lineCap = kCALineCapRound;
            _chartLine.lineJoin = kCALineJoinBevel;
            _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
            _chartLine.strokeColor = RedColor.CGColor;
            _chartLine.lineWidth   = 1.0;
            [self.layer addSublayer:_chartLine];
            
            UIBezierPath *progressline = [UIBezierPath bezierPath];
            [progressline setLineWidth:2.0];
            [progressline moveToPoint:pointView.center];
            [progressline addLineToPoint:nextPointView.center];
            [progressline moveToPoint:nextPointView.center];
            _chartLine.path = progressline.CGPath;
            [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            _chartLine.strokeEnd = 1.0;
            
        }
    }
    for (UIView *view in views) [self bringSubviewToFront:view];
}
-(void)addFoldLineToPointViews{
    //划线
    CAShapeLayer *_chartLine = [CAShapeLayer layer];
    _chartLine.lineCap = kCALineCapRound;
    _chartLine.lineJoin = kCALineJoinBevel;
    _chartLine.fillColor   = [[UIColor whiteColor] CGColor];
    _chartLine.strokeColor = GreenColor.CGColor;
    _chartLine.lineWidth   = 1.0;//折线宽度
  
    [self.layer addSublayer:_chartLine];
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    [progressline setLineWidth:2.0];
    
    for (int i= 0; i<_pointViews.count; i++) {
        UIView *pointView = _pointViews[i];
        if (i==0) {
            [progressline moveToPoint:pointView.center];
        }else{
            [progressline addLineToPoint:pointView.center];
            [progressline moveToPoint:pointView.center];
        }
    }
    _chartLine.path = progressline.CGPath;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = _pointViews.count*0.4;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    _chartLine.strokeEnd = 1.0;
    for (UIView *view in _pointViews) [self bringSubviewToFront:view];
}
- (UIView *)addPoint:(CGPoint)point color:(UIColor*)color{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,0, 6, 6)];
    view.center = point;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 3;
    view.layer.borderWidth = 2;
    view.layer.borderColor = color.CGColor;
    [self addSubview:view];
    return view;
}
-(void)setXLabels:(NSMutableArray *)xLabels{
    _xLabels = [NSMutableArray array];
    CGFloat num = xLabels.count;
    _xLabelWidth = (self.frame.size.width - 2*UUYLabelwidth)/num;
    
    for (int i=0; i<xLabels.count; i++) {
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake((i+0.5)*_xLabelWidth + UUYLabelwidth, self.frame.size.height - UULabelHeight, _xLabelWidth, UULabelHeight)];
        label.text = xLabels[i];
        [self addSubview:label];
        [_xLabels addObject:label];
    }
    //画竖线
    if (_isDrawV) {
        for (int i=0; i<xLabels.count; i++) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(((UILabel *)_xLabels[i]).center.x,0)];
            [path addLineToPoint:CGPointMake(((UILabel *)_xLabels[i]).center.x,self.frame.size.height-2*UULabelHeight)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineJoin = kCALineJoinRound;
            shapeLayer.lineDashPattern = @[@(1),@(2)];//设置虚线宽2，间隔2
            shapeLayer.lineWidth = 1;
            [self.layer addSublayer:shapeLayer];
        }
    }
    
}
-(void)setYLabels:(NSMutableArray *)yLabels{
    _yLabels = [NSMutableArray array];
    CGFloat chartCavanHeight = self.frame.size.height - 40;
    CGFloat levelHeight = chartCavanHeight / yLabels.count ;
    CGFloat levelOffset = 20 - UULabelHeight/2;
    _chartSocle = levelHeight/([yLabels[0] floatValue]-[yLabels[1] floatValue]);
    for (int i=0; i < yLabels.count; i++) {//添加y轴坐标
        UUChartLabel * label = [[UUChartLabel alloc] initWithFrame:CGRectMake(0.0,levelOffset + i*levelHeight , UUYLabelwidth, UULabelHeight)];
        label.text = yLabels[i];
        [self addSubview:label];
        [_yLabels addObject:label];
    }
    if (_markRange.max != _markRange.min) {//有遮罩
        CGFloat mask_max_y  = ((UILabel *)_yLabels[0]).center.y + ([yLabels[0] floatValue]-_markRange.max)*_chartSocle;
        CGFloat mask_h = (_markRange.max - _markRange.min)*_chartSocle;
        CALayer *rectLayer = [CALayer layer];
        rectLayer.frame = CGRectMake(UUYLabelwidth, mask_max_y, self.frame.size.width-UUYLabelwidth, mask_h);
        rectLayer.backgroundColor = MaskColor.CGColor;
        [self.layer addSublayer:rectLayer];
    }
    //画轴
    self.yLayer = [CAShapeLayer layer];
    //画横线
    for (int i=0; i < yLabels.count; i++) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(UUYLabelwidth,((UILabel *)_yLabels[i]).center.y)];
        [path addLineToPoint:CGPointMake(self.frame.size.width,20 + i*levelHeight)];
        [path closePath];
        shapeLayer.path = path.CGPath;
        shapeLayer.lineJoin = kCALineJoinRound;
        shapeLayer.lineDashPattern = @[@(1),@(2)];//设置虚线宽2，间隔2
        shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor];
        shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
        shapeLayer.lineWidth = 1;
        [self.layer addSublayer:shapeLayer];
    }
   
}
-(void)setYLayer:(CAShapeLayer *)yLayer{
    _yLayer = yLayer;
    if (_Y_Colors) {
        CGFloat chartCavanHeight = self.frame.size.height - 40;
        CGFloat levelHeight = chartCavanHeight / _Y_Colors.count ;
        CGFloat levelOffset = 20;
        for (int i=0; i < _Y_Colors.count; i++) {//添加y轴颜色
            CAShapeLayer *layer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(UUYLabelwidth, levelOffset+(i?0:-levelOffset) +i*levelHeight)];
            [path addLineToPoint:CGPointMake(UUYLabelwidth,levelOffset +(i+1)*levelHeight)];
            [path closePath];
            layer.path = path.CGPath;
            layer.strokeColor = [[_Y_Colors[i] colorWithAlphaComponent:1] CGColor];
            layer.fillColor = [[UIColor whiteColor] CGColor];
            layer.lineWidth = 4;
            [_yLayer addSublayer:layer];
        }
    }else{
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(UUYLabelwidth,0)];
        [path addLineToPoint:CGPointMake(UUYLabelwidth,self.frame.size.height-20)];
        [path closePath];
        _yLayer.path = path.CGPath;
        _yLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.4] CGColor];
        _yLayer.fillColor = [[UIColor whiteColor] CGColor];
        _yLayer.lineWidth = 1;
    }
    CAShapeLayer *xlayer = [CAShapeLayer layer];//x轴
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, self.frame.size.height-20)];
    [path addLineToPoint:CGPointMake(self.frame.size.width,self.frame.size.height-20)];
    [path closePath];
    xlayer.path = path.CGPath;
    xlayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:0.2] CGColor];
    xlayer.fillColor = [[UIColor whiteColor] CGColor];
    xlayer.lineWidth = 1;
    [_yLayer addSublayer:xlayer];
    [self.layer addSublayer:_yLayer];
}
@end


@implementation UUChartLabel
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:1];
        [self setFont:[UIFont boldSystemFontOfSize:9.0f]];
        [self setTextColor: [UIColor darkGrayColor]];
        [self setTextAlignment:NSTextAlignmentCenter];
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}
@end


@implementation LPXPoint
+(instancetype)makeLPXPointX:(int)x Y:(float)y Color:(UIColor *)color{
    LPXPoint *p = [[LPXPoint alloc]init];
    p.x = x;
    p.y = y;
    p.color = color;
    return p;
}
@end



























