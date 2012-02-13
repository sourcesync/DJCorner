//
//  InAppPurchaseManager.m
//  djc
//
//  Created by Zix Engineer on 13/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InAppPurchaseManager.h"

@implementation InAppPurchaseManager

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    //self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    //[super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    //[super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma productrequest
-(void)requestProUpgradeProductData
{
    NSSet *productIdenfitires=[NSSet setWithObject:@"com.zixmedia.djcorner"];
    productsRequest=[[SKProductsRequest alloc] initWithProductIdentifiers:productIdenfitires];
    productsRequest.delegate=self;
    [productsRequest start];
}

#pragma mark--SKProductsRequestDelegate methos

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products=response.products;
    proUpgradeProduct=[products count]==1?[[products objectAtIndex:0] retain]:nil;
    
    if(proUpgradeProduct)
    {
        NSLog(@"Product title:%@",proUpgradeProduct.localizedTitle);
        NSLog(@"Product Description:%@",proUpgradeProduct.localizedDescription);
        NSLog(@"Product price:%@",proUpgradeProduct.price);
        NSLog(@"Product id:%@",proUpgradeProduct.productIdentifier);
    }
    
    for(NSString *invalidProductId in response.invalidProductIdentifiers)
    {
        NSLog(@"Invalid product id:%@",invalidProductId);
    }
    
    [productsRequest release];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

@end
