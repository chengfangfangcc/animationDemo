//
//  ViewController.m
//  animationDemo
//
//  Created by powerful on 2018/11/21.
//  Copyright © 2018年 powerful. All rights reserved.
//

#import "ViewController.h"

#define kRadianToDegrees(x) (M_PI * (x) / 180.0)

@interface ViewController ()

@property (strong, nonatomic) UILabel *animationLab;

@property (strong, nonatomic) UIImageView *firstCircle;
@property (strong, nonatomic) CAShapeLayer *firstCircleShapeLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //animation
    [self animationLabelView];
    
    //UIBezierPath
    [self dongHua];
    
    [self createLayer];
    
    [self createGradientLayer];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - UIBezierPath
//圆形循环
- (void)dongHua {
    //路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(60 / 2.f, 60 / 2.f)
                                                        radius:60 / 2.f
                                                    startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    //CAShapeLayer
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.frame = CGRectMake(100, 100, 60, 60);
    shapelayer.path = path.CGPath;
    shapelayer.lineWidth = 4.0f;
    shapelayer.lineCap = kCALineCapSquare;  //边缘线类型
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    shapelayer.strokeColor = [UIColor orangeColor].CGColor;
    shapelayer.strokeStart = 0.0f;
    shapelayer.strokeEnd = 0.1f;
    [self.view.layer addSublayer:shapelayer];
    //动画
    CABasicAnimation *basicAnmation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    basicAnmation.duration = 2.0;
    basicAnmation.repeatCount = HUGE_VAL;  //重复次数，为HUGE_VAL表示无数次
    basicAnmation.fromValue = [NSNumber numberWithInt:0.0f];
    basicAnmation.toValue = [NSNumber numberWithInt:1.0f];
    basicAnmation.removedOnCompletion = NO;
    basicAnmation.fillMode = kCAFillModeForwards;
    [shapelayer addAnimation:basicAnmation forKey:nil];
}


/*
 CAAnimation是所有动画类的父类，但是它不能直接使用，应该使用它的子类。
 能用的动画类只有4个子类：CABasicAnimation、CAKeyframeAnimation、CATransition、CAAnimationGroup
 */
- (void)animationLabelView {
    _animationLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 60, 30)];
    _animationLab.textAlignment = NSTextAlignmentCenter;
    _animationLab.text = @"动画";
    _animationLab.backgroundColor = [UIColor orangeColor];
    _animationLab.textColor = [UIColor whiteColor];
    [self.view addSubview:_animationLab];
    
    //闪烁动画
    //    [_animationLab.layer addAnimation:[self opacityForever_Animation:0.5f] forKey:nil];
    
    //纵向横向移动
    //    [_animationLab.layer addAnimation:[self movex:1.0f x:[NSNumber numberWithFloat:200.0f]] forKey:nil];
    
    //缩放
    //    [_animationLab.layer addAnimation:[self scale:[NSNumber numberWithFloat:1.0f] orgin:[NSNumber numberWithFloat:0.3f] durTimes:0.5f Rep:MAXFLOAT] forKey:nil];
    
    //组合
    //    NSArray *animationArray = [NSArray arrayWithObjects:[self opacityForever_Animation:0.5f],[self movex:1.0f x:[NSNumber numberWithFloat:200.0f]],[self scale:[NSNumber numberWithFloat:1.0f] orgin:[NSNumber numberWithFloat:0.3f] durTimes:0.5f Rep:MAXFLOAT], nil];
    //    [_animationLab.layer addAnimation:[self groupAnimation:animationArray durTimes:1.0f Rep:MAXFLOAT] forKey:nil];
    
    
    //路径
    //    CGMutablePathRef pathRef = CGPathCreateMutable();
    //    CGPathMoveToPoint(pathRef, nil, 30, 77);  //
    //    CGPathAddCurveToPoint(pathRef, nil, 50, 50, 60, 200, 200, 200);
    //    [_animationLab.layer addAnimation:[self keyframeAnimation:pathRef durTimes:1.0f Rep:MAXFLOAT] forKey:nil];
    
    
    //旋转
        [_animationLab.layer addAnimation:[self rotation:2 degree:kRadianToDegrees(180) direction:1] forKey:nil];
    
    
    
    //绕y旋转
    //    [_animationLab.layer addAnimation:[self rotationFromYWithDur:1.0f] forKey:nil];
//        [_animationLab.layer addAnimation:[self rotationFromYWithDur:1.0f] forKey:@"rotationAnimation"];
    
    //绕x旋转
//        [_animationLab.layer addAnimation:[self rotationFromXWithDur:1.0f] forKey:nil];
}

#pragma mark - 永久闪烁的动画
- (CABasicAnimation *)opacityForever_Animation:(float)time {
    //透明度
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"]; //必须是opacity(不透明度)
    
    baseAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    baseAnimation.toValue = [NSNumber numberWithFloat:0.0f];  //透明度
    baseAnimation.fillMode = kCAFillModeForwards;  //fillMode的作用就是决定当前对象过了非active时间段的行为. 比如动画开始之前,动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
    /*
     kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
     kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
     kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
     kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
     */
    baseAnimation.autoreverses = YES;   //动画结束时是否进行逆反
    baseAnimation.duration = time;
    baseAnimation.repeatCount = MAXFLOAT;
    baseAnimation.removedOnCompletion = NO;    //YES就是动画完成后自动变回原样，动画完成后是否移除动画，.默认为YES.此属性为YES时, fillMode不可用
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];  //没有的话，是均匀的动画   timingFunction速度控制函数
    
    
    
    //缩放
    //    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];  //transform.scale（变换 缩放）
    //    baseAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    //    baseAnimation.toValue = [NSNumber numberWithFloat:0.0f];  //缩放值
    //    baseAnimation.autoreverses = YES;     //动画结束时是否执行逆动画
    //    baseAnimation.duration = time;
    //    baseAnimation.repeatCount = MAXFLOAT;    //是否动画永远持续
    
    return baseAnimation;
}

#pragma mark - 纵向、横向移动
- (CABasicAnimation *)movex:(float)time x:(NSNumber *)x {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"]; //.y的话，就会向下移
    baseAnimation.toValue = x;
    baseAnimation.duration = time;
    baseAnimation.repeatCount = MAXFLOAT;
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.removedOnCompletion = NO;  //为YES，就会又回到原位置，动画完成后是否移除动画，.默认为YES.此属性为YES时, fillMode不可用
    
    return baseAnimation;
}

#pragma mark - 缩放
-(CABasicAnimation *)scale:(NSNumber *)Multiple orgin:(NSNumber *)orginMultiple durTimes:(float)time Rep:(float)repertTimes {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    baseAnimation.fromValue = Multiple;
    baseAnimation.toValue = orginMultiple;
    baseAnimation.duration = time;   //不设置，会有个默认的缩放时间
    baseAnimation.repeatCount = repertTimes;
    baseAnimation.autoreverses = YES;
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.removedOnCompletion = NO;
    
    return baseAnimation;
}

#pragma mark - 组合动画
-(CAAnimationGroup *)groupAnimation:(NSArray *)animationArray durTimes:(float)time Rep:(float)repeatTimes {
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = animationArray;
    animationGroup.duration = time;
    animationGroup.repeatCount = repeatTimes;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    return animationGroup;
}

#pragma mark - 路径动画
-(CAKeyframeAnimation *)keyframeAnimation:(CGMutablePathRef)path durTimes:(float)time Rep:(float)repeatTimes {
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = path;
    keyFrameAnimation.duration = time;
    keyFrameAnimation.repeatCount = repeatTimes;
    keyFrameAnimation.autoreverses = YES;
    keyFrameAnimation.removedOnCompletion = NO;
    keyFrameAnimation.fillMode = kCAFillModeForwards;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];  //没有设置，就是匀速
    
    return keyFrameAnimation;
}

#pragma mark - 旋转
-(CABasicAnimation *)rotation:(float)dur degree:(float)degree direction:(int)direction {
    CATransform3D transform3D = CATransform3DMakeRotation(degree, 0, 0, direction);
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    baseAnimation.toValue = [NSValue valueWithCATransform3D:transform3D];
    baseAnimation.duration = dur;
    baseAnimation.repeatCount = HUGE_VAL;
    baseAnimation.autoreverses = NO;   //动画结束时是否进行逆动画
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.cumulative = NO;  //指定动画是否为累加效果,默认为NO
    //    baseAnimation.delegate = self;
    
    return baseAnimation;
}

//沿y旋转
- (CABasicAnimation *)rotationFromYWithDur:(float)duration {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    baseAnimation.duration = duration;
    baseAnimation.repeatCount = HUGE_VALF;  //重复不停
    baseAnimation.fromValue = [NSNumber numberWithFloat:0];
    baseAnimation.toValue = [NSNumber numberWithFloat:M_PI]; //结束时的角度
    baseAnimation.autoreverses = NO;
    //动画终了后不返回初始状态
    baseAnimation.removedOnCompletion = NO;
    baseAnimation.fillMode = kCAFillModeForwards;
    
    return baseAnimation;
    
}
//沿x旋转
- (CABasicAnimation *)rotationFromXWithDur:(float)duration {
    CABasicAnimation *baseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    baseAnimation.duration = duration;
    baseAnimation.repeatCount = HUGE_VALF;  //重复不停
    baseAnimation.fromValue = [NSNumber numberWithFloat:0];
    baseAnimation.toValue = [NSNumber numberWithFloat:M_PI]; //结束时的角度
    baseAnimation.autoreverses = NO;
    //动画终了后不返回初始状态
    baseAnimation.removedOnCompletion = NO;
    baseAnimation.fillMode = kCAFillModeForwards;
    return baseAnimation;
    
}



#pragma mark - CALayer
- (void)createLayer {
    //mask是CALayer的属性，mask也是图层。CALayer的mask的应用：创建一个图层或者一个视图，设置图层或者一个视图的mask，mask图层的布局是相对原图层的，最后显示的是重叠部分的形状和原图层的颜色。如果没有重叠部分就什么也不显示
    CALayer *aLayer = [CALayer layer];
    aLayer.frame = CGRectMake(10, 150, 40, 40);
    aLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:aLayer];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 30, 40)];//相对aLayer的frame,因为mask在aLayer上。不要直接设置mask图层的frame
//    shapeLayer.path = path.CGPath;  //可以设置路径，也可以设置frame,但都要相对原图层布局
    shapeLayer.frame = CGRectMake(0, 0, 20, 30);
    shapeLayer.backgroundColor = [UIColor blackColor].CGColor;
    aLayer.mask = shapeLayer;
    
    
    /*创建蓝色矩形图层，再创建小一点的红色圆形，将红色圆形作为蓝色矩形的mask,最后显示的是重叠部分的形状和原图层的颜色。如果没有重叠部分就什么也不显示 */
    //创建一个蓝色的Layer
    CALayer *foregroundLayer        = [CALayer layer];
    foregroundLayer.bounds          = CGRectMake(0, 0, 100, 100);
    foregroundLayer.backgroundColor = [UIColor blueColor].CGColor;
    //创建一个路径
    UIBezierPath *apath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];//相对aLayer的frame,因为mask在aLayer上。
    //创建maskLayer
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = apath.CGPath;  //路径
    maskLayer.fillColor = [UIColor redColor].CGColor;  //填充路径颜色
    maskLayer.fillRule = kCAFillRuleEvenOdd;
//    maskLayer.frame = CGRectMake(0, 0, 100, 100);
//    maskLayer.backgroundColor = [UIColor redColor].CGColor;
    //设置位置
    foregroundLayer.position = self.view.center;
    //设置mask
    foregroundLayer.mask = maskLayer;
    [self.view.layer addSublayer:foregroundLayer];
    
}

#pragma mark - CAGradientLayer
- (void)createGradientLayer {
    /*
     CAGradientLayer是CALayer的一个特殊子类，用于生成颜色渐变的图层，使用较为方便，下面介绍下它的相关属性：
     colors 渐变的颜色
     locations 渐变颜色的分割点
     startPoint&endPoint 颜色渐变的方向，范围在(0,0)与(1.0,1.0)之间，如(0,0)(1.0,0)代表水平方向渐变,(0,0)(0,1.0)代表竖直方向渐变
     */
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(10, 200, 60, 20);
    gradientLayer.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor orangeColor].CGColor, (id)[UIColor purpleColor].CGColor];
    gradientLayer.locations = @[@0.2,@0.6,@1];
    [self.view.layer addSublayer:gradientLayer];
    
    
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(20, 230, 60, 20);
    gradientLayer1.colors = @[(id)[UIColor redColor].CGColor, (id)[UIColor orangeColor].CGColor, (id)[UIColor purpleColor].CGColor];
    gradientLayer1.locations = @[@0.2,@0.6,@1];
    gradientLayer1.startPoint = CGPointMake(0, 0);
    gradientLayer1.endPoint = CGPointMake(1, 0);
    [self.view.layer addSublayer:gradientLayer1];
}


@end

