//
//  ViewController.m
//  SquareCameraDemo
//
//  Created by Peter Pan on 11/26/13.
//  Copyright (c) 2013 Peter Pan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int squareImageStartY;
    UIImagePickerController *pickerController;
}
@end

@implementation ViewController


- (IBAction)showImagePicker:(id)sender {
    
    pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.showsCameraControls = NO;
    // on 4 inch screen,  camera view is 320 * 426
    squareImageStartY = 426 - 320;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, squareImageStartY)];
    [pickerController.cameraOverlayView addSubview:topView];
    topView.backgroundColor = [UIColor blackColor];
    
    int y = topView.frame.origin.y +topView.frame.size.height + 320;
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, y, 320, [UIScreen mainScreen].bounds.size.height - y)];
    [pickerController.cameraOverlayView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor blackColor];

    
    
    UIButton *takePhotoBut = [[UIButton alloc] initWithFrame:CGRectMake(160-50,
                                                                        bottomView.frame.size.height/2 - 25, 100, 50)];
    [bottomView addSubview:takePhotoBut];
    [takePhotoBut setTitle:@"take photo" forState:UIControlStateNormal];
    [takePhotoBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [takePhotoBut addTarget:pickerController action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self presentViewController:pickerController animated:YES completion:nil ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

    // originalImage's ratio is 3:4, size is 2448 * 3264
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:^{
       
        CGImageRef imageRef = nil;
        if([UIScreen mainScreen].bounds.size.height > 480)
        {
            UIGraphicsBeginImageContext(CGSizeMake(640, 852));
            [originalImage drawInRect: CGRectMake(0, 0, 640, 852)];
            UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            int y = squareImageStartY*2;
            CGRect cropRect = CGRectMake(0, y, 640, 640);
            imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
            
            
        }
        else
        {
            UIGraphicsBeginImageContext(CGSizeMake(720, 960));
            [originalImage drawInRect: CGRectMake(0, 0, 720, 960)];
            UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            int y = squareImageStartY*2;
            CGRect cropRect = CGRectMake(40, y, 640, 640);
            imageRef = CGImageCreateWithImageInRect([smallImage CGImage], cropRect);
            
        }
       
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 320)];
        imageView.backgroundColor = [UIColor yellowColor];
        [imageView setImage:[UIImage imageWithCGImage:imageRef]];
        
        [self.view addSubview:imageView];
        

    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - touch

-(void)removeFocusView:(UIView*)focusView
{
    [focusView removeFromSuperview];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:pickerController.cameraOverlayView];
    UIView *focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    focusView.center = point;
    focusView.layer.borderColor = [UIColor redColor].CGColor;
    focusView.layer.borderWidth = 1;
    [pickerController.cameraOverlayView addSubview:focusView];


    [self performSelector:@selector(removeFocusView:) withObject:focusView afterDelay:0.3];
    
    
    
}


@end
