//
//  ViewController.m
//  DYJheartRate
//
//  Created by ShuYu002 on 16/8/16.
//  Copyright © 2016年 study. All rights reserved.
//

#import "ViewController.h"
#import "LDProgressView.h"
#import "DYJHeartRateDetectionModel.h"

#define  HEIGHT [UIScreen mainScreen].bounds.size.height
#define  WIDTH [UIScreen mainScreen].bounds.size.width


#define kUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<HeartRateDetectionModelDelegate>
{
    int i;
    int j;
    UIButton * start;
    UILabel * heartRate ;
    UILabel * lab;
    UILabel * bpm;
    UIImageView * imagevie;
    UILabel *prompt;
    int number;
    BOOL biaoshi;
}

@property (nonatomic,strong) DYJHeartRateDetectionModel *heartRateDetectionModel;

@property (nonatomic, strong) NSMutableArray *progressViews;
@property (nonatomic,strong) NSTimer * timer;
@property (nonatomic,strong) LDProgressView * progressView ;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeGradually];
    [self createUI];
    
}
//设置页面渐变色

- (void)changeGradually
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [UIScreen mainScreen].bounds
    ;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)kUIColorFromRGB(0xfb055b).CGColor,
                       (id)kUIColorFromRGB(0xff768b).CGColor,nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
}

- (void)createUI
{
    number = 0;
    UIImage *image = [UIImage imageNamed:@"xinlvbeijing"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    UILabel * l4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH/2, 40)];
    l4.textAlignment = NSTextAlignmentCenter;
    l4.text = @"录入心率";
    l4.font = [UIFont boldSystemFontOfSize:16];
    l4.textColor = [UIColor whiteColor];
    self.navigationItem.titleView =l4;
    
    
    
    prompt  = [[UILabel alloc]initWithFrame:CGRectMake(0,200*HEIGHT/667 ,WIDTH,50*HEIGHT/667)];
    prompt.text = @"请您把手指紧贴摄像头测量";
    prompt.hidden = YES;
    prompt.textColor = [UIColor whiteColor];
    prompt.font = [UIFont systemFontOfSize:20*HEIGHT/667];
    prompt.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:prompt];
    
    
    imagevie = [[UIImageView alloc]initWithFrame:CGRectMake((375/2- 14)*WIDTH/375, 100*HEIGHT/667, 28*WIDTH/375, 28*WIDTH/375)];
    imagevie.image = [UIImage imageNamed:@"xinlv-_03"];
    [self.view addSubview:imagevie];
    
    heartRate = [[UILabel alloc]initWithFrame:CGRectMake(0, 140*HEIGHT/667,WIDTH , 80*HEIGHT/667)];
    heartRate.text = @"0";
    heartRate.textAlignment = NSTextAlignmentCenter;
    heartRate.textColor = [UIColor whiteColor];
    heartRate.font = [UIFont systemFontOfSize:100*HEIGHT/667];
    [self.view addSubview:heartRate];
    
    bpm = [[UILabel alloc]initWithFrame:CGRectMake(0, 230*HEIGHT/667, WIDTH, 15*HEIGHT/667)];
    bpm.text = @"bpm";
    bpm.textAlignment = NSTextAlignmentCenter;
    bpm.textColor = [UIColor whiteColor];
    bpm.font = [UIFont systemFontOfSize:15*HEIGHT/667];
    [self.view addSubview:bpm];
    
    
    start = [[UIButton alloc]initWithFrame:CGRectMake((375/3)*WIDTH/375,400*HEIGHT/667, (375/3)*WIDTH/375, 40*HEIGHT/667)];
    start.backgroundColor = [UIColor whiteColor];
    start.layer.cornerRadius = 5*HEIGHT/667;
    [start addTarget:self action:@selector(startProgress:) forControlEvents:UIControlEventTouchUpInside];
    [start setTitle:@"开始测量" forState:UIControlStateNormal];
    [start setTitleColor: kUIColorFromRGB(0xff768b) forState:UIControlStateNormal];
    [start setTitle:@"重新测量" forState: UIControlStateSelected];
    [self.view addSubview:start];
    
    
    UIButton * left = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 25)];
    [left addTarget:self action:@selector(fanhui:) forControlEvents:UIControlEventTouchUpInside];
    [left setBackgroundImage:[UIImage imageNamed:@"junzuliebiao_06"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    
}

- (void)fanhui:(UIBarButtonItem *)left
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohang"] forBarMetrics:UIBarMetricsDefault];
    [self .navigationController popToRootViewControllerAnimated:YES];
}

-(void)startProgress:(UIButton *)sender;
{
    [self createProgress];
    sender.hidden = YES;
    //    sender.selected = !sender.selected;
    self.heartRateDetectionModel = [[DYJHeartRateDetectionModel alloc] init];
    self.heartRateDetectionModel.delegate = self;
    [self.heartRateDetectionModel startDetection];
}

#pragma mark ---------- 测量心率的delegate实现－－－－－－－
- (void)heartRateStart
{
    
}

- (void)heartRateUpdate:(int)bp atTime:(int)seconds;
{
    
    
    heartRate.text = [NSString stringWithFormat:@"%d",bp];
    
    
    
}
- (void)heartRateEnd
{
    
    
    
    
}


- (void)zhuangtai:(BOOL )neirong
{
    biaoshi = neirong;
    
    
}

- (void)createProgress
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimer:) userInfo:nil repeats:YES];
    _progressView= [[LDProgressView alloc] initWithFrame:CGRectMake(20, 400*HEIGHT/667, self.view.frame.size.width-40, 20*HEIGHT/667)];
    _progressView.color = [UIColor whiteColor];
    _progressView.flat = @YES;
    _progressView.animate = @YES;
    _progressView.showStroke = @NO;
    _progressView.progressInset = @4;
    _progressView.showBackground = @NO;
    _progressView.outerStrokeWidth = @3;
    _progressView.type = LDProgressSolid;
    [self.view addSubview:_progressView];
    
}

- (void)updateTimer:(NSTimer *)sender{
    
    
    if (biaoshi == YES) {
        i+=1;
        heartRate.hidden = NO;
        bpm.hidden = NO;
        imagevie.hidden = NO;
        _progressView.hidden = NO;
        prompt.hidden = YES;
    }else{
        heartRate.hidden = YES;
        bpm.hidden = YES;
        imagevie.hidden = YES;
        _progressView.hidden = YES;
        prompt.hidden = NO;
    }
    
    _progressView.progress = [[NSNumber numberWithInt:i] floatValue]/15;
    if (i == 15) {
        
        [_timer setFireDate:[NSDate distantFuture]];
        [_progressView removeFromSuperview];
        [self.heartRateDetectionModel stopDetection];
        
    }
    
}




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_timer setFireDate:[NSDate distantFuture]];
    [self.heartRateDetectionModel stopDetection];
    
    number =1;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohang"] forBarMetrics:UIBarMetricsDefault];
}

@end
