//
//  AVPainterViewController.m
//  MyPartOfFirstProject1
//
//  Created by Andrii V. on 26.01.15.
//  Copyright (c) 2015 Andrii V. All rights reserved.
//

#import "AVPainterViewController.h"

@interface AVPainterViewController ()

@property (strong, nonatomic) UIPopoverController *popover;

@end

@implementation AVPainterViewController

NSArray *arrayOfWals;
CGPoint positionOfFirstTapPanGestureGecognizer;

typedef NS_ENUM(NSInteger, AVDirrectionMove){
    AVDirrectionMoveUp,
    AVDirrectionMoveDown,
    AVDirrectionMoveLeft,
    AVDirrectionMoveRigth
};

typedef NS_ENUM(NSInteger, AVTypeOfPictureChange){
    AVSwipeTypeOfPictureChange,
    AVInitTypeOfPictureChange
};

#pragma mark - Initialisation for work
//initialization of walls
- (void) initWals{
    
    AVWall *wall1 = [AVWall new];
    wall1.wallPicture = [UIImage imageNamed:@"room1.jpg"];
    wall1.distanceToWall = @1;
    self.currentWall = wall1;
}


- (void) setImageWithWall :(UIImage *)image :(CGPoint)pictureCenter :(AVTypeOfPictureChange)typeOfPictureChange{
    
    //NSLog(@"%d", self.pictureIndex);
    
    NSNumber *alpha = @1;
    
    CGPoint sizeOfNewPicture = CGPointMake(image.size.width / (3 * self.currentWall.distanceToWall.doubleValue * alpha.doubleValue),
                                           image.size.height / (3 * self.currentWall.distanceToWall.doubleValue * alpha.doubleValue));
    
    CGRect frame = { .origin.x = 0.0, .origin.y = 0.0, .size.width = sizeOfNewPicture.x, .size.height = sizeOfNewPicture.y };
    
    [self.pictureImage removeFromSuperview];
    
    self.pictureImage = [[UIImageView alloc] initWithFrame:frame];
    
    self.pictureImage.image = image;
    
    self.price.text = [NSString stringWithFormat:@"%ld",(long)self.currentPicture.prise];
    
    self.pictureSize.text = [NSString stringWithFormat:@"W: %ld H: %ld", (long)self.currentPicture.pictureSize.width,
                             (long)self.currentPicture.pictureSize.height];
    
    self.authorsImage.image = self.currentPicture.pictureAuthor.authorsPhoto;
    
    self.authorsName.text = [NSString stringWithString:self.currentPicture.pictureAuthor.authorsName];
   
    self.authorsType.text = [NSString stringWithString:self.currentPicture.pictureAuthor.authorsType];
    
    self.titleOfPicture.text = [NSString stringWithString:self.currentPicture.pictureName];
    
    if (typeOfPictureChange == AVInitTypeOfPictureChange) {
        
        self.pictureImage.center = self.view.center;
        
        [self.roomImage addSubview:self.pictureImage];
        
    }
    
    if (typeOfPictureChange == AVSwipeTypeOfPictureChange) {
        
        if (pictureCenter.x - self.pictureImage.frame.size.width / 2 < 0)pictureCenter.x = self.pictureImage.frame.size.width / 2;
        if (pictureCenter.x + self.pictureImage.frame.size.width / 2 > 1024)pictureCenter.x = 1024 - self.pictureImage.frame.size.width / 2;
        if (pictureCenter.y - self.pictureImage.frame.size.height / 2 < 0)pictureCenter.y = self.pictureImage.frame.size.height / 2;
        if (pictureCenter.y + self.pictureImage.frame.size.height / 2 > 768)pictureCenter.y = 768 - self.pictureImage.frame.size.height / 2;
        self.pictureImage.center = pictureCenter;
        
        [self.roomImage addSubview:self.pictureImage];

    }
    
}

- (void) mainInit{
    
    if (self.session == nil) {
        self.session = [AVSession sessionInit];
        self.pictureIndex = 0;
        
    }
    
    self.currentPicture = [self.session.arrayOfPictures objectAtIndex:self.pictureIndex];
    
    
    [self initWals];
    
    self.roomImage.image = self.currentWall.wallPicture;
    
    UIImage *picture = self.currentPicture.pictureImage;
    
    [self setImageWithWall:picture
                          :self.roomImage.center
                          :AVInitTypeOfPictureChange];
    
    self.rightSwipe = [UISwipeGestureRecognizer new];
    
    self.rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.rightSwipe.delegate = self;
    
    self.leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    self.leftSwipe.delegate = self;
    
    self.panGestureRecognizer.delegate = self;
   
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self mainInit];
    
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

- (void) hideViews{
    
    self.upToolBar.hidden = YES;
    self.priceView.hidden = YES;
    self.authorsView.hidden = YES;
    self.titleOfPicture.hidden = YES;
}

- (void) pushVies{
    
    self.upToolBar.hidden = NO;
    self.priceView.hidden = NO;
    self.authorsView.hidden = NO;
    self.titleOfPicture.hidden = NO;
    
    [self.roomImage bringSubviewToFront:self.titleOfPicture];
    [self.roomImage bringSubviewToFront:self.upToolBar];
    [self.roomImage bringSubviewToFront:self.authorsView];
    [self.roomImage bringSubviewToFront:self.priceView];
}




#pragma mark - gesture recognizers
// swipe gesture recognizers left and right and changing picture
- (IBAction) swipePressAction:(UISwipeGestureRecognizer *)sender {
    CGPoint currentPoint = [sender locationInView:self.roomImage];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self hideViews];
    }
    if (![self ifPointInsidePicture: currentPoint]){
        if (sender.direction == UISwipeGestureRecognizerDirectionRight){
            if (self.pictureIndex == 0){
                self.pictureIndex = [self.session.arrayOfPictures count] - 1;
            } else self.pictureIndex--;
            self.currentPicture = [self.session.arrayOfPictures objectAtIndex:self.pictureIndex];
            [self setImageWithWall:self.currentPicture.pictureImage
                                  :self.pictureImage.center
                                  :AVSwipeTypeOfPictureChange];
        }
        if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
            if (self.pictureIndex == [self.session.arrayOfPictures count] - 1){
                self.pictureIndex = 0;
            } else self.pictureIndex++;
            self.currentPicture = [self.session.arrayOfPictures objectAtIndex:self.pictureIndex];
            [self setImageWithWall:self.currentPicture.pictureImage
                                  :self.pictureImage.center
                                  :AVSwipeTypeOfPictureChange];
        }        
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self pushVies];
    }
}

//we check is point into our picture or not
- (BOOL) ifPointInsidePicture:(CGPoint)point{
    
    if ((point.x > self.pictureImage.frame.origin.x)&&
        (point.y > self.pictureImage.frame.origin.y )&&
        (point.x < self.pictureImage.frame.origin.x + self.pictureImage.frame.size.width)&&
        (point.y < self.pictureImage.frame.origin.y + self.pictureImage.frame.size.height ))return YES;
    else return NO;
}

//we checking can we move pictur or not
- (BOOL) canMovePicture:(CGPoint)pickedPoint dirrectionToMove:(AVDirrectionMove)dirrection{
    
    if ([self ifPointInsidePicture: pickedPoint]){
        BOOL biggerHeigthOrWidth;
        if (self.roomImage.image.size.width * self.view.frame.size.height >
            self.roomImage.image.size.height * self.view.frame.size.width)biggerHeigthOrWidth = YES;
        else biggerHeigthOrWidth = NO;
        float intToCompare;
        switch (dirrection) {
            case AVDirrectionMoveUp:
                if (biggerHeigthOrWidth) {
                    intToCompare = self.view.frame.size.height / 2 - self.roomImage.image.size.height /
                    self.roomImage.image.size.width * self.view.frame.size.width / 2 + self.pictureImage.frame.size.height / 2 ;
                } else intToCompare = self.pictureImage.frame.size.height / 2 ;
                if (pickedPoint.y > intToCompare) return YES;
                else return NO;
                break;
            case AVDirrectionMoveDown:
                if (biggerHeigthOrWidth) {
                    intToCompare = self.view.frame.size.height / 2 + self.roomImage.image.size.height /
                    self.roomImage.image.size.width * self.view.frame.size.width / 2 - self.pictureImage.frame.size.height / 2;
                } else intToCompare = self.view.frame.size.height - self.pictureImage.frame.size.height / 2 ;
                if (pickedPoint.y < intToCompare) return YES;
                else return NO;
                break;
            case AVDirrectionMoveLeft:
                if (biggerHeigthOrWidth) {
                    intToCompare = self.view.frame.size.width - self.pictureImage.frame.size.width / 2;
                } else intToCompare = self.view.frame.size.width / 2 - self.roomImage.image.size.width /
                    self.roomImage.image.size.height * self.view.frame.size.height / 2 + self.pictureImage.frame.size.width / 2;
                if (pickedPoint.x > intToCompare) return YES;
                else return NO;
                break;
            case AVDirrectionMoveRigth:
                if (biggerHeigthOrWidth) {
                    intToCompare = self.pictureImage.frame.size.width / 2;
                } else intToCompare = self.view.frame.size.width / 2 + self.roomImage.image.size.width / self.roomImage.image.size.height *
                    self.view.frame.size.height / 2 - self.pictureImage.frame.size.width / 2;
                if (pickedPoint.x < intToCompare) return YES;
                else return NO;
                break;
            default:
                break;
        }
    }
    return NO;
}

//pan picture recognizer for moving picture on the screen
- (IBAction)pictureGestureRecognizerAction:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
            
        positionOfFirstTapPanGestureGecognizer = [sender locationInView:self.pictureImage];
        [self hideViews];
    }
        
    CGPoint differenceInLocation = CGPointMake([sender locationInView:self.pictureImage].x - positionOfFirstTapPanGestureGecognizer.x,
                                                   [sender locationInView:self.pictureImage].y - positionOfFirstTapPanGestureGecognizer.y);
        
    CGPoint newCenter = CGPointMake(self.pictureImage.center.x + differenceInLocation.x,
                                        self.pictureImage.center.y + differenceInLocation.y);
    
    if ([self canMovePicture:newCenter dirrectionToMove:AVDirrectionMoveUp]&&
        [self canMovePicture:newCenter dirrectionToMove:AVDirrectionMoveDown])
        self.pictureImage.center = CGPointMake(self.pictureImage.center.x, newCenter.y);
    
    if ([self canMovePicture:newCenter dirrectionToMove:AVDirrectionMoveLeft]&&
        [self canMovePicture:newCenter dirrectionToMove:AVDirrectionMoveRigth])
        self.pictureImage.center = CGPointMake(newCenter.x, self.pictureImage.center.y);
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self pushVies];
    }

}

//this method is for avoiding any conflicts by different gesture recognizers
- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    CGPoint currentPoint = [gestureRecognizer locationInView:self.roomImage];
    if ([gestureRecognizer isKindOfClass: [UIPanGestureRecognizer class]]){
        if ([self ifPointInsidePicture: currentPoint])return YES;
        else return NO;
    }
    
    if ([gestureRecognizer isKindOfClass: [UISwipeGestureRecognizer class]]){
        if ([self ifPointInsidePicture: currentPoint])return NO;
        else return YES;
    }
    
    return YES;
    
}

#pragma mark - popover
//here we push popower om thr screen
- (IBAction) pushPopover:(UIBarButtonItem *)sender {
    
    AVPopoverTableViewController *tableController = [self.storyboard instantiateViewControllerWithIdentifier:@"popover"];
    
    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:tableController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeWall:)
                                                 name:AVDidSelectWall
                                               object:nil];
    
    [popoverController presentPopoverFromBarButtonItem:sender
                              permittedArrowDirections:UIPopoverArrowDirectionDown
                                              animated:YES];
    
    popoverController.delegate = self;
    
    self.popover = popoverController;
    
    double delayInSeconds = 300.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.popover dismissPopoverAnimated:YES];
        self.popover = nil;
    });
    
}
//get a notification from popower controler whith chosen wall
//we also put wall on the screen
- (void) changeWall:(NSNotification *)notification{
    
    self.currentWall = [notification.userInfo valueForKey:@"wall"];
    self.roomImage.image = self.currentWall.wallPicture;
    [self setImageWithWall:self.currentPicture.pictureImage
                          :self.pictureImage.center
                          :AVInitTypeOfPictureChange];
    [self.popover dismissPopoverAnimated:YES];
    
    
}

// we remove our notification as soon as we don't need it
- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    self.popover = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (IBAction)backReturn:(id)sender {
    
    //self.dataManager = [AVManager sharedInstance];
    //self.dataManager.session = self.session;
    //self.dataManager.index = self.pictureIndex;
   
    //self.dataManager.wallImage = self.currentWall.wallPicture;
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)logAction:(id)sender {
    
    if ([self ifPointInsidePicture: [(UIGestureRecognizer *)sender locationInView:self.roomImage]]) {
        
        [self backReturn:sender];
        
    } else {
        [self setImageWithWall:self.currentPicture.pictureImage
                              :[(UIGestureRecognizer *)sender locationInView: self.roomImage]
                              :AVSwipeTypeOfPictureChange];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.dataManager = [AVManager sharedInstance];
    self.dataManager.index = self.pictureIndex;
    self.dataManager.wallImage = self.currentWall.wallPicture;
    
}
    


- (IBAction)send:(id)sender {
    
    self.pictureController = [AVPictureViewController new];
    
    [self presentViewController:self.pictureController animated: YES completion:^{
        
    }];
    
}


- (IBAction)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier  isEqual: @"Back to view picture"]) {
        
        self.pictureController = [AVPictureViewController new];
        
        [self presentViewController:self.pictureController animated: YES completion:^{
        
        }];
       
    }
}


@end