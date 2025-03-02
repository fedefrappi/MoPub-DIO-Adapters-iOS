//
//  BrandioInterstitialMopubAdapter.m
//  MopubAdapterForiOS
//
//  Created by rdorofeev on 7/12/19.
//  Copyright © 2019 rdorofeev. All rights reserved.
//

#import "DIOMopubInterstitialAdapter.h"
#import <DIOSDK/DIOController.h>


@interface DIOMopubInterstitialAdapter ()

@property (nonatomic, strong) DIOAd *dioAd;

@end

@implementation DIOMopubInterstitialAdapter

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info{
    
        NSString *appId = [info objectForKey:@"appid"];
        NSString *placementId = [info objectForKey:@"placementid"];
    
    if (![DIOController sharedInstance].initialized) {
        NSLog(@"Error: DIOController not initialized!");
        NSError *error = [NSError errorWithDomain:@"https://appsrv.display.io/srv"
                                             code:100
                                         userInfo:@{NSLocalizedDescriptionKey:@"DIOController not initialized!"}];
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError: error];
    }else {
        [self loadDioInterstitial:placementId];
    }
}

- (void)loadDioInterstitial:(NSString *)placementId{
    DIOPlacement *placement = [[DIOController sharedInstance] placementWithId:placementId];
    DIOAdRequest *request = [placement newAdRequest];
    
    [request requestAdWithAdReceivedHandler:^(DIOAdProvider *adProvider) {
        [adProvider loadAdWithLoadedHandler:^(DIOAd *ad) {
            self.dioAd = ad;
            [self.delegate interstitialCustomEvent:self didLoadAd:ad];
        } failedHandler:^(NSString *message){
            NSError *error = [NSError errorWithDomain:@"https://appsrv.display.io/srv"
                                                 code:100
                                             userInfo:@{NSLocalizedDescriptionKey:message}];
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError: error];
            NSLog(message);
        }];
    } noAdHandler:^{
        NSLog(@"No ad provider");
    }];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController{
    if (self.dioAd != nil) {
        [self.dioAd showAdFromViewController:rootViewController eventHandler:^(DIOAdEvent event){
            switch (event) {
                case DIOAdEventOnShown:
                    [self.delegate trackImpression];
                    [self.delegate interstitialCustomEventWillAppear: self];
                    [self.delegate interstitialCustomEventDidAppear: self];
                    NSLog(@"AdEventOnShown");
                    break;
                    
                case DIOAdEventOnClicked:
                    NSLog(@"AdEventOnClicked");
                    break;
                    
                case DIOAdEventOnFailedToShow:
                    NSLog(@"AdEventOnFailedToShow");
                    self.dioAd = nil;
                    break;
                    
                case DIOAdEventOnClosed:
                    [self.delegate interstitialCustomEventWillDisappear: self];
                    [self.delegate interstitialCustomEventDidDisappear: self];
                    NSLog(@"AdEventOnClosed");
                    self.dioAd = nil;
                    break;
                    
                case DIOAdEventOnAdCompleted:
                    NSLog(@"AdEventOnAdCompleted");
                    self.dioAd = nil;
                    break;
            }
        }];
    }
}

@end
