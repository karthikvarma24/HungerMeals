//
//  HMSignUpThirdViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 20/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface HMSignUpThirdViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CLLocationManagerDelegate>



@property NSString *email;
@property NSString *password;
@property NSString *phoneNumber;
@property NSString *userName;
@property(strong,nonatomic) UIPageViewController *pageViewController;

@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *skipButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *shareButtonOutlet;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *pinCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *deliveryAddressTextFiels;
@property (weak, nonatomic) IBOutlet UITextField *flatNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaLocalityTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;


@property NSUInteger pageIndex;
- (IBAction)addAddressAction:(id)sender;

- (IBAction)skipButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@end
