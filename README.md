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

An intuitive and concise library for inserting Eligible data into your iOS project.
