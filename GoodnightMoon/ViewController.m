//
//  ViewController.m
//  GoodnightMoon
//
//  Created by Diego Cichello on 1/15/15.
//  Copyright (c) 2015 Mobile Makers. All rights reserved.
//

#import "ViewController.h"
#import "ImageCollectionViewCell.h"

@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate, UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UIView *gayView;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *moonImagesArray;
@property NSMutableArray *sunImagesArray;
@property NSMutableArray *currentImagesArray;
@property (weak, nonatomic) IBOutlet UIView *shadeView;
@property NSTimer *kevinGayTimer;

@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;
@property (strong, nonatomic) UIDynamicItemBehavior *dynamicItemBehavior;
@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.moonImagesArray = [NSMutableArray new];
    self.sunImagesArray = [NSMutableArray new];

    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_1"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_2"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_3"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_4"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_5"]];
    [self.moonImagesArray addObject:[UIImage imageNamed:@"moon_6"]];


    [self.sunImagesArray addObject:[UIImage imageNamed:@"Kevin"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"Kevin"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"Kevin"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"Kevin"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"Kevin"]];
    [self.sunImagesArray addObject:[UIImage imageNamed:@"Kevin"]];


    self.currentImagesArray = self.moonImagesArray;



}

- (void)viewDidAppear:(BOOL)animated
{
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView]];
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:[NSArray arrayWithObject:self.shadeView] mode:UIPushBehaviorModeContinuous];

    [self.collisionBehavior addBoundaryWithIdentifier:@"bottom"
                                            fromPoint:CGPointMake(0, self.view.frame.size.height)
                                              toPoint:CGPointMake(self.view.frame.size.width, self.view.frame.size.height)];

    [self.collisionBehavior addBoundaryWithIdentifier:@"top"
                                            fromPoint:CGPointMake(0, -565)
                                              toPoint:CGPointMake(self.view.frame.size.width, -565)];





    [self.gravityBehavior setGravityDirection:CGVectorMake(0, 0)];  // no gravity when the view loads

    [self.dynamicItemBehavior setElasticity:0.25];   // for bouncing off the boundaries

    [self.dynamicAnimator addBehavior:self.collisionBehavior];
    [self.dynamicAnimator addBehavior:self.gravityBehavior];
    [self.dynamicAnimator addBehavior:self.pushBehavior];
    [self.dynamicAnimator addBehavior:self.dynamicItemBehavior];

    self.collisionBehavior.collisionDelegate = self;
}


- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    NSString *string = (NSString *)identifier;

    if ([string isEqualToString:@"bottom"])
    {
        self.currentImagesArray = self.sunImagesArray;
        [self.collectionView reloadData];
        self.gayView.hidden = false;

        self.gayView.backgroundColor = [UIColor purpleColor];
        self.kevinGayTimer = [NSTimer scheduledTimerWithTimeInterval: 0.05 target: self selector: @selector(handleTimerTick) userInfo: nil repeats: YES];
        self.gayView.alpha =0.4;
    }
    
}




- (void) handleTimerTick
{
    [self changeAllColors];
}


- (void) changeAllColors
{
    self.gayView.backgroundColor = [self randColor];

}


- (UIColor *) randColor
{
    CGFloat red = (arc4random()%255);
    CGFloat blue = (arc4random()%255);
    CGFloat green = (arc4random()%255);
    UIColor *randColor =[ UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
    return randColor;

}




- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageView.image = [self.currentImagesArray objectAtIndex:indexPath.row];
    return cell;
}
- (IBAction)panHandler:(UIPanGestureRecognizer *)gesture
{
    CGPoint translation = [gesture translationInView:gesture.view];
    gesture.view.center = CGPointMake(gesture.view.center.x,  gesture.view.center.y + translation.y);
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view];

    CGFloat yVelocity = [gesture velocityInView:gesture.view].y;  // get the y velocity

    if (gesture.state == UIGestureRecognizerStateEnded) {

        [self.dynamicAnimator updateItemUsingCurrentState:self.shadeView];

        if (yVelocity < -500.0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            [self.dynamicItemBehavior setElasticity:0.5];
            [self.pushBehavior setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
        }
        else if (yVelocity >= -500.0 && yVelocity < 0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, -1)];
            [self.dynamicItemBehavior setElasticity:0.25];
            [self.pushBehavior setPushDirection:CGVectorMake(0, -500.0)];
        }
        else if (yVelocity >= 0 && yVelocity < 500.0) {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            [self.dynamicItemBehavior setElasticity:0.25];
            [self.pushBehavior setPushDirection:CGVectorMake(0, 500.0)];
        } else {
            [self.gravityBehavior setGravityDirection:CGVectorMake(0, 1)];
            [self.dynamicItemBehavior setElasticity:0.5];
            [self.pushBehavior setPushDirection:CGVectorMake(0, [gesture velocityInView:gesture.view].y)];
        }
    }

}

@end
