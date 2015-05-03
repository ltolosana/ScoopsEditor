//
//  LMTImage.m
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 3/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

#import "LMTImage.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AzureKeys.h"

@implementation LMTImage

+(instancetype) imageWithPhotoString:(NSString *) photoString{
    
    return [[self alloc] initWithPhotoString:photoString];
}

-(id) initWithPhotoString:(NSString *) photoString{

        MSClient *client = [MSClient clientWithApplicationURL:[NSURL URLWithString:AZUREMOBILESERVICE_ENDPOINT]
                                     applicationKey:AZUREMOBILESERVICE_APPKEY];
    
    //Obtenemos la sasurl
    [client invokeAPI:@"getsasurl"
                      body:nil
                HTTPMethod:@"GET"
                parameters:@{@"blobName":photoString}
                   headers:nil
                completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                    
                    if (!error) {
                        
                        
                        NSLog(@"%@", result);
                        NSURL *sasURL = [NSURL URLWithString:result[@"sasUrl"]];
                        
                        [self handleSaSURLToDownload:sasURL completionHandleSaS:^(id result, NSError *error) {
                            
                                          if (!error) {
                                              NSLog(@"%@", result);
                                          }
                                      }];
                        
                    }
                }];

    return self;
    
}

- (void)handleSaSURLToDownload:(NSURL *)theUrl completionHandleSaS:(void (^)(id result, NSError *error))completion{
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:theUrl];
    
    [request setHTTPMethod:@"GET"];
    [request setValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDownloadTask * downloadTask = [[NSURLSession sharedSession]downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSLog(@"resultado --> %@", response);
            self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
            completion(self.image, error);
        }
        
    }];
    [downloadTask resume];
    
}


@end
