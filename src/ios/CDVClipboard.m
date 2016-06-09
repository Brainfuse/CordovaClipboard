#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import "CDVClipboard.h"

@implementation CDVClipboard

- (void)copy:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		NSString     *text       = [command.arguments objectAtIndex:0];

		[pasteboard setValue:text forPasteboardType:@"public.text"];

		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)paste:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{

        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];

        NSString *data = @"";
        NSData *imageData;
        NSArray *types = @[@"public.text",@"public.jpeg",@"public.png"];
        
        if([[pasteboard pasteboardTypes] containsObject:types[0]]){
            
             data = [pasteboard valueForPasteboardType:types[0]];
            
        }else if([[pasteboard pasteboardTypes] containsObject:types[1]]){
            
            imageData = [pasteboard dataForPasteboardType:types[1]];
            
        }else if([[pasteboard pasteboardTypes] containsObject: types[2]]){
            
            imageData = [pasteboard dataForPasteboardType:types[2]];
        }
        
        if(imageData != nil){
            data =  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.jpg"];
            [imageData writeToFile:data atomically:YES];
        }
      	    
	    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:data];
	    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

@end
