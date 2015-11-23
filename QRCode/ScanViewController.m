//
//  ScanViewController.m
//  QRCode
//
//  Created by 魏博 on 15/11/17.
//  Copyright © 2015年 魏博. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>

#define SIZE_SCREEN [UIScreen mainScreen].bounds.size

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *scanView;

@property (nonatomic, strong) AVCaptureSession *session;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.scanView.layer setBorderWidth:1.0];
    [self.scanView.layer setBorderColor:[UIColor blueColor].CGColor];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error) {
        NSLog(@"%@", error.localizedDescription);
    } else {
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        self.session = [[AVCaptureSession alloc] init];
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
        [self.session addInput:input];
        [self.session addOutput:output];
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        output.rectOfInterest = CGRectMake(self.scanView.bounds.origin.y / SIZE_SCREEN.height, self.scanView.bounds.origin.x / SIZE_SCREEN.width, self.scanView.bounds.size.height / SIZE_SCREEN.height, self.scanView.bounds.size.width / SIZE_SCREEN.width);
        
        AVCaptureVideoPreviewLayer *preLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        [preLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [preLayer setFrame:[UIScreen mainScreen].bounds];
        [self.view.layer insertSublayer:preLayer atIndex:0];
        
        [self.session startRunning];

    }
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count == 0) {
        return;
    } else {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        NSString *result = metadataObject.stringValue;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"识别完毕" message:result ? result : @"没啥" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:result ? @"尝试用浏览器打开" : @"好吧" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (result.length == 0) {
                return;
            }
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
        }]];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
