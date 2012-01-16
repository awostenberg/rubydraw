//
//  main.m
//  RubydrawWrapper
//
//  Created by Alan Wostenberg on 1/16/12.
//  Copyright Wosterware.com 2012. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
	// Find the path to this application
	NSString *bund = [[NSBundle mainBundle] bundlePath];
	// Figure out the Ruby file path and convert that string to a char array
	char *rb_main = [[bund stringByAppendingString:@"/Contents/Resources/main.rb"] UTF8String];
	// Initialize the Ruby interpreter
	ruby_init();
	// Load the file
	rb_load_file(rb_main);
	// Run the file
	return ruby_run();
}