//
//  ViewController.h
//  CurrencyConverter
//
//  Created by NIKUL CHAUHAN on 3/4/16.
//  Copyright © 2016 NIKUL CHAUHAN. All rights reserved.
//  Contact No: 714-213-5652
//  Email ID: nikulchauhan@csu.fullerton.edu
/*
 Description:
    The is the header file which declares the pirckerview of home country and foreign country. 
    The text field which takes the input for currency.
    The label shows the converted currency from home country to foriegn country.
 
 */

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *CurrencyCountry;
    NSMutableArray *CurrencyStyle;
}

@property (weak, nonatomic) IBOutlet UIPickerView *HomePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *ForeignPickerView;
@property (weak, nonatomic) IBOutlet UITextField *CurrencyText;
@property (weak, nonatomic) IBOutlet UILabel *AnswerLabel;
- (IBAction)RefreshButton:(id)sender;


@end

