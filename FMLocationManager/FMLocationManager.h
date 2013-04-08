//
//  FMLocationManager.h
//
//  Created by Maurizio Cremaschi on 13/11/2012.
//  Copyright 2013 Flubber Media Ltd.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface FMLocationManager : NSObject <CLLocationManagerDelegate>

+ (FMLocationManager *)sharedInstance;

+ (BOOL)isAuthorized;
- (void)startUpdatingLocation:(void (^)(CLLocation *location))update fail:(void (^)(NSError *error))fail;
- (void)stopUpdatingLocation;

@end
