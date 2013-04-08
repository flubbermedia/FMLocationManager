//
//  FMLocationManager.m
//  State
//
//  Created by Maurizio Cremaschi on 13/11/2012.
//  Copyright 2013 Flubber Media Ltd.
//

#import "FMLocationManager.h"

@interface FMLocationManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (copy, nonatomic) void (^updateBlock)(CLLocation *location);
@property (copy, nonatomic) void (^failBlock)(NSError *error);

@end

@implementation FMLocationManager

+ (FMLocationManager *)sharedInstance
{
    static FMLocationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FMLocationManager new];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return self;
}

#pragma mark - Public methods

+ (BOOL)isAuthorized
{
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized);
}

- (void)startUpdatingLocation:(void (^)(CLLocation *location))update fail:(void (^)(NSError *error))fail
{
    [_locationManager stopUpdatingLocation];
    
    _updateBlock = update;
    _failBlock = fail;
    
    [_locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    
    if (_updateBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _updateBlock(_locationManager.location);
        });
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    
    if (_failBlock)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _failBlock(error);
        });
    }
}

@end
