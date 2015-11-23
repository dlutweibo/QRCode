//
//  GeneratorViewController.m
//  QRCode
//
//  Created by 魏博 on 15/11/17.
//  Copyright © 2015年 魏博. All rights reserved.
//

#import "GeneratorViewController.h"

@interface GeneratorViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@end

@implementation GeneratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.saveButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)generate:(id)sender {
    if (self.textField.text.length == 0) {
        return;
    }
    
    NSData *data = [self.textField.text dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *QRFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [QRFilter setValue:data forKey:@"inputMessage"];
    [QRFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *QRImage = QRFilter.outputImage;
    
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:QRImage fromRect:QRImage.extent];
    UIGraphicsBeginImageContext(self.imageView.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    [self.imageView setImage:resultImage];
    [self.saveButton setTitle:@"保存至相册" forState:UIControlStateNormal];
    
}
- (IBAction)save:(id)sender {
    if (self.imageView.image) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        return;
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"%@", error.localizedDescription);
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
