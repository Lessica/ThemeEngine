//
//  TERenditionsController.h
//  ThemeEngine
//
//  Created by Alexander Zielenski on 6/14/15.
//  Copyright © 2015 Alex Zielenski. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "TEInspectorController.h"

@interface TERenditionsController : NSViewController
@property (weak) IBOutlet NSArrayController *renditionsArrayController;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (weak) IBOutlet IKImageBrowserView *renditionBrowser;
#pragma clang diagnostic pop

@property (weak) IBOutlet NSSlider *zoomSlider;
@property (weak) IBOutlet TEInspectorController *inspectorController;
@property (nonatomic, assign) NSInteger currentGroup;

- (IBAction)zoomAnchorPressed:(NSButton *)sender;
- (IBAction)searchRenditions:(NSSearchField *)sender;

- (IBAction)receiveFromEditor:(id)sender;
- (IBAction)sendToEditor:(id)sender;

- (IBAction)addRendition:(id)sender;
- (IBAction)removeSelection:(id)sender;
- (IBAction)makeMicaPinkAgain:(id)sender;

@end
