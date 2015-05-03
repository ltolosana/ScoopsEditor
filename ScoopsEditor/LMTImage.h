//
//  LMTImage.h
//  ScoopsEditor
//
//  Created by Luis M Tolosana Simon on 3/5/15.
//  Copyright (c) 2015 Luis M Tolosana Simon. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface LMTImage : NSObject

@property (nonatomic, strong) UIImage *image;

+(instancetype) imageWithPhotoString:(NSString *) photoString;

-(id) initWithPhotoString:(NSString *) photoString;

@end
