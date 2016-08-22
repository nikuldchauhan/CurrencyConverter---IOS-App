//
//  Currency.m
//  CurrencyConverter
//
//  Created by NIKUL CHAUHAN on 3/5/16.
//  Copyright © 2016 NIKUL CHAUHAN. All rights reserved.
//  Contact No: 714-213-5652
//  Email ID: nikulchauhan@csu.fullerton.edu
/*
 Description:
        This the file where NSCoding and NSDecoding is implemented for encoding and decoding object.
 */

#import "Currency.h"

@implementation Currency

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_CurrencyCountry   forKey:@"CurrencyCountry"];
    [aCoder encodeObject:_CurrencyName         forKey:@"CurrencyName"];
    [aCoder encodeObject:_CurrencyAlphaCode       forKey:@"CurrencyAlphaCode"];
    [aCoder encodeObject:_CurrencyNumericCode      forKey:@"CurrencyNumericCode"];
    [aCoder encodeObject:_CurrencyMinor       forKey:@"CurrencyMinor"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self.CurrencyCountry = [aDecoder decodeObjectForKey:@"CurrencyCountry"];
    self.CurrencyName = [aDecoder decodeObjectForKey:@"CurrencyName"];
    self.CurrencyAlphaCode = [aDecoder decodeObjectForKey:@"CurrencyAlphaCode"];
    self.CurrencyNumericCode = [aDecoder decodeObjectForKey:@"CurrencyNumericCode"];
    self.CurrencyMinor = [aDecoder decodeObjectForKey:@"CurrencyMinor"];
    return self;
}

@end
