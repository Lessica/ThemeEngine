//
//  TKLayoutInformation.m
//  ThemeKit
//
//  Created by Alexander Zielenski on 6/19/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import "TKLayoutInformation.h"
#import "TKLayoutInformation+Private.h"
#import "TKStructs.h"

@implementation TKLayoutInformation

+ (instancetype)layoutInformationWithCSIData:(NSData *)csiData {
    return [[self alloc] initWithCSIData:csiData];
}

- (instancetype)initWithCSIData:(NSData *)csiData {
    if ((self = [self init])) {
        unsigned infoLength = 0;
        [csiData getBytes:&infoLength range:NSMakeRange(offsetof(struct csiheader, infolistLength), sizeof(infoLength))];
        
        
        // Parse CSI data for slice information
        unsigned sliceMagic = CSIInfoMagicSlices;
        NSRange sliceMagicLocation = [csiData rangeOfData:[NSData dataWithBytes:&sliceMagic
                                                                         length:sizeof(sliceMagic)]
                                                  options:0
                                                    range:NSMakeRange(sizeof(struct csiheader), infoLength)];
        
        if (sliceMagicLocation.location != NSNotFound) {
            unsigned int nslices = 0;
            [csiData getBytes:&nslices range:NSMakeRange(sliceMagicLocation.location + sizeof(unsigned int) * 2, sizeof(nslices))];
            
            NSMutableArray *slices = [NSMutableArray arrayWithCapacity:nslices];
            for (int idx = 0; idx < nslices; idx++) {
                struct {
                    unsigned int x;
                    unsigned int y;
                    unsigned int w;
                    unsigned int h;
                } sliceInts;
                
                [csiData getBytes:&sliceInts range:NSMakeRange(sliceMagicLocation.location + sizeof(sliceInts) * idx + sizeof(unsigned int) * 3,
                                                               sizeof(sliceInts))];
                [slices addObject:[NSValue valueWithRect:NSMakeRect(sliceInts.x, sliceInts.y, sliceInts.w, sliceInts.h)]];
            }
            
            self.sliceRects = slices;
        }
        
        
        // Get metric information
        
        
    }
    
    return self;
}

- (instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if ((self = [self init])) {
        [self setValue:[coder decodeObjectForKey:TKKey(imageSize)] forKey:TKKey(imageSize)];
        [self setValue:[coder decodeObjectForKey:TKKey(sliceRects)] forKey:TKKey(sliceRects)];
        [self setValue:[coder decodeObjectForKey:TKKey(edgeInsets)] forKey:TKKey(edgeInsets)];
    }
    
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:[NSValue valueWithSize:self.imageSize] forKey:TKKey(imageSize)];
    [coder encodeObject:self.sliceRects forKey:TKKey(sliceRects)];
    [coder encodeObject:[NSValue valueWithEdgeInsets:self.edgeInsets] forKey:TKKey(edgeInsets)];
}

@end
