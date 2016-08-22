//
//  ShowFavoriteCurrencyViewController.m
//  CurrencyConverter
//
//  Created by NIKUL CHAUHAN on 3/9/16.
//  Copyright © 2016 NIKUL CHAUHAN. All rights reserved.
//  Contact No: 714-213-5652
//  Email ID: nikulchauhan@csu.fullerton.edu
/*
 Description:
 This is the file which shows list of the user's favorite currency. t also save and loads up the favorite currency list to/from disk.
 

 */

#import "ShowFavoriteCurrencyViewController.h"

NSMutableArray *FinalCurrencyList;
NSMutableArray *fcl;

@interface ShowFavoriteCurrencyViewController ()

@end

@implementation ShowFavoriteCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    FinalCurrencyList = [[NSMutableArray alloc] init];
    fcl = [[NSMutableArray alloc] init];
    NSLog(@"NNNNNNNN");
    //
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *rootPath = paths[0];
    NSString* path = [rootPath stringByAppendingPathComponent:@"CurrencyConvertor"];
    /// fill in the file's pathname
    path = [path stringByAppendingPathComponent:@"favoritecurrency.plist"];
    FinalCurrencyList = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] mutableCopy];
            NSLog(@"In IF statement");
            NSLog(@"%@", FinalCurrencyList);
            NSLog(@"%@", _array);
            NSLog(@"%@", path);

    //
    fcl = [NSMutableArray arrayWithArray:_array];
    [fcl addObjectsFromArray: FinalCurrencyList];
    tableData = fcl;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *rootPath = paths[0];
    NSString* path = [rootPath stringByAppendingPathComponent:@"CurrencyConvertor"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error]; //Create folder
        path = [path stringByAppendingPathComponent:@"favoritecurrency.plist"];
        [NSKeyedArchiver archiveRootObject:fcl toFile:path];
        NSLog(@"IF %@", path);
    }
    else
    {
        path = [path stringByAppendingPathComponent:@"favoritecurrency.plist"];
        [NSKeyedArchiver archiveRootObject:fcl toFile:path];
        NSLog(@"else %@", path);

    }
    NSLog(@"%@", [[NSKeyedUnarchiver unarchiveObjectWithFile:path] mutableCopy]);
    NSLog(@"Save data");
    //
    //
    



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
