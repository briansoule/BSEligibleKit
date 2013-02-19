//
//  BSEligibleKit.m
//  WaitingRoom3
//
//  Created by Brian Soule on 1/26/13.
//  Copyright (c) 2013 Soule Mobile. All rights reserved.
//

#import "BSEligibleKit.h"
#import "AFHTTPRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFHTTPClient.h"

@implementation BSEligibleKit

+ (BSEligibleKit *)sharedInstance
{
    static BSEligibleKit *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BSEligibleKit alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (id) init
{
    if (self = [super init])
    {
		self.previousQueries = [[NSMutableArray alloc] init];
		[self getInformationSources];
        NSLog(@"EligibleKit initialized");
    }
    return self;
}

+ (id) getEligible:(NSString *)apiKey
{
        [BSEligibleKit sharedInstance].apiKey = apiKey;
		[BSEligibleKit sharedInstance].previousQueries = [[NSMutableArray alloc] init];
        NSLog(@"EligibleKit initialized with api key:%@", apiKey);
    return self;
}

+ (void) getDataFor:(NSString *)resource
				   withParams:(NSMutableDictionary *)params
				   success:(void (^)(NSDictionary *data))success
				   failure:(void (^)(NSError *error))failure
{
	resource = [NSString stringWithFormat:@"/%@.json", resource];
	[params setObject:[BSEligibleKit sharedInstance].apiKey forKey:@"api_key"];
	
	NSURL *nurl = [NSURL URLWithString:[@"https://v1.eligibleapi.net" stringByAppendingString: resource]];
	AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:nurl];

	[httpClient getPath:resource parameters:params success:^(AFHTTPRequestOperation *operation, id responseData) {
		
		NSError* error;
		NSDictionary* data = [NSJSONSerialization
							  JSONObjectWithData:responseData
							  
							  options:kNilOptions
							  error:&error];
		
		NSLog(@"Success Result String: %@", data);
		if ([data objectForKey:@"error"]) {
			
			//TODO: SPECIFY AN ERROR DESPITE JSON
			if (success) {
				success(data);
			}
			
			NSLog(@"Error: %@,\n Please: %@",[[data objectForKey:@"error"] objectForKey:@"reject_reason_description"],
			[[data objectForKey:@"error"] objectForKey:@"follow-up_action_description"]);
			
		}
		else {
			if (success) {
				[[BSEligibleKit sharedInstance].previousQueries addObject:data];
				success(data);
			}
		}
			//NSLog(@"Primary Insurance: %@", [[JSON valueForKeyPath:@"primary_insurance"] valueForKeyPath:@"name"]);
			
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		
			NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
			
			if (failure) {
				failure(error);
			}
			
	
	}];
}

- (void) getInformationSources {
	NSString *fname = [[NSBundle mainBundle] pathForResource:@"information-sources" ofType:@"json"];
	NSData *d = [NSData dataWithContentsOfFile:fname];
	
	NSArray *jsonObjects = [NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers error:nil];
	
	self.informationSourcesJSON = jsonObjects;
}

@end
