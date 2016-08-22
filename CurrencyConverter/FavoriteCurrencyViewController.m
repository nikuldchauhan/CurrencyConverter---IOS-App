//
//  FavoriteCurrencyViewController.m
//  CurrencyConverter
//
//  Created by NIKUL CHAUHAN on 3/8/16.
//  Copyright © 2016 NIKUL CHAUHAN. All rights reserved.
//  Contact No: 714-213-5652
//  Email ID: nikulchauhan@csu.fullerton.edu
/*
 Description:
    This is the file where Currency are filled in TableView. From list of currency user can select 1 or more currency to add into favorite currrency list.
 */

#import "FavoriteCurrencyViewController.h"
#import "ShowFavoriteCurrencyViewController.h"
@interface FavoriteCurrencyViewController ()

@end

@implementation FavoriteCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableData = _array;
    _TableView.allowsMultipleSelection = YES;
    NSLog(@"%@*",_array);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [tableData objectAtIndex:indexPath.row]];
    //cell.textLabel.text = [tableData objectAtIndex:indexPath.row];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //check the name of the segue
    if ([[segue identifier] isEqualToString:@"ShowThirdSegue"]) {
        
        //get the destination view controller
        ShowFavoriteCurrencyViewController *Controller = [segue destinationViewController];
        
        NSString *listOfcurrencys = @"";
        NSArray *indexPathArray = [self.TableView indexPathsForSelectedRows];
        NSMutableArray *arrayOfcurrencys = [[NSMutableArray alloc] init];
        for(NSIndexPath *index in indexPathArray)
        {
            //Assuming that 'idFriends' is an array you've made containing the id's (and in the same order as your tableview)
            //Otherwise embed the ID as a property of a custom tableViewCell and access directly from the cell
            //Also assuming you only have one section inside your tableview
            NSString *crid = [tableData objectAtIndex:index.row];
            //if([indexPathArray lastObject]!=index)
            {
                //listOfcurrencys = [listOfcurrencys stringByAppendingString:[crid stringByAppendingString:@", "]];
                [arrayOfcurrencys addObject:crid];
            }
           // else
           // {
                //listOfcurrencys = [listOfcurrencys stringByAppendingString:crid];
                //[arrayOfcurrencys addObject:crid];
            //}
        }
        
        NSLog(@"Your comma separated string is %@",arrayOfcurrencys);
        Controller.array = [[NSMutableArray alloc]initWithArray:arrayOfcurrencys];
        //integer indicating which cell was clicked
        //we could use this to dymanically pass the data from the clicked cell
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        //pass the data
        //assign the value to a property
        //Controller.array = [[NSMutableArray alloc]initWithArray:CurrencyStyle];
        //NSLog(@"%@",Controller.array);
    }
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
