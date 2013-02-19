BSEligibleKit
=============

An intuitive and concise library for inserting Eligible data into your iOS project.

``` objective-c
[BSEligibleKit getDataFor:@"service/all" withParams:formData success:^(NSDictionary *data) {
  //Do things!
  label.text = [data objectForKey:@"coverage_status"];
} 
failure:^(NSError *error) {
  label.text = [error localizedDescription];
}];
```

Getting Started
=============

If you haven't already: sign up for an account at [EligibleApi.com](https://eligibleapi.com/users/sign_up)

Clone the project into your app directory: (use --recursive to include dependencies)

``` terminal
git clone --recursive git@github.com:briansoule/BSEligibleKit.git
```

Then drag the BSEligibleKit folder into your XCode project.


in your AppDelegate.m file add:
``` objective-c
#import "BSEligibleKit.h"
```
Get your [API_KEY](https://eligibleapi.com/profile/information), and have it ready for the next step:

Add the following into your didFinishLaunchingWithOptions method like so:
``` objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [BSEligibleKit getEligible:YOUR_ELIGIBLE_API_KEY_HERE];
    return YES;
}
```
Put your query data into a dictionary:

``` objective-c
NSMutableDictionary *formData = [[NSMutableDictionary alloc] init];
[formData setObject:self.payerName.text forKey:@"payer_name"];
[formData setObject:self.payerId.text forKey:@"payer_id"];
[formData setObject:self.serviceProviderFirstName.text forKey:@"service_provider_first_name"];
[formData setObject:self.serviceProviderLastName.text forKey:@"service_provider_last_name"];
[formData setObject:self.serviceProviderNPI.text forKey:@"service_provider_npi"];
[formData setObject:self.subscriberID.text forKey:@"subscriber_id"];
[formData setObject:self.subscriberFirstName.text forKey:@"subscriber_first_name"];
[formData setObject:self.subscriberLastName.text forKey:@"subscriber_last_name"];
[formData setObject:self.subscriberDOB.text forKey:@"subscriber_dob"];
[formData setObject:@"42" forKey:@"service_type_code"];
```

Now find your query (like `service/all` in the [Eligible Docs](https://eligibleapi.com/rest-api-v1) and insert it after `getDataFor:` in the following code:

``` objective-c
[BSEligibleKit getDataFor:@"service/all" withParams:formData success:^(NSDictionary *data) {
  if (![data objectForKey:@"error"]) {
      //Your data is available here
      self.label.text = [recentCheck objectForKey:@"coverage_status"];
      //You did it, you're now getting eligiblity data on iOS!
	}
	else {
      //Tell the user to check their data
  	  self.notificationLabel.text = [[data objectForKey:@"error"] objectForKey:@"follow-up_action_description"];		
	}
}
failure:^(NSError *error) {
  self.label.text = [error localizedDescription];
}];
```
Congratulations! you are now receiving eligiblity data on iOS.

---
Your eligibility data is rendered into an NSDictionary that you can use in your app:
``` objective-c
self.label.text = [recentCheck objectForKey:@"coverage_status"];
```

There's even a convenience singleton array that you can use to access your recent queries:
``` objective-c
NSDictionary *recentCheck = [[BSEligibleKit sharedInstance].previousQueries objectAtIndex:0];
```
