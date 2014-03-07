//
//  JTDynamicsViewController.m
//  myDynamicsProject
//
//  Created by Jingting Wang on 3/6/14.
//  Copyright (c) 2014 JT. All rights reserved.
//

#import "JTDynamicsViewController.h"

@interface JTDynamicsViewController ()<UICollisionBehaviorDelegate>
@property (strong, nonatomic) UIDynamicAnimator* animator;
@property (strong, nonatomic) UIGravityBehavior* gravity;
@property (strong, nonatomic) UICollisionBehavior* collision;
@end

@implementation JTDynamicsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView* square = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100,100)];
    square.backgroundColor = [UIColor grayColor];
    [self.view addSubview:square];
    
    UIView* barrier = [[UIView alloc] initWithFrame:CGRectMake(0, 300, 130, 20)];
    barrier.backgroundColor = [UIColor redColor];
    [self.view addSubview:barrier];
    
    CGPoint rightEdge = CGPointMake(barrier.frame.origin.x +
                                    barrier.frame.size.width, barrier.frame.origin.y);
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    self.gravity = [[UIGravityBehavior alloc]initWithItems:@[square]];
    
    __weak typeof(self) weakself = self;
    __block int counter = 0;
    self.gravity.action = ^{
        if (counter%5 == 0) {
            CGRect newFrame = square.frame;
            UIView* square2 = [[UIView alloc]initWithFrame:newFrame];
            square2.center = square.center;
            square2.bounds = square.bounds;
            square2.transform = square.transform;
            
            square2.layer.borderColor = [square.backgroundColor CGColor];
            square2.layer.borderWidth = 1.0;
            square2.backgroundColor = [UIColor clearColor];
            [weakself.view addSubview:square2];
        }
        counter +=1 ;
    };
    
    
    self.collision = [[UICollisionBehavior alloc]initWithItems:@[square]];
    self.collision.collisionDelegate = self;
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.collision addBoundaryWithIdentifier:@"barrier"
                                    fromPoint:barrier.frame.origin
                                      toPoint:rightEdge];
    
    [self.animator addBehavior:self.collision];
    [self.animator addBehavior:self.gravity];
    
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[square]];
    itemBehaviour.elasticity = 0.6;
    [_animator addBehavior:itemBehaviour];
}

#pragma mark -- UICollisionBehaviorDelegate
-(void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
{
    NSLog(@"Boundary contact occurred - %@ %f %f", identifier, p.x, p.y);
    UIView* view = (UIView*)item;
    view.backgroundColor = [UIColor yellowColor];
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor grayColor];
    }];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
