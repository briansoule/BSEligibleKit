//
//  BSEligibleKit.h
//  WaitingRoom3
//
//  Created by Brian Soule on 1/26/13.
//  Copyright (c) 2013 Soule Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSEligibleKit : NSObject

+ (BSEligibleKit *)sharedInstance;

@property (strong) NSString *apiKey;
@property (strong) NSMutableArray *previousQueries;
@property (nonatomic) NSArray *informationSourcesJSON;

+ (id) getEligible:(NSString *)apiKey;

+ (void) getDataFor:(NSString *)resource
                withParams:(NSDictionary *)params
                success:(void (^)(NSDictionary *data))success
                failure:(void (^)(NSError *error))failure;

@end