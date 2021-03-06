//
//  LocationView.m
//  Hunger Meals
//
//  Created by Vamsi on 01/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "LocationView.h"
#import "Fonts.h"
#import "ProjectConstants.h"

@implementation LocationView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor colorWithRed:238.0/255.0f green:238.0/255.0f blue:238.0/255.0f alpha:1.0f];
    _instancesArray = [[NSMutableArray alloc] init];
    self.tableView.backgroundColor = [UIColor colorWithRed:238.0/255.0f green:238.0/255.0f blue:238.0/255.0f alpha:1.0f];
    self.tableView.hidden = YES;
    [self getLocations];
}

- (void)getLocations {
    
    //[self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
        
        SVService *service = [[SVService alloc] init];
    
    
    [service getLocationsDataUsingBlock:^(id result, NSHTTPURLResponse *response, NSError *err)  {
        
        
        if (result != nil) {
            
            _instancesArray = [[NSMutableArray alloc]init];
            _instancesArray = result;
            CGRect frame;
            if (_instancesArray.count > 3) {
                frame = CGRectMake(25, self.frame.size.height/2 - 150, self.frame.size.width - 50, 300);
            }
            else {
                frame = CGRectMake(25, (self.frame.size.height/2 - (_instancesArray.count * 100)/2), self.frame.size.width - 50, _instancesArray.count * 100);
            }
            self.stringToDisplay = (NSString *)[[[_instancesArray valueForKey:@"location"]valueForKey:@"name"]componentsJoinedByString:@""];
            
            if (frame.size.height < 80) {
                frame.size.height = 80;
                
            }
            self.tableView.frame = frame;
            self.tableView.hidden = NO;
            self.tableView.delegate = self;
            self.tableView.dataSource = self;

            
        }
        
        else {
            [self.delegate locationResponse: @"Unable to get Locations"];
        }
        
        [self.tableView reloadData];

    }];
    
    [self.tableView reloadData];
}
    
 - (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return _instancesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"LocationCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithRed:238.0/255.0f green:238.0/255.0f blue:238.0/255.0f alpha:1.0f];
//    if (indexPath.row == 0) {
//        [cell.locationLabel setText: @""];
//        [cell.locationLabel setTextColor:APPLICATION_TITLE_COLOR];
//        [cell.locationLabel setFont:[Fonts nevisWithSize:19.0]];
//        cell.locationLeadingConstraint.constant = -13;
//        cell.radioButton.hidden = true;
//    } else {
    
        NSDictionary *instance = _instancesArray [indexPath.row];
       [cell.locationLabel setText: instance [@"address"]];
        
        [cell.locationLabel setTextColor:[UIColor colorWithRed:119.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0f]];
        [cell.locationLabel setFont:[Fonts HelveticaWithSize:13.0]];
        cell.radioButton.hidden = false;
        cell.locationLeadingConstraint.constant = 8;
        NSInteger selectedLoc = [[USER_DEFAULTS valueForKey: @"selectedLocation"] integerValue];
        cell.locationLabel.text = (NSString *)[[_instancesArray[indexPath.row] valueForKey:@"location"]valueForKey:@"name"];
        if (selectedLoc == indexPath.row) {
            _selectedIndexPath = indexPath;
            [cell.radioButton setImage: [UIImage imageNamed: kRadioOn] forState: UIControlStateNormal];
        } else {
            [cell.radioButton setImage: [UIImage imageNamed: kRadioOff] forState: UIControlStateNormal];
        }
    //}
    return cell;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"Select Location";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        LocationTableViewCell *cell;
        if (_selectedIndexPath != nil) {
            cell = [self.tableView cellForRowAtIndexPath: _selectedIndexPath];
            [cell.radioButton setImage: [UIImage imageNamed: kRadioOff] forState: UIControlStateNormal];
        }
        _selectedIndexPath = indexPath;
        cell = [self.tableView cellForRowAtIndexPath: indexPath];
        [cell.radioButton setImage: [UIImage imageNamed: kRadioOn] forState: UIControlStateNormal];
        APPDELEGATE.selectedInstance = (int)_selectedIndexPath.row;
        [USER_DEFAULTS setValue: [NSString stringWithFormat: @"%ld", (long)indexPath.row] forKey: @"selectedLocation"];
        
        NSString *locationID = [[_instancesArray[indexPath.row] valueForKey:@"location"]valueForKey:@"id"];
        [[NSUserDefaults standardUserDefaults] setObject:locationID forKey:@"locationID"];
    
    
//    if (indexPath.row == 0) {
//        
//        //[self.delegate selectedLocation: @{@"address":@"Banglore"}];
//    } else {
        [self.delegate selectedLocation: _instancesArray [indexPath.row]];
   // }
    
    //[self.tableView reloadData];
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
        return 50;
    
}
@end
