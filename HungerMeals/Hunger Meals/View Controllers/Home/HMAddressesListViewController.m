//
//  HMAddressesListViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/11/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMAddressesListViewController.h"
#import "HMAddressesCell.h"
#import "SVService.h"
#import "HmDelieveriAddressViewController.h"
#import "HMPaymentTypeSelectionViewController.h"
#import "BTAlertController.h"



@implementation HMAddressesListViewController
{
    NSInteger selectedAddressRow;
    NSString *addressString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Delivery Address";
    selectedAddressRow = -111;
    [self getLocations];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.addressesTableView.frame.size.width, 40)];
    
    UILabel *selectAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, headerView.frame.size.height/2-15,200, 15)];
    selectAddressLabel.text = @"Select Address";
    selectAddressLabel.textColor = APPLICATION_TITLE_COLOR;
    [headerView addSubview:selectAddressLabel];
    

    
    UIButton *addNewAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    addNewAddressButton.frame=CGRectMake(self.view.bounds.size.width - 115, selectAddressLabel.frame.origin.y - 7.5, 100, 20);
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:@"Add new"];
    
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [titleString length])];
    
    // using text on button
    
    
    [titleString addAttribute:NSForegroundColorAttributeName value:APPLICATION_TITLE_COLOR range:NSMakeRange(0, [titleString length])];

    [addNewAddressButton setAttributedTitle:titleString forState:UIControlStateNormal];
        
    [headerView addSubview:addNewAddressButton];
    addNewAddressButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    [addNewAddressButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Regular" size:12.0]];
    [addNewAddressButton addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.addressesTableView.frame.size.width, 40)];
    
    UIButton *proceedToCheckout = [[UIButton alloc]initWithFrame:CGRectMake(footerView.frame.size.width/2-125,headerView.frame.size.height/2-15,250,50)];
    [proceedToCheckout setTitle:@"Proceed to checkout" forState:UIControlStateNormal];
    [proceedToCheckout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    proceedToCheckout.layer.cornerRadius = 5;
    [proceedToCheckout setBackgroundColor:APPLICATION_COLOR];
    [footerView addSubview:proceedToCheckout];
    [proceedToCheckout addTarget:self action:@selector(proceedToCheckOut) forControlEvents:UIControlEventTouchUpInside];
    

    
    self.addressesTableView.tableHeaderView = headerView;
    self.addressesTableView.tableFooterView = footerView;

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getLocations];
}
- (void)showAlertWithMsg:(NSString *)msg{
    [BTAlertController showAlertWithMessage:msg andTitle:@"Hunger Meals" andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AddressCellIdentifier";
    HMAddressesCell *cell = (HMAddressesCell *)[self.addressesTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(selectedAddressRow == indexPath.row){
        cell.radioButtonImageView.image = [UIImage imageNamed:@"RadioOn"];
    }else{
        cell.radioButtonImageView.image = [UIImage imageNamed:@"RadioOff"];
    }
    
    cell.addressLabel.textAlignment = NSTextAlignmentLeft;
    cell.addressLabel.textColor = APPLICATION_SUBTITLE_COLOR;
    cell.addressLabel.text = self.addressesArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMAddressesCell *addressCell = (HMAddressesCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    addressCell.radioButtonImageView.image = [UIImage imageNamed:@"RadioOn"];
    addressCell.isRadioButtonSelected = YES;
    
    selectedAddressRow = indexPath.row;
    addressString = addressCell.addressLabel.text;
    
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    HMAddressesCell *addressCell = (HMAddressesCell *)[tableView cellForRowAtIndexPath:indexPath];

    addressCell.radioButtonImageView.image = [UIImage imageNamed:@"RadioOff"];
    addressCell.isRadioButtonSelected = NO;

}


- (void)getLocations {
    
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    
    [service getUpdateLocationsDataUsingBlock:^(NSMutableDictionary *resultArray) {
        //[_instancesArray addObject: @{@"address":@"Banglore"}];
        if (resultArray != nil || resultArray.count != 0) {
            
            NSArray *addArray=[resultArray valueForKey:@"data"];
            
            self.addressesArray = [NSMutableArray new];

            
            for (int i=0; i<[addArray count]; i++) {
                
                
                
             [self.addressesArray  addObject:[[addArray objectAtIndex:i]valueForKeyPath:@"location.address"] ];
                
                
            }

            
        }
        [self.addressesTableView reloadData];
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
-(void)addNewAddress{
   
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HmDelieveriAddressViewController *cartViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"deliverAddressIdentifier"];
    [self.navigationController pushViewController:cartViewController animated:YES];

    
}

-(void)proceedToCheckOut{
    if(selectedAddressRow == -111){
        
        [self showAlertWithMsg:@"Please choose your deliver address to proceed further"];
  
    }else {

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HMPaymentTypeSelectionViewController *paymentType = [mainStoryBoard instantiateViewControllerWithIdentifier:@"paymentTypeIdentifier"];
    paymentType.PaymentAmountString= self.priceString;
    paymentType.addressString = addressString;
        
    [self.navigationController pushViewController:paymentType animated:YES];
    }
}

@end
