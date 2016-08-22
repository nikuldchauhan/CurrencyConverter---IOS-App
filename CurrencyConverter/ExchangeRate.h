//
//  ExchangeRate.h
//  CurrencyConverter
//
//  Created by NIKUL CHAUHAN on 3/6/16.
//  Copyright © 2016 NIKUL CHAUHAN. All rights reserved.
//  Contact No: 714-213-5652
//  Email ID: nikulchauhan@csu.fullerton.edu
/*
 Description:
        This the file where homecurrency and foreigncurrency is declared and rate and lastfetched time is declared.
 */

#import <Foundation/Foundation.h>
#import "Currency.h"

@interface ExchangeRate : NSObject

@property (strong) Currency *HomeCurrency;
@property (strong) Currency *ForeignCurrency;
@property (strong) NSNumber *Rate;
@property (strong) NSDate *LastFetched;

-(NSNumber *) updateRate;
-(NSNumber*) getForeignRate: (NSNumber *) Foriegn;

@end
