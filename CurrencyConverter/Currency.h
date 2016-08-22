//
//  Currency.h
//  CurrencyConverter
//
//  Created by NIKUL CHAUHAN on 3/5/16.
//  Copyright © 2016 NIKUL CHAUHAN. All rights reserved.
//  Contact No: 714-213-5652
//  Email ID: nikulchauhan@csu.fullerton.edu
/*
 Description:
        This is the file which declares the currency Object includes country name, country currency, alpha code, numeric code, minor.
 */

#import <Foundation/Foundation.h>

@interface Currency : NSObject

@property (strong) NSString *CurrencyCountry;
@property (strong) NSString *CurrencyName;
@property (strong) NSString *CurrencyAlphaCode;
@property (strong) NSNumber *CurrencyNumericCode;
@property (strong) NSNumber *CurrencyMinor;

@end
