//
//  HMSignUpThirdViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 20/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMSignUpThirdViewController.h"
#import "BTAlertController.h"
#import "HMConstants.h"
#import "ProjectConstants.h"
#import "SVService.h"
#import "UserData.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>

@interface HMSignUpThirdViewController (){
    
    CALayer *bottomBorder;

    NSInteger numRows;
    int *count;
    NSMutableArray *indexPathsOfCells;
    NSMutableArray *savedLocationIDs;
    
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *addressString;
    double latitudeValue;
    double longitudeValue;
}

@end

@implementation HMSignUpThirdViewController
@synthesize managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    numRows = 2;
    //[self.addressTableView setTableFooterView:self.tableFooterView];
    [self.addressTableView setBackgroundColor:[UIColor clearColor]];
    self.pageIndex = 3;
    
    [self textFieldProperties];
    
    [self TextFieldsFonts];

    savedLocationIDs = [[NSMutableArray alloc] init];
    
    geocoder = [[CLGeocoder alloc] init];
    latitudeValue = 0;
    longitudeValue = 0;
    // Do any additional setup after loading the view.
}

-(void)textFieldProperties{
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.pinCodeTextField.frame.size.height - 1, self.pinCodeTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.pinCodeTextField.layer addSublayer:bottomBorder];
    
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.nameTextField.frame.size.height - 1, self.nameTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.nameTextField.layer addSublayer:bottomBorder];
    
    
    
//    bottomBorder = [CALayer layer];
//    bottomBorder.frame = CGRectMake(0.0f, self.deliveryAddressTextFiels.frame.size.height - 1, self.deliveryAddressTextFiels.frame.size.width, 1.0f);
//    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
//    [self.deliveryAddressTextFiels.layer addSublayer:bottomBorder];
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.flatNumberTextField.frame.size.height - 1, self.flatNumberTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.flatNumberTextField.layer addSublayer:bottomBorder];
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.areaLocalityTextField.frame.size.height - 1, self.areaLocalityTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.areaLocalityTextField.layer addSublayer:bottomBorder];
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.stateTextField.frame.size.height - 1, self.stateTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.stateTextField.layer addSublayer:bottomBorder];
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.cityTextField.frame.size.height - 1, self.cityTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.cityTextField.layer addSublayer:bottomBorder];
    
    
}

-(void)TextFieldsFonts{
    UIColor *color = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:0.5];
    self.pinCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Pincode" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.flatNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Building/Flat No/House No" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.areaLocalityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Area/Locality" attributes:@{NSForegroundColorAttributeName: color}];
    
    
    self.stateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"State" attributes:@{NSForegroundColorAttributeName: color}];
    
    
    self.cityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"City" attributes:@{NSForegroundColorAttributeName: color}];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Addresses"];
    NSMutableArray *array = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
}

- (void)showAlertWithMsg:(NSString *)msg{
    [BTAlertController showAlertWithMessage:msg andTitle:@"" andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}

#pragma mark - UITableView Delegate and Data Source Methods
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return numRows;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString *addressCellIdentifier = @"AddressTableCell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCellIdentifier];
//    }
//    
//    if (indexPath.row == 1) {
//        UILabel *label = (UILabel *)[cell viewWithTag:101];
//        label.text = @"Office";
//    }
//
//    [indexPathsOfCells addObject:indexPath];
//    
//    return cell;
//    
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//}


- (IBAction)skipButtonAction:(id)sender {
   // [self SignUpToServer];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)saveButtonAction:(id)sender {
    
    if (![[self checkFieldsValidity]  isEqual: @""]) {
        [self showAlertWithTitle:@"Hunger Meals" andMessage:[self checkFieldsValidity]];
    }
    else {
        [self SignUpToServer];
    }
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    [BTAlertController showAlertWithMessage:message andTitle:title andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}


-(NSString *)checkFieldsValidity{
    
  if (self.flatNumberTextField.text.length == 0 || self.areaLocalityTextField.text.length == 0 || self.nameTextField.text.length == 0 || self.stateTextField.text.length == 0 || self.cityTextField.text.length ==0) {
        return @" All Fields are mandatory";
    }
    
    if (self.pinCodeTextField.text.length != 6) {
        return @"Please enter valid pincode";
    }
    
    return @"";
}






-(void) saveLocation

{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.areaLocalityTextField.text, @"name", self.cityTextField.text, @"city", placemark.subLocality, @"sublocation",  self.stateTextField.text, @"address", [NSString stringWithFormat:@"%f",latitudeValue],  @"lat", [NSString stringWithFormat:@"%f",longitudeValue], @"lng", self.pinCodeTextField.text, @"zip", @"userlocation", @"type", nil];
    SVService *service = [[SVService alloc] init];
    [service getLocationID:dict usingBlock:^(NSString *locationId) {
        
        if (locationId != nil || ![locationId isEqualToString:@""]) {
            
            [self syncLocationForUser:locationId];
            [savedLocationIDs addObject:locationId];
            

        }
       
    }];

}

- (void)syncLocationForUser:(NSString *)locationID{

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: locationID, @"location_id", nil];
    SVService *service = [[SVService alloc] init];
    [service syncLocationToUserAccount:dict usingBlock:^(NSString *resultMessage) {
        
        if (resultMessage != nil || ![resultMessage isEqualToString:@""]) {
            NSLog(@"%@", resultMessage);
                        
            [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
            
            [APPDELEGATE showInitialScreen];
  
        }
        
    }];

}

- (BOOL)SignUpToServer

{
    __block BOOL isSignupSucess;
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.userName, @"name", self.email, @"email", self.password, @"password",  @"authenticated_user", @"role_name", self.phoneNumber,  @"phone_no", nil];
    SVService *service = [[SVService alloc] init];
    [service createUser:dict usingBlock:^(NSMutableArray *resultArray) {
        
        
        if (resultArray.count != 0 || resultArray != nil) {
            UserData *dataObject = resultArray[0];
            NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dataObject];
            [[NSUserDefaults standardUserDefaults] setObject:personEncodedObject forKey:@"UserData"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoginValid"];
            isSignupSucess = YES;
            
             [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
            
            
            [self saveLocation];

    
        }
        else {
            [self showAlertWithMsg:@"Couldn't able to signup now. Please try again later"];
        }
       
    }];
    
    return isSignupSucess;
    
}

- (IBAction)addAddressAction:(id)sender {
    [self addRow];
}

#pragma mark - Core Data Methods
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)saveAddressToDB:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    UITableView *tableView = self.addressTableView;
    NSMutableSet *addressTextViews = [[NSMutableSet alloc] init];
    
    for (NSIndexPath *indexPath in indexPathsOfCells){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        for (UITextView *textView in cell.contentView.subviews) {
            if ([textView isKindOfClass:NSClassFromString(@"UITextView")]) {
                if (![textView.text isEqualToString:@""]) {
                    [addressTextViews addObject:textView];
                }
            }
        }
    }
    
    for (UITextView *textView in addressTextViews) {
            // Create a new managed object for Address
            NSManagedObject *addressEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Addresses" inManagedObjectContext:context];
            [addressEntity setValue:textView.text forKey:@"address"];
            
            NSError *error = nil;
            // Save the object to persistent store
            if (![context save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
                [self showAlertWithMsg:@"While saving your address error encountered. Please try again"];
            }
            else{
                [self showAlertWithMsg:@"Your address has been saved successfully"];
            }
    }
    
}
-(void)addRow
{
    //ASSUMING THIS CHUNK IS CALLED FROM A LOOP
    NSIndexPath *path = [NSIndexPath indexPathForRow:numRows inSection:0];
    numRows = numRows + 1;
    [self.addressTableView beginUpdates];
    [self.addressTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];
    [self.addressTableView endUpdates];
}

- (IBAction)shareLocationButtonAction:(id)sender {

    
   self.areaLocalityTextField.text=@"";
    _stateTextField.text=@"";
   _cityTextField.text=@"";
    self.pinCodeTextField.text=@"";
    self.nameTextField.text=@"";
    self.stateTextField.text=@"";
    _areaLocalityTextField.text=@"";

    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
        ) {
        // Will open an confirm dialog to get user's approval
        [locationManager requestWhenInUseAuthorization];
    } else {
        [locationManager startUpdatingLocation];
        
        //Will update location immediately
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"We are currently not able to detect your location. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    [locationManager stopUpdatingLocation];
    locationManager = nil;
    [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            
            _pinCodeTextField.text = placemark.postalCode;
            _flatNumberTextField.text = placemark.subThoroughfare;
            _areaLocalityTextField.text = [NSString stringWithFormat:@"%@, %@", placemark.thoroughfare, placemark.subLocality];
            _stateTextField.text = placemark.administrativeArea;
            _cityTextField.text = placemark.subAdministrativeArea;
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            latitudeValue = coordinate.latitude;
            longitudeValue = coordinate.longitude;
            
        } else {
            NSLog(@"%@", error.debugDescription);
        }
        [locationManager stopUpdatingLocation];
        locationManager = nil;
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    } ];
    
    
}

@end
