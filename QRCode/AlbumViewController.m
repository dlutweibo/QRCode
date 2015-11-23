//
//  AlbumViewController.m
//  QRCode
//
//  Created by 魏博 on 15/11/17.
//  Copyright © 2015年 魏博. All rights reserved.
//

#import "AlbumViewController.h"

@interface AlbumViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self resultFromQRCodeImage:[info objectForKey:UIImagePickerControllerOriginalImage]];
    
}

- (void)resultFromQRCodeImage:(UIImage *)QRCodeImage {
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:QRCodeImage.CGImage];
    
    NSArray *features = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    NSString *result = feature.messageString;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"识别完毕" message:result ? @"显示还是尝试用浏览器打开？" : @"啥也没有= =,你确定选择的是二维码？" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"显示" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.resultLabel setText:result];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"尝试打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:result]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)selectPhoto:(id)sender {
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.delegate = self;
    [pickerVC setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

- (IBAction)click:(id)sender {    
    if ([self presentedViewController] == nil) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"识别图中二维码？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"识别" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self resultFromQRCodeImage:self.QRCodeImageView.image];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        return;
    }
}

@end
