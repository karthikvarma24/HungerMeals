//
//  HMPaymentSuccessViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 23/11/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMPaymentSuccessViewController.h"
#import "ProjectConstants.h"
#import "HMHomePageViewController.h"

@implementation HMPaymentSuccessViewController


-(void)viewDidLoad{

    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;

}


- (IBAction)homeButtonAction:(id)sender {
    

    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    HMHomePageViewController *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomePage"];
    
    //UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
   // [self presentViewController:loginNav animated:YES completion:nil];
    
    [self.navigationController pushViewController:homeVC animated:YES];

}

@end
