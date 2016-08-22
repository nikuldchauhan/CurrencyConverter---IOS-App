//
//  ViewController.m
//  CurrencyConverter
//
//  Created by NIKUL CHAUHAN on 3/4/16.
//  Copyright © 2016 NIKUL CHAUHAN. All rights reserved.
//  Contact No: 714-213-5652
//  Email ID: nikulchauhan@csu.fullerton.edu
/*
 Description:
        This the file which controls the flow when user types the currency in textfield. it takes the input from text field, home county,
        and foreign country and passes to ExchangeRate model and get the exchange rate and set the converted value to label. It also control the refresh function. If exchange rate is more than 25 seconds it updates the exchange rate. It also saves the exchange rate to the disk and loads up the exchange rate that are already fetched from yahoo api.
 */

#import "ViewController.h"
#import "Currency.h"
#import "ExchangeRate.h"
#import "FavoriteCurrencyViewController.h"
NSMutableDictionary *CurrencyDictionary;
NSMutableDictionary *ExchangeRateDictionary;
ExchangeRate *ExchangeRateObject = nil;
NSMutableArray *CurrencyNameArray;
NSMutableArray *CurrencyStyleArray;
extern BOOL check = true;
@interface ViewController ()

@end

@implementation ViewController




// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
         return [CurrencyCountry count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [CurrencyCountry objectAtIndex:row];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //if(check){
    CurrencyNameArray = [[NSMutableArray alloc] init];
    CurrencyStyleArray = [[NSMutableArray alloc] init];
    CurrencyDictionary = [[NSMutableDictionary alloc] init];
    ExchangeRateDictionary = [[NSMutableDictionary alloc] init];
    //
    //NSMutableArray *Array = [NSKeyedUnarchiver unarchiveObjectWithFile:@"/Users/nikulchauhan/Documents/App/CurrencyConverter/CurrencyConverter/data.plist"];//
    NSURL * bundle = [[NSBundle mainBundle] bundleURL];
    NSURL * file = [NSURL URLWithString:@"data.plist" relativeToURL:bundle];
    NSURL * absoluteFile = [file absoluteURL];
    NSMutableArray *Array = [NSKeyedUnarchiver unarchiveObjectWithFile:[absoluteFile path]];
    
    //
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *rootPath = paths[0];
    NSString* path = [rootPath stringByAppendingPathComponent:@"CurrencyConvertor"];
    NSString *pathName = [pathName stringByAppendingPathComponent:@"ExchangeRateDictionary.plist"];  /// fill in the file's pathname
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:pathName])
    {
        ExchangeRateDictionary = [[NSKeyedUnarchiver unarchiveObjectWithFile:pathName] mutableCopy];
    }
    //
    for(Currency *curr in Array)
    {
        [CurrencyDictionary setObject:curr forKey:curr.CurrencyCountry];
        [CurrencyNameArray addObject:curr.CurrencyCountry];
        [CurrencyStyleArray addObject:curr.CurrencyName];
        //NSLog(@"%@", curr.CurrencyCountry);
    }
    self.HomePickerView.tag = 1;
    self.ForeignPickerView.tag = 2;
    CurrencyCountry = CurrencyNameArray;
    CurrencyStyle = CurrencyStyleArray;
        check = false;
    //}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //[self updateTextLabelsWithText: newString];
    NSLog(@"%@*",newString);
    ExchangeRateObject = [[ExchangeRate alloc]init];
    NSInteger row;
    row = [self.HomePickerView selectedRowInComponent:0];
    NSString *Home = [CurrencyCountry objectAtIndex:row];
    row = [self.ForeignPickerView selectedRowInComponent:0];
    NSString *Foreign = [CurrencyCountry objectAtIndex:row];
    ExchangeRateObject.HomeCurrency = [CurrencyDictionary objectForKey:Home];
    NSLog(@"%@", ExchangeRateObject.HomeCurrency.CurrencyAlphaCode);
    ExchangeRateObject.ForeignCurrency = [CurrencyDictionary objectForKey:Foreign];
    if(ExchangeRateDictionary == nil){
        NSLog(@"###");
        NSNumber *result = [ExchangeRateObject getForeignRate:[NSNumber numberWithDouble: [newString floatValue]]];
        NSNumber *answer = @([newString floatValue] * [result floatValue]);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:[ExchangeRateObject.ForeignCurrency.CurrencyMinor integerValue]];
        [formatter setMinimumFractionDigits:0];
        NSString *answer1 = [formatter stringFromNumber:[NSNumber numberWithFloat:[answer floatValue]]];
        NSLog(@"%@", answer1);
        ExchangeRateObject.Rate = [NSNumber numberWithDouble: [answer1 floatValue]];
        NSDate *now = [NSDate date];
        ExchangeRateObject.LastFetched = now;
        NSString *HomeCode = ExchangeRateObject.HomeCurrency.CurrencyAlphaCode;
        NSString *ForeignCode = ExchangeRateObject.ForeignCurrency.CurrencyAlphaCode;
        NSArray *myStrings = [[NSArray alloc] initWithObjects:HomeCode, @"%", ForeignCode, nil];
        NSString *DictionaryKey = [myStrings componentsJoinedByString:@"|"];
        [ExchangeRateDictionary setObject:ExchangeRateObject forKey:DictionaryKey];
        NSArray *FinalOutput = [[NSArray alloc] initWithObjects:@" ",newString," ",ExchangeRateObject.HomeCurrency.CurrencyName," is ",answer1," ",ExchangeRateObject.ForeignCurrency.CurrencyName, nil];
        self.AnswerLabel.text = [FinalOutput componentsJoinedByString:@""];
    }
    else{
        NSString *HomeCode = ExchangeRateObject.HomeCurrency.CurrencyAlphaCode;
        NSString *ForeignCode = ExchangeRateObject.ForeignCurrency.CurrencyAlphaCode;
        NSArray *myStrings = [[NSArray alloc] initWithObjects:HomeCode, @"%", ForeignCode, nil];
        NSString *DictionaryKey = [myStrings componentsJoinedByString:@"|"];
        ExchangeRate *Exrate = nil;
        if([ExchangeRateDictionary objectForKey:DictionaryKey] == nil)
        {
            NSLog(@"#####");
            NSNumber *result = [ExchangeRateObject getForeignRate:[NSNumber numberWithDouble: [newString floatValue]]];
            NSNumber *answer = @([newString floatValue] * [result floatValue]);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setMaximumFractionDigits:[ExchangeRateObject.ForeignCurrency.CurrencyMinor integerValue]];
            [formatter setMinimumFractionDigits:0];
            NSString *answer1 = [formatter stringFromNumber:[NSNumber numberWithFloat:[answer floatValue]]];
            NSLog(@"%@", answer1);
            ExchangeRateObject.Rate = [NSNumber numberWithDouble: [answer1 floatValue]];
            NSDate *now = [NSDate date];
            ExchangeRateObject.LastFetched = now;
            NSString *HomeCode = ExchangeRateObject.HomeCurrency.CurrencyAlphaCode;
            NSString *ForeignCode = ExchangeRateObject.ForeignCurrency.CurrencyAlphaCode;
            NSArray *myStrings = [[NSArray alloc] initWithObjects:HomeCode, @"%", ForeignCode, nil];
            NSString *DictionaryKey = [myStrings componentsJoinedByString:@"|"];
            [ExchangeRateDictionary setObject:ExchangeRateObject forKey:DictionaryKey];
            NSString *FinalOutput = [NSString stringWithFormat:@" %@ %@ is %@ %@", newString, ExchangeRateObject.HomeCurrency.CurrencyName, answer1, ExchangeRateObject.ForeignCurrency.CurrencyName];
            self.AnswerLabel.text = FinalOutput;
           /* NSArray *FinalOutput = [[NSArray alloc] initWithObjects:@" ",newString," ",ExchangeRateObject.HomeCurrency.CurrencyName," is ",answer1," ",ExchangeRateObject.ForeignCurrency.CurrencyName, nil];
            self.AnswerLabel.text = [FinalOutput componentsJoinedByString:@""];*/
        }
        else
        {
            Exrate = [ExchangeRateDictionary objectForKey:DictionaryKey];
            NSDate *date = Exrate.LastFetched;
            NSDate *now = [NSDate date];
            NSTimeInterval secondsBetween = [now timeIntervalSinceDate:date];
            NSInteger time = secondsBetween;
            if(time > 25)
            {
                NSNumber *result = [ExchangeRateObject updateRate];
                NSNumber *answer = @([newString floatValue] * [result floatValue]);
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setMaximumFractionDigits:[ExchangeRateObject.ForeignCurrency.CurrencyMinor integerValue]];
                [formatter setMinimumFractionDigits:0];
                NSString *answer1 = [formatter stringFromNumber:[NSNumber numberWithFloat:[answer floatValue]]];
                ExchangeRateObject.Rate = [NSNumber numberWithDouble: [answer1 floatValue]];
                NSDate *now = [NSDate date];
                ExchangeRateObject.LastFetched = now;
                NSString *HomeCode = ExchangeRateObject.HomeCurrency.CurrencyAlphaCode;
                NSString *ForeignCode = ExchangeRateObject.ForeignCurrency.CurrencyAlphaCode;
                NSArray *myStrings = [[NSArray alloc] initWithObjects:HomeCode, @"%", ForeignCode, nil];
                NSString *DictionaryKey = [myStrings componentsJoinedByString:@"|"];
                [ExchangeRateDictionary setObject:ExchangeRateObject forKey:DictionaryKey];
                NSLog(@"%@", answer1);
                NSString *FinalOutput = [NSString stringWithFormat:@" %@ %@ is %@ %@", newString, ExchangeRateObject.HomeCurrency.CurrencyName, answer1, ExchangeRateObject.ForeignCurrency.CurrencyName];
                self.AnswerLabel.text = FinalOutput;
                /*NSArray *FinalOutput = [[NSArray alloc] initWithObjects:@" ",newString," ",ExchangeRateObject.HomeCurrency.CurrencyName," is ",answer1," ",ExchangeRateObject.ForeignCurrency.CurrencyName, nil];
                self.AnswerLabel.text = [FinalOutput componentsJoinedByString:@""];*/
                
            }
            else{
            NSLog(@"Nikul");
            NSNumber *answer = @([newString floatValue] * [Exrate.Rate floatValue]);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setMaximumFractionDigits:[ExchangeRateObject.ForeignCurrency.CurrencyMinor integerValue]];
            [formatter setMinimumFractionDigits:0];
            NSString *answer1 = [formatter stringFromNumber:[NSNumber numberWithFloat:[answer floatValue]]];
            NSLog(@"%@", answer1);
                NSString *FinalOutput = [NSString stringWithFormat:@" %@ %@ is %@ %@", newString, ExchangeRateObject.HomeCurrency.CurrencyName, answer1, ExchangeRateObject.ForeignCurrency.CurrencyName];
                self.AnswerLabel.text = FinalOutput;
                /*NSArray *FinalOutput = [[NSArray alloc] initWithObjects:@" ",newString," ",ExchangeRateObject.HomeCurrency.CurrencyName," is ",answer1," ",ExchangeRateObject.ForeignCurrency.CurrencyName, nil];
                 self.AnswerLabel.text = [FinalOutput componentsJoinedByString:@""];*/
            }
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        path = [path stringByAppendingPathComponent:@"ExchangeRateDictionary.plist"];
        [NSKeyedArchiver archiveRootObject:ExchangeRateDictionary toFile:path];
    }
    else
    {
        path = [path stringByAppendingPathComponent:@"ExchangeRateDictionary.plist"];
        [NSKeyedArchiver archiveRootObject:ExchangeRateDictionary toFile:path];
    }
    
    NSLog(@"Save Data");
    //


}

- (BOOL)UIApplicationExitsOnSuspend:(UIApplication *)application{
    NSLog(@"Application Ends");
    return YES;
}
- (IBAction)RefreshButton:(id)sender {
    
    NSString *newString = self.CurrencyText.text;
    //[self updateTextLabelsWithText: newString];
    NSLog(@"%@*",newString);
    ExchangeRateObject = [[ExchangeRate alloc]init];
    NSInteger row;
    row = [self.HomePickerView selectedRowInComponent:0];
    NSString *Home = [CurrencyCountry objectAtIndex:row];
    row = [self.ForeignPickerView selectedRowInComponent:0];
    NSString *Foreign = [CurrencyCountry objectAtIndex:row];
    ExchangeRateObject.HomeCurrency = [CurrencyDictionary objectForKey:Home];
    NSLog(@"%@", ExchangeRateObject.HomeCurrency.CurrencyAlphaCode);
    ExchangeRateObject.ForeignCurrency = [CurrencyDictionary objectForKey:Foreign];
    if(ExchangeRateDictionary == nil){
        NSLog(@"###");
        NSNumber *result = [ExchangeRateObject getForeignRate:[NSNumber numberWithDouble: [newString floatValue]]];
        NSNumber *answer = @([newString floatValue] * [result floatValue]);
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:[ExchangeRateObject.ForeignCurrency.CurrencyMinor integerValue]];
        [formatter setMinimumFractionDigits:0];
        NSString *answer1 = [formatter stringFromNumber:[NSNumber numberWithFloat:[answer floatValue]]];
        NSLog(@"%@", answer1);
        ExchangeRateObject.Rate = [NSNumber numberWithDouble: [answer1 floatValue]];
        NSDate *now = [NSDate date];
        ExchangeRateObject.LastFetched = now;
        NSString *HomeCode = ExchangeRateObject.HomeCurrency.CurrencyAlphaCode;
        NSString *ForeignCode = ExchangeRateObject.ForeignCurrency.CurrencyAlphaCode;
        NSArray *myStrings = [[NSArray alloc] initWithObjects:HomeCode, @"%", ForeignCode, nil];
        NSString *DictionaryKey = [myStrings componentsJoinedByString:@"|"];
        [ExchangeRateDictionary setObject:ExchangeRateObject forKey:DictionaryKey];
        NSArray *FinalOutput = [[NSArray alloc] initWithObjects:@" ",newString," ",ExchangeRateObject.HomeCurrency.CurrencyName," is ",answer1," ",ExchangeRateObject.ForeignCurrency.CurrencyName, nil];
        self.AnswerLabel.text = [FinalOutput componentsJoinedByString:@""];
    }
    else{
        NSString *HomeCode = ExchangeRateObject.HomeCurrency.CurrencyAlphaCode;
        NSString *ForeignCode = ExchangeRateObject.ForeignCurrency.CurrencyAlphaCode;
        NSArray *myStrings = [[NSArray alloc] initWithObjects:HomeCode, @"%", ForeignCode, nil];
        NSString *DictionaryKey = [myStrings componentsJoinedByString:@"|"];
        ExchangeRate *Exrate = nil;
        if([ExchangeRateDictionary objectForKey:DictionaryKey] == nil)
        {
            NSLog(@"#####");
            NSNumber *result = [ExchangeRateObject getForeignRate:[NSNumber numberWithDouble: [newString floatValue]]];
            NSNumber *answer = @([newString floatValue] * [result floatValue]);
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setMaximumFractionDigits:[ExchangeRateObject.ForeignCurrency.CurrencyMinor integerValue]];
            [formatter setMinimumFractionDigits:0];
            NSString *answer1 = [formatter stringFromNumber:[NSNumber numberWithFloat:[answer floatValue]]];
            NSLog(@"%@", answer1);
            ExchangeRateObject.Rate = [NSNumber numberWithDouble: [answer1 floatValue]];
            NSDate *now = [NSDate date];
            ExchangeRateObject.LastFetched = now;
            NSString *HomeCode = ExchangeRateObject.HomeCurrency.CurrencyAlphaCode;
            NSString *ForeignCode = ExchangeRateObject.ForeignCurrency.CurrencyAlphaCode;
            NSArray *myStrings = [[NSArray alloc] initWithObjects:HomeCode, @"%", ForeignCode, nil];
            NSString *DictionaryKey = [myStrings componentsJoinedByString:@"|"];
            [ExchangeRateDictionary setObject:ExchangeRateObject forKey:DictionaryKey];
            NSString *FinalOutput = [NSString stringWithFormat:@" %@ %@ is %@ %@", newString, ExchangeRateObject.HomeCurrency.CurrencyName, answer1, ExchangeRateObject.ForeignCurrency.CurrencyName];
            self.AnswerLabel.text = FinalOutput;
            /* NSArray *FinalOutput = [[NSArray alloc] initWithObjects:@" ",newString," ",ExchangeRateObject.HomeCurrency.CurrencyName," is ",answer1," ",ExchangeRateObject.ForeignCurrency.CurrencyName, nil];
             self.AnswerLabel.text = [FinalOutput componentsJoinedByString:@""];*/
        }
        else
        {
            Exrate = [ExchangeRateDictionary objectForKey:DictionaryKey];
            NSDate *date = Exrate.LastFetched;
            NSDate *now = [NSDate date];
            NSTimeInterval secondsBetween = [now timeIntervalSinceDate:date];
            NSInteger time = secondsBetween;
            if(time > 25)
            {
                NSNumber *result = [ExchangeRateObject updateRate];
                NSNumber *answer = @([newString floatValue] * [result floatValue]);
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setMaximumFractionDigits:[ExchangeRateObject.ForeignCurrency.CurrencyMinor integerValue]];
                [formatter setMinimumFractionDigits:0];
                NSString *answer1 = [formatter stringFromNumber:[NSNumber numberWithFloat:[answer floatValue]]];
                ExchangeRateObject.Rate = [NSNumber numberWithDouble: [answer1 floatValue]];
                NSDate *now = [NSDate date];
                ExchangeRateObject.LastFetched = now;
                NSString *HomeCode = ExchangeRateObject.HomeCurrency.CurrencyAlphaCode;
                NSString *ForeignCode = ExchangeRateObject.ForeignCurrency.CurrencyAlphaCode;
                NSArray *myStrings = [[NSArray alloc] initWithObjects:HomeCode, @"%", ForeignCode, nil];
                NSString *DictionaryKey = [myStrings componentsJoinedByString:@"|"];
                [ExchangeRateDictionary setObject:ExchangeRateObject forKey:DictionaryKey];
                NSLog(@"%@", answer1);
                NSString *FinalOutput = [NSString stringWithFormat:@" %@ %@ is %@ %@", newString, ExchangeRateObject.HomeCurrency.CurrencyName, answer1, ExchangeRateObject.ForeignCurrency.CurrencyName];
                self.AnswerLabel.text = FinalOutput;
                /*NSArray *FinalOutput = [[NSArray alloc] initWithObjects:@" ",newString," ",ExchangeRateObject.HomeCurrency.CurrencyName," is ",answer1," ",ExchangeRateObject.ForeignCurrency.CurrencyName, nil];
                 self.AnswerLabel.text = [FinalOutput componentsJoinedByString:@""];*/
                
            }
            else{
                NSLog(@"Nikul");
                NSNumber *answer = @([newString floatValue] * [Exrate.Rate floatValue]);
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setMaximumFractionDigits:[ExchangeRateObject.ForeignCurrency.CurrencyMinor integerValue]];
                [formatter setMinimumFractionDigits:0];
                NSString *answer1 = [formatter stringFromNumber:[NSNumber numberWithFloat:[answer floatValue]]];
                NSLog(@"%@", answer1);
                NSString *FinalOutput = [NSString stringWithFormat:@" %@ %@ is %@ %@", newString, ExchangeRateObject.HomeCurrency.CurrencyName, answer1, ExchangeRateObject.ForeignCurrency.CurrencyName];
                self.AnswerLabel.text = FinalOutput;
                /*NSArray *FinalOutput = [[NSArray alloc] initWithObjects:@" ",newString," ",ExchangeRateObject.HomeCurrency.CurrencyName," is ",answer1," ",ExchangeRateObject.ForeignCurrency.CurrencyName, nil];
                 self.AnswerLabel.text = [FinalOutput componentsJoinedByString:@""];*/
            }
        }
    }
    

    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //check the name of the segue
    if ([[segue identifier] isEqualToString:@"SwipeSecondView"]) {
        
        //get the destination view controller
        FavoriteCurrencyViewController *Controller = [segue destinationViewController];
        
        //integer indicating which cell was clicked
        //we could use this to dymanically pass the data from the clicked cell
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        //pass the data
        //assign the value to a property
        Controller.array = [[NSMutableArray alloc]initWithArray:CurrencyStyle];
        NSLog(@"%@",Controller.array);
    }
}



@end
