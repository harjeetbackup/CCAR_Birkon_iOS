//
//  CardList.m
//  SchlossExtra
//
//  Created by Chandan Kumar on 16/08/11.
//  Copyright 2011 Interglobe Technologies. All rights reserved.
//

#import "CardList_iPhone.h"
#import "CardDetails_iPhone.h"
#import "FlashCard.h"
#import "DBAccess.h"
#import "StringHelper.h"
#import "RCLabel.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@implementation CardListIPhone
{
    UILabel *lblDeckName ;
    FlashCardDeck* objFlashCardDeck;
     NSString* backgroundImageName;
}
@synthesize arrCards;
@synthesize tblCardNames;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization.
 }
 return self;
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tblCardNames.backgroundColor=[UIColor clearColor];
    self.backgroundImage.image=[UIImage imageNamed:backgroundImageName];
   // UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
   // view.backgroundColor = [UIColor whiteColor];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    if ([arrCards count]==0) {
		[self popView];
	}
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([lblDeckName.text  isEqual: kBookMarkScreenTitle]) {
        [self showBookmarkCards];
    }
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void) showCardsForDeck:(int) iDeckId
{
    if(iDeckId>0 && iDeckId<8)
    {
        backgroundImageName=@"yellow-menu-background_iPhone.jpg";
    }
    else if(iDeckId>8 && iDeckId<12)
    {
        backgroundImageName=@"green-menu-background_iPhone.jpg";
    }
    else if(iDeckId>12 && iDeckId<16)
    {
        backgroundImageName=@"red-menu-background_iPhone.jpg";
        
    }
    else if(iDeckId>16 && iDeckId<20)
    {
        backgroundImageName=@"blue-menu-background_iPhone.jpg";
    }
    else
        backgroundImageName=@"left_bg_320x680.png";
   
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	objFlashCardDeck = [db getFlashCardDeckByDeckId:iDeckId];
	lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	lblDeckName.font = [UIFont systemFontOfSize:12];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        lblDeckName.textColor = [UIColor whiteColor];
    }
    else
    {
        lblDeckName.textColor = [UIColor colorWithRed:54.0/255 green:95.0/255 blue:145.0/255 alpha:1];
        [lblDeckName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:14]];
    }
    NSString* title = [[objFlashCardDeck.deckTitle stringByReplacingOccurrencesOfString:@"<i>" withString:@""] stringByReplacingOccurrencesOfString:@"</i>" withString:@""];
	lblDeckName.text = [self stringByDecodingHTMLEntitiesInString:title];
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
        
    }
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationItem.leftBarButtonItem=leftButton;
    }
	
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeAlfabaticallly withId:iDeckId] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
	
}
- (void) showAllCards
{
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
	
	lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	lblDeckName.font = [UIFont systemFontOfSize:18];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        lblDeckName.textColor = [UIColor whiteColor];
    }
    else
    {
        lblDeckName.textColor = [UIColor blackColor];
    }
    
	lblDeckName.text = @"All Blessings";
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
    }
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationItem.leftBarButtonItem=leftButton;
    }
    
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeAll withId:0] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
	
}

- (void) showAllSongs
{
    DBAccess* db=[AppDelegate_iPhone getDBAccess];
    
    lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
    [lblDeckName setTextAlignment:UITextAlignmentCenter];
    [lblDeckName setBackgroundColor:[UIColor clearColor]];
    [lblDeckName setTextColor:[UIColor whiteColor]];
    lblDeckName.font = [UIFont systemFontOfSize:18];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        lblDeckName.textColor = [UIColor whiteColor];
    }
    else
    {
        lblDeckName.textColor = [UIColor blackColor];
    }
    
    lblDeckName.text = @"All Songs";
    self.navigationItem.titleView = lblDeckName;
    [lblDeckName release];
    
    UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
    }
    [leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationItem.leftBarButtonItem=leftButton;
    }
    
    //self.navigationItem.title = objFlashCardDeck.deckTitle;
    arrCards = [[db getCardListForDeckType:kCardDeckTypeAllSongs withId:0] retain];
    if([AppDelegate_iPhone delegate].isRandomCard == 1)
    {
        [Utils randomizeArray:arrCards];
    }
    
}

- (void) showBookmarkCards
{
	DBAccess* db=[AppDelegate_iPhone getDBAccess];
    
	lblDeckName = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 200, 30)];
	[lblDeckName setTextAlignment:UITextAlignmentCenter];
	[lblDeckName setBackgroundColor:[UIColor clearColor]];
	[lblDeckName setTextColor:[UIColor whiteColor]];
	lblDeckName.font = [UIFont systemFontOfSize:18];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        
        lblDeckName.textColor = [UIColor whiteColor];
    }
    else
    {
        lblDeckName.textColor = [UIColor blackColor];
    }
    
	lblDeckName.text = kBookMarkScreenTitle;
	self.navigationItem.titleView = lblDeckName;
	[lblDeckName release];
	
	UIButton *leftButtonImg = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 50, 30)];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        [leftButtonImg setImage:[UIImage imageNamed:@"back_btn_iPhone.png"] forState:UIControlStateNormal];
    }
	[leftButtonImg addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* leftButton = [[[UIBarButtonItem alloc] initWithCustomView:leftButtonImg] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        self.navigationItem.leftBarButtonItem=leftButton;
    }
	
	//self.navigationItem.title = objFlashCardDeck.deckTitle;
	arrCards = [[db getCardListForDeckType:kCardDeckTypeBookMark withId:0] retain];
	if([AppDelegate_iPhone delegate].isRandomCard == 1)
	{
		[Utils randomizeArray:arrCards];
	}
    [self.tblCardNames reloadData];
}

- (void)popView{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	// Return the number of rows in the section.
    if ([arrCards count]==0) {
		return 1;
	}
	
	return [arrCards count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
      //  cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kCardListColor]];
        UIView *bgColorView = [[UIView alloc] init];
        [bgColorView setBackgroundColor:[Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]]];
        [cell setSelectedBackgroundView:bgColorView];
        [bgColorView release];
	}
    
	FlashCard* card=(FlashCard*)[arrCards objectAtIndex:indexPath.row];
    	NSString *cellValue = [card cardName];
    
	//cell.textLabel.text = cellValue;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
        UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
        
        [cell setAccessoryView:imageView];
    }
    else
    {
        UIImage* myImage=[UIImage imageNamed:@"arrow.png"];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];

        [cell setAccessoryView:imageView];
       // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    NSString* newStr=[self stringByDecodingHTMLEntitiesInString:cellValue];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 25)];
    newStr = [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // NSString* newStr=[self stringByDecodingHTMLEntitiesInString:str];
    label = [newStr Answer_newSizedCellLabelWithSystemFontOfSize:14];
       label.frame=CGRectMake(cell.contentView.frame.origin.x+15,cell.contentView.frame.origin.y + 10,cell.contentView.frame.size.width-15,cell.contentView.frame.size.height+10);
    if ([cell.contentView subviews]){
        for (UIView *subview in [cell.contentView subviews]) {
            [subview removeFromSuperview];
        }
    }
    [cell.contentView addSubview:label];
    cell.backgroundColor=card.cardColor;
    // cell.textLabel.text = cellValue;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cellValue=nil;
   // int a = arrCards.count;
    
   
    return cell;
}
- (CGFloat) tableView: (UITableView *) tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
	CGSize labelSize = CGSizeMake(272.0f, 20.0);
	FlashCard* card=(FlashCard*)[arrCards objectAtIndex:indexPath.row];
	
	NSString * strCardName = [card cardName];
	if ([strCardName length] > 0)
		labelSize = [strCardName sizeWithFont: [UIFont systemFontOfSize: 16.0] constrainedToSize: CGSizeMake(labelSize.width, 1000) lineBreakMode: UILineBreakModeWordWrap];
	//return 24.0 + labelSize.height;
    return 50.0;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([arrCards count]==0) {
		return;
	}
	
	CardDetails_iPhone* detail = [[CardDetails_iPhone alloc] initWithNibName:@"CardDetails_iPhone" bundle:nil];
     detail.arrCards=arrCards;
    detail._selectedCardIndex=indexPath.row;
	[self.navigationController pushViewController:detail animated:YES];
	
	//detail._selectedCardIndex=indexPath.row;
   
	//[detail loadArrayOfCards:arrCards];
	[detail release];
}

- (NSString *)stringByDecodingHTMLEntitiesInString:(NSString *)input {
    NSMutableString *results = [NSMutableString string];
    NSScanner *scanner = [NSScanner scannerWithString:input];
    [scanner setCharactersToBeSkipped:nil];
    while (![scanner isAtEnd]) {
        NSString *temp;
        if ([scanner scanUpToString:@"&" intoString:&temp]) {
            [results appendString:temp];
        }
        if ([scanner scanString:@"&" intoString:NULL]) {
            BOOL valid = YES;
            unsigned c = 0;
            NSUInteger savedLocation = [scanner scanLocation];
            if ([scanner scanString:@"#" intoString:NULL]) {
                // it's a numeric entity
                if ([scanner scanString:@"x" intoString:NULL]) {
                    // hexadecimal
                    unsigned int value;
                    if ([scanner scanHexInt:&value]) {
                        c = value;
                    } else {
                        valid = NO;
                    }
                } else {
                    // decimal
                    int value;
                    if ([scanner scanInt:&value] && value >= 0) {
                        c = value;
                    } else {
                        valid = NO;
                    }
                }
                if (![scanner scanString:@";" intoString:NULL]) {
                    // not ;-terminated, bail out and emit the whole entity
                    valid = NO;
                }
            } else {
                if (![scanner scanUpToString:@";" intoString:&temp]) {
                    // &; is not a valid entity
                    valid = NO;
                } else if (![scanner scanString:@";" intoString:NULL]) {
                    // there was no trailing ;
                    valid = NO;
                } else if ([temp isEqualToString:@"amp"]) {
                    c = '&';
                } else if ([temp isEqualToString:@"quot"]) {
                    c = '"';
                } else if ([temp isEqualToString:@"lt"]) {
                    c = '<';
                } else if ([temp isEqualToString:@"gt"]) {
                    c = '>';
                } else {
                    // unknown entity
                    valid = NO;
                }
            }
            if (!valid)
            {
                // we errored, just emit the whole thing raw
                [results appendString:[input substringWithRange:NSMakeRange(savedLocation, [scanner scanLocation]-savedLocation)]];
            }
            else
            {
                [results appendFormat:@"%C", (unichar)c];
            }
        }
    }
    return results;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setListView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_listView release];
    [_backgroundImage release];
	[super dealloc];
}


@end
