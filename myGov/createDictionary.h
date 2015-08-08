//
//  createDictionary.h
//  myGov
//
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface createDictionary : NSObject

-(NSMutableDictionary*)makeDictionary:(NSString*)name party:(NSString*)party hometown:(NSString*)hometown birthday:(NSString*)birthday tookOffice: (NSString*)tookOffice website: (NSString*)website twitter: (NSString*)twitter facebook: (NSString*)facebook bioguidePhoto: (NSString*) bioguide contactForm: (NSString*) contactForm;

@end
