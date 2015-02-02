//
//  AVDetailViewController.m
//  iArtist
//
//  Created by Andrii V. on 31.01.15.
//  Copyright (c) 2015 SS projects. All rights reserved.
//

#import "AVDetailViewController.h"


typedef NS_ENUM(NSInteger, AVLeftView) {
    AVLeftViewEnable,
    AVLeftViewDisable
};

@interface AVDetailViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIView *leftView;
@property (strong, nonatomic) IBOutlet UILabel *pictureName;
@property (strong, nonatomic) IBOutlet UILabel *pictureTag;
@property (strong, nonatomic) IBOutlet UILabel *pictureSize;
@property (strong, nonatomic) IBOutlet UILabel *picturePrize;
@property (strong, nonatomic) IBOutlet UILabel *authorsName;
@property (strong, nonatomic) IBOutlet UILabel *authorsType;
@property (strong, nonatomic) IBOutlet UIImageView *authorsImage;
@property (strong, nonatomic) IBOutlet UITextView *pictureDescription;
@property (strong, nonatomic) IBOutlet UIImageView *authorDescription;


@property (nonatomic) AVLeftView leftviewindex;

@end

@implementation AVDetailViewController

- (void)iputDataInit{
    
    self.pictureName.text = self.inputPicture.pictureName;
    
    self.picturePrize.text = [NSString stringWithFormat:@"%ld",(long)self.inputPicture.prise];
    
    self.authorsName.text = self.pictureAuthor.authorsName;
    
    self.authorsType.text = self.pictureAuthor.authorsType;
    
    self.authorsImage.image = self.pictureAuthor.authorsPhoto;
    self.authorsImage.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)mainInit{
    self.mainView.contentSize = CGSizeMake(1024, 768);
    [self iputDataInit];
    
    self.leftviewindex = AVLeftViewEnable;
    self.imageView = [[UIImageView alloc] initWithImage:self.inputPicture.pictureImage];
    self.imageView.frame = self.mainView.frame;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self.mainView addSubview:self.imageView];
    self.mainView.delegate = self;
    self.mainView.maximumZoomScale = 2.5;
    self.mainView.minimumZoomScale = 1;
    
    [self.mainView bringSubviewToFront:self.closeButton];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self mainInit];
    
    // Do any additional setup after loading the view.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
//    return self.view;
}

- (IBAction)tapAction:(id)sender {
    
    if (self.leftviewindex == AVLeftViewEnable) {
        self.leftviewindex = AVLeftViewDisable;
        self.leftView.hidden = YES;
    } else {
        self.leftviewindex = AVLeftViewEnable;
        self.leftView.hidden = NO;
    }
}

- (IBAction)closeController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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