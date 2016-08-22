//
//  ExchangeRate.m
//  CurrencyConverter
//
//  Created by NIKUL CHAUHAN on 3/6/16.
//  Copyright © 2016 NIKUL CHAUHAN. All rights reserved.
//  Contact No: 714-213-5652
//  Email ID: nikulchauhan@csu.fullerton.edu
/*
 Description:
        This is the file where actual query is generated and using Yahoo api the current exchange rate is fetched.
 */

#import "ExchangeRate.h"

@implementation ExchangeRate

-(NSNumber *) updateRate{
    NSLog(@"Update Called");
    NSLog(@"%@-%@", _HomeCurrency.CurrencyAlphaCode, _ForeignCurrency.CurrencyAlphaCode);
    NSString *request = [NSString stringWithFormat:@"select * from yahoo.finance.xchange where pair in ('%@%@')",self.HomeCurrency.CurrencyAlphaCode,self.ForeignCurrency.CurrencyAlphaCode];
    NSString *tail =@"&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=";
    NSString *escapedString = [request stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *finalURL = [NSString stringWithFormat:@"https://query.yahooapis.com/v1/public/yql?q=%@%@",escapedString,tail];
    NSLog(@"%@",finalURL);
    NSURL *restquery =[NSURL URLWithString:finalURL];
    
    NSURLRequest *getjson = [NSURLRequest requestWithURL:restquery];
    NSURLResponse *res = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:getjson returningResponse:&res error:&err];
    id object = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:0
                 error:nil];
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
        self.Rate=[[[[results objectForKey:@"query" ]  objectForKey:@"results"] objectForKey:@"rate"] objectForKey:@"Rate"];
    }
    //NSLog(@"%f", [self.Rate floatValue]);
    return self.Rate;
}

-(NSNumber*) getForeignRate: (NSNumber *) Foreign{

    NSLog(@"getForeignRatecalled");
    // NSDate *current = [NSDate date];
    //int days = [current timeIntervalSinceDate:self.creationDate];
    // if(days > self.daysToLive)
    //{
    NSLog(@"%@-%@", _HomeCurrency.CurrencyAlphaCode, _ForeignCurrency.CurrencyAlphaCode);
    NSString *request = [NSString stringWithFormat:@"select * from yahoo.finance.xchange where pair in ('%@%@')",self.HomeCurrency.CurrencyAlphaCode,self.ForeignCurrency.CurrencyAlphaCode];
    NSString *tail =@"&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=";
    NSString *escapedString = [request stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *finalURL = [NSString stringWithFormat:@"https://query.yahooapis.com/v1/public/yql?q=%@%@",escapedString,tail];
    NSLog(@"%@",finalURL);
    NSURL *restquery =[NSURL URLWithString:finalURL];
    
    NSURLRequest *getjson = [NSURLRequest requestWithURL:restquery];
    NSURLResponse *res = nil;
    NSError *err = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:getjson returningResponse:&res error:&err];
    id object = [NSJSONSerialization
                 JSONObjectWithData:data
                 options:0
                 error:nil];
    if([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *results = object;
        self.Rate=[[[[results objectForKey:@"query" ]  objectForKey:@"results"] objectForKey:@"rate"] objectForKey:@"Rate"];
    }
    //NSLog(@"%f", [self.Rate floatValue]);
    return self.Rate;
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"bad response came");
    
}


-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"%-----lu",[data length]);
}



- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"something very bad happened here");
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_HomeCurrency forKey:@"HomeCurrency"];
    [coder encodeObject:_ForeignCurrency  forKey:@"ForeignCurrency"];
    [coder encodeObject:_Rate forKey:@"Rate"];
    [coder encodeObject:_LastFetched forKey:@"LastFetched"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if(self)
    {
        self.HomeCurrency = [coder decodeObjectForKey:@"homeCurrency"];
        self.ForeignCurrency  = [coder decodeObjectForKey:@"foreignCurrency"];
        self.Rate = [coder decodeObjectForKey:@"exchangeRate"];
        self.LastFetched = [coder decodeObjectForKey:@"LastFetched"];
    }
    return self;
}


@end
