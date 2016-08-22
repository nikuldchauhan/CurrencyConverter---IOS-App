//
//  FavoriteCurrencyViewController.h
//  CurrencyConverter
//
//  Created by NIKUL CHAUHAN on 3/8/16.
//  Copyright © 2016 NIKUL CHAUHAN. All rights reserved.
//  Contact No: 714-213-5652
//  Email ID: nikulchauhan@csu.fullerton.edu
/*
 Description:
            This is the file where TableView is declared.
 */

#import <UIKit/UIKit.h>

@interface FavoriteCurrencyViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *tableData;
}
@property (strong) NSMutableArray *array;
@property (weak, nonatomic) IBOutlet UITableView *TableView;
@end
