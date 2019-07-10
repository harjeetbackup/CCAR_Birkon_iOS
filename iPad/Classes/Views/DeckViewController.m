    //
//  DeckViewController.m
//  FlashCardDB
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DeckCell.h"
#import "CardDetails.h"
#import "AppDelegate_iPad.h"

#import "FlashCard.h"
#import "ModalViewCtrl.h"

#import "DeckViewController.h"
#import "SearchViewController.h"
#import "IndexViewController.h"
#import "MyCommentsViewController.h"
#import "MyVoiceNotesViewController.h"


#import "Utils.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI * x / 180.0)
#import "SearchViewController.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation CustomNavigationBar

- (void) drawRect:(CGRect) rect
{
	/*UIImage* img = [UIImage imageNamed:@"TopBar"];
	[img drawInRect:rect];*/
}

@end


@implementation DeckViewController


@synthesize cardDecks = _cardDecks;
@synthesize _detail,_navLabel;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidAppear:(BOOL)animated
{
	[_extraNavigationBar setNeedsDisplay];
   
	[super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationItem.hidesBackButton=YES;
    //[self setProperRotation:YES];
    
}
// This method will display the card details page for a particular index
- (void) showDetailViewWithArray:(NSMutableArray*) array cardIndex:(NSInteger) index caller:(NSString *)strCaller
{	
	_detail = [[CardDetails alloc] initWithNibName:@"CardDetailsiPad" bundle:nil] ;
	if ([strCaller isEqualToString:@"self"]) {
		_detail.basicCall = YES;
	}
	else {
		_detail.basicCall = NO;
	}

	[_detail setParentViewCtrl:self];
	_detail._selectedCardIndex=index;
	_detail.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
	[_detail loadArrayOfCards:array withParentViewC:self];
    
   /* _detail.view.tag = 1;
    if([self.view viewWithTag:1]!=nil)
    {
        [[self.view viewWithTag:1] removeFromSuperview];
    }*/
    
	[self.view addSubview:_detail.view];  
  
}

- (void) showIndexViewForDeck:(FlashCardDeck *)objDeck
{
	_indexView = [[IndexViewController alloc] initWithNibName:@"IndexViewiPad" bundle:nil forDeck:objDeck];	
	[_indexView setParentViewCtrl:self];
     if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
     {
	   _indexView.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
     }
    else
    {
         _indexView.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
    }
   // _indexView.view.frame = CGRectMake(382, 44, 980, 700);
    _indexView.view.tag = 2;
    if([self.view viewWithTag:2]!=nil)
    {
        [[self.view viewWithTag:2] removeFromSuperview];
    }
	[self.view addSubview:_indexView.view];
    
}

- (void) showSearchViewForDeck:(NSMutableArray*) array cardIndex:(NSInteger) index search:(NSString *)text
{	
	_detail = [[CardDetails alloc] initWithNibName:@"CardDetailsiPad" bundle:nil];
	_detail.basicCall = NO;
	[_detail setParentViewCtrl:self];
	_detail._selectedCardIndex=index;
	_detail._searchText=text;
	_detail.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
	_detail.basicCall = NO;
	[_detail loadArrayOfCards:array withParentViewC:self];
    _detail.view.tag = 3;
    if([self.view viewWithTag:3]!=nil)
    {
        [[self.view viewWithTag:3] removeFromSuperview];
    }
	[self.view addSubview:_detail.view];
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
   /* CGRect aFrameNavBar = self.aNavBar.frame;
    aFrameNavBar.origin.y = 20;
    self.aNavBar.frame = aFrameNavBar;*/

  /*  CGRect aFrameImgView = self.aImgView.frame;
    aFrameImgView.origin.y = 20;
    self.aImgView.frame = aFrameImgView;*/
    
   /* CGRect myFrameTable = self.aTableView.frame;
    myFrameTable.origin.y = 120;
    self.aTableView.frame = myFrameTable;*/
    
     if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
     {
    self.dailyBlessingToolBar.tintColor = [UIColor blackColor];
    self.searchButton.tintColor = [UIColor whiteColor];
    self.indexButton.tintColor = [UIColor whiteColor];
    self.settingButton.tintColor = [UIColor whiteColor];
    self.helpButton.tintColor = [UIColor whiteColor];
    self.infoButton.tintColor = [UIColor whiteColor];
    self.aLabel.textColor = [UIColor whiteColor];
     }
     else{
         
         UIImage *imageSetting = [UIImage imageNamed:@"6b.png"];
         [self.settingButton setImage:imageSetting];
         self.settingButton.tintColor = [UIColor  colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];
         
         UIImage *imageIndex = [UIImage imageNamed:@"5.png"];
         [self.indexButton setImage:imageIndex];
         self.indexButton.tintColor = [UIColor  colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];
         
         UIImage *imageZoom = [UIImage imageNamed:@"4.png"];
         [self.searchButton setImage:imageZoom];
         self.searchButton.tintColor = [UIColor colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];
         
         UIImage *imageHelp = [UIImage imageNamed:@"7.png"];
         [self.helpButton setImage:imageHelp];
         self.helpButton.tintColor = [UIColor colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];
         
         UIImage *imageInfo = [UIImage imageNamed:@"info_seven.png"];
         [self.infoButton setImage:imageInfo];
         self.infoButton.tintColor = [UIColor colorWithRed:52.0/255 green:122.0/255 blue:164.0/255 alpha:1];

         

     }



	UIImageView* imgView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftBackground.png"]] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
	[_tableView setBackgroundView:imgView];
    }
	self.navigationController.navigationBarHidden = NO;
	self.navigationController.delegate = self;
	//self.title = @"Meggs";
	self.title = [Utils getValueForVar:kHeaderTitle];
	_navLabel.text = [Utils getValueForVar:kHeaderTitle];
    [_navLabel setHidden:YES];
    [_aLabel setHidden:YES];
	[self performSelector:@selector(openFirstView) withObject:self afterDelay:0.3];
	

}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)setProperRotation:(BOOL)animated
{
	//UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.0];
	}
	
	if (orientation == UIDeviceOrientationPortraitUpsideDown){
    
		self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(180));}
	
	else if (orientation == UIDeviceOrientationLandscapeLeft)
		self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(90));
	
	else if (orientation == UIDeviceOrientationLandscapeRight)
		self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(-90));
	
	else if(orientation==UIDeviceOrientationUnknown){
		self.view.transform = CGAffineTransformRotate(CGAffineTransformIdentity, degreesToRadians(-90));
	}
    
	if (animated)
		[UIView commitAnimations];
	
}

- (void) openFirstView
{
	[AppDelegate_iPad delegate].isBookMarked = NO;
	NSMutableArray* deckArray = [_cardDecks.allCardDeck  getCardsList];
	
	[self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if(interfaceOrientation == UIDeviceOrientationLandscapeRight || interfaceOrientation == UIDeviceOrientationLandscapeLeft)
		return YES;
	else
		return NO;
}

- (void)dealloc
{
    [_aNavBar release];
    [_aImgView release];
    [_aTableView release];
    [_dailyBlessingToolBar release];
    [_dailyBlessingToolBar release];
    [_searchButton release];
    [_indexButton release];
    [_settingButton release];
    [_helpButton release];
    [_infoButton release];
    [_aImgView release];
    [_aTableView release];
    [_aLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark UITableView delegates

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
    if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
    {
        if(section == 4)
            return _cardDecks.flashCardDeckList.count;
        return 1;
    }
    else
    {
        if(section == 3)
            return _cardDecks.flashCardDeckList.count;
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return 1;
    }
    else
    {
	return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 50;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
        return 5;
    else
        return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{       
	DeckCell* cell = nil;

	
	if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
    {
        UITableViewCell* introCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil] autorelease];
	switch (indexPath.section) 
	{
        case 0:
            tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
            introCell.textLabel.text=@"Introduction";
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                introCell.backgroundColor=[UIColor colorWithRed:211.0/255 green:243.0/255 blue:255.0/255 alpha:1];
            }
            else{
            introCell.backgroundColor=[Utils colorFromString:[Utils getValueForVar:kIntroDeckColor]];
            }
        
            return introCell;
            break;
		case 1:
			tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
			cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.allCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
          	break;
            
        case 2:
            tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
            cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.allSongsDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
            break;
		case 3:
			tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
			cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.bookMarkedCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
			break;
    			
		case 4:
			tableView.separatorColor = [Utils colorFromString:@"180,180,180"];
			cell = [DeckCell creatCellViewWithFlashCardDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row] withTextColor:[Utils colorFromString:[Utils getValueForVar:kDeckCardsTextColor]]];
            
           // cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
       
			break;
	}
    }
    else
    {
        switch (indexPath.section)
        {
            case 0:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.allCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kAllCardsTextColor]]];
                break;
                
            case 1:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.allSongsDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
                break;
            case 2:
                tableView.separatorColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
                cell = [DeckCell creatCellViewWithFlashCardDeck:_cardDecks.bookMarkedCardDeck withTextColor:[Utils colorFromString:[Utils getValueForVar:kBookmarkedCardsTextColor]]];
                break;
                
            case 3:
                tableView.separatorColor = [Utils colorFromString:@"180,180,180"];
                cell = [DeckCell creatCellViewWithFlashCardDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row - 1] withTextColor:[Utils colorFromString:[Utils getValueForVar:kDeckCardsTextColor]]];
                break;
        }
    }
		
	return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	cell.backgroundColor = [UIColor colorWithRed:0.0 green:0.322 blue:0.369 alpha:1.0];
//
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if((indexPath.section == 2 && [[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"no"] && indexPath.row == 0)|| (indexPath.section == 4 && [[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"] && indexPath.row == 0))
		return;
		
	NSMutableArray* deckArray=nil;
    if([[[Utils getValueForVar:kIsIntroScreen] lowercaseString] isEqualToString:@"yes"])
    {
        switch (indexPath.section)
        {
            case 0:
                deckArray = nil;
                ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kcontentTypeIntro];
                [model setParentCtrl:self];
                model.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
                model.view.tag = 6;
                if([self.view viewWithTag:6]!=nil)
                {
                    [[self.view viewWithTag:6] removeFromSuperview];
                }
                [self.view addSubview:model.view];
                return;
                break;
                
            case 1:
                [AppDelegate_iPad delegate].isBookMarked = NO;
                deckArray = [_cardDecks.allCardDeck  getCardsList];
                break;
            case 2:
                [AppDelegate_iPad delegate].isBookMarked = NO;
                deckArray = [_cardDecks.allSongsDeck  getCardsList];
                break;
            case 3:
                [AppDelegate_iPad delegate].isBookMarked = YES;
                deckArray = [_cardDecks.bookMarkedCardDeck  getCardsList];
                if (deckArray == nil || deckArray.count <= 0)
                {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There are no bookmarked items" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                    return;
                }
                break;
          
            case 4:
                [AppDelegate_iPad delegate].isBookMarked = NO;
                deckArray = [[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row]  getCardsList];
                break;
        }
        if ([[[Utils getValueForVar:kCardList] lowercaseString] isEqualToString:@"yes"])
        {
            if(indexPath.section == 4)
            [self showIndexViewForDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row]];
            else if(indexPath.section == 3)
                [self showIndexViewForDeck:_cardDecks.bookMarkedCardDeck];
            else if(indexPath.section == 2)
                [self showIndexViewForDeck:_cardDecks.allSongsDeck];
             else if(indexPath.section == 1)
                 [self showIndexViewForDeck:_cardDecks.allCardDeck];
        }
        else	// Take to the card details page
        {
            // Randomize the cards if the random property is set
            if([AppDelegate_iPad delegate].isRandomCard == 1)
            {
                [Utils randomizeArray:deckArray];
            }
            [self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
        }
    }
    else{
	switch (indexPath.section)
	{
		case 0:
			[AppDelegate_iPad delegate].isBookMarked = NO;
			deckArray = [_cardDecks.allCardDeck  getCardsList];
			break;
			
		case 1:
			[AppDelegate_iPad delegate].isBookMarked = YES;
			deckArray = [_cardDecks.bookMarkedCardDeck  getCardsList];
			if (deckArray == nil || deckArray.count <= 0)
			{
				UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"There are no bookmarked items" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert release];
				return;
			}
			break;
			
		case 2:
			[AppDelegate_iPad delegate].isBookMarked = NO;
			deckArray = [[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row - 1]  getCardsList];
			break;
	}
    
	
	// If the section 2 (any of the card decks) has been clicked, then check whether "CardList" option is set. If yes, then produce the card list
	// view or take to the card details view
	if ([[[Utils getValueForVar:kCardList] lowercaseString] isEqualToString:@"yes"] && indexPath.section == 2) 
	{
		[self showIndexViewForDeck:[_cardDecks.flashCardDeckList objectAtIndex:indexPath.row - 1]];
	}
	else	// Take to the card details page
	{
		// Randomize the cards if the random property is set
		if([AppDelegate_iPad delegate].isRandomCard == 1)
		{
			[Utils randomizeArray:deckArray];
		}
		[self showDetailViewWithArray:deckArray cardIndex:0 caller:@"self"];
	}
    }
 
  //  cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kIndexRowColor]];
	
}
/*
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [Utils colorFromString:[Utils getValueForVar:kSelectedCardsColor]];
}*/

- (IBAction)displaySettings
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeSetting];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
    model.view.tag = 4;
    if([self.view viewWithTag:4]!=nil)
    {
        [[self.view viewWithTag:4] removeFromSuperview];
    }
	[self.view addSubview:model.view];
}

- (IBAction)displayHelp
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeHelp];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
    model.view.tag = 5;
    if([self.view viewWithTag:5]!=nil)
    {
        [[self.view viewWithTag:5] removeFromSuperview];
    }
	[self.view addSubview:model.view];
	
}

- (IBAction)displayInfo
{
	ModalViewCtrl* model = [[ModalViewCtrl alloc] initWithNibName:@"ModalViewiPad" bundle:nil contentType:kContentTypeInfo];
	[model setParentCtrl:self];
	model.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
    model.view.tag = 6;
    if([self.view viewWithTag:6]!=nil)
    {
        [[self.view viewWithTag:6] removeFromSuperview];
    }
	[self.view addSubview:model.view];
	
}

- (IBAction)searchCards
{
	SearchViewController* searchView = [[SearchViewController alloc] initWithNibName:@"SearchViewiPad" bundle:nil];
	[searchView setParentViewCtrl:self];
	searchView.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
    searchView.view.tag = 7;
    if([self.view viewWithTag:7]!=nil)
    {
        [[self.view viewWithTag:7] removeFromSuperview];
    }
	[self.view addSubview:searchView.view];
}


- (IBAction)cardIndex
{
	IndexViewController* indexView = [[IndexViewController alloc] initWithNibName:@"IndexViewiPad" bundle:nil forDeck:nil];
	[indexView setParentViewCtrl:self];
	indexView.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
    indexView.view.tag = 8;
    if([self.view viewWithTag:8]!=nil)
    {
        [[self.view viewWithTag:8] removeFromSuperview];
    }
	[self.view addSubview:indexView.view];
	

}


- (void) myComments{
	
	MyCommentsViewController* commentsView = [[MyCommentsViewController alloc] initWithNibName:@"MyCommentsViewiPad" bundle:nil];
	commentsView.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
    commentsView.view.tag = 9;
    if([self.view viewWithTag:9]!=nil)
    {
        [[self.view viewWithTag:9] removeFromSuperview];
    }
	[self.view addSubview:commentsView.view];
	
}

- (void) myVoiceNotes{
	
	MyVoiceNotesViewController* notesView = [[MyVoiceNotesViewController alloc] initWithNibName:@"MyVoiceNotesViewiPad" bundle:nil];
	notesView.view.frame = CGRectMake(_tableView.frame.size.width, 0, (UIScreen.mainScreen.bounds.size.width - _tableView.frame.size.width), UIScreen.mainScreen.bounds.size.height);
    notesView.view.tag = 10;
    if([self.view viewWithTag:10]!=nil)
    {
        [[self.view viewWithTag:10] removeFromSuperview];
    }
	[self.view addSubview:notesView.view];
	
}


/* Added By Ravindra */
-(IBAction) showActionSheet{
	
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	
	
	[actionSheet addButtonWithTitle:@"Info"];
	
	if ([AppDelegate_iPad delegate].isVoiceNotesEnabled) {
		[actionSheet addButtonWithTitle:@"My Voice Notes"];
	}
	
	if ([AppDelegate_iPad delegate].isCommentsEnabled) {
		[actionSheet addButtonWithTitle:@"My Comments"];
	}
	
	
	if ([AppDelegate_iPad delegate].isFacebookEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Facebook"];
	}
	
	if ([AppDelegate_iPad delegate].isTwitterEnabled) {
		[actionSheet addButtonWithTitle:@"Publish to Twitter"];
	}
	
	[actionSheet addButtonWithTitle:@"Cancel"];
	
	[actionSheet showFromRect:CGRectMake(200, 700, 300, 100) inView:self.view animated:YES];
	[actionSheet release]; 	

	
	
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if(buttonIndex==-1) return;
	
	
	NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
	if ([title isEqualToString:@"Info"]) {
		[self displayInfo];
	}
	
	else if ([title isEqualToString:@"Publish to Facebook"]) {
		[self publishToFacebook];
	}
	
	else if ([title isEqualToString:@"Publish to Twitter"]) {
		[self publishToTwitter];
	}
	
	else if ([title isEqualToString:@"My Voice Notes"]) {
		[self myVoiceNotes];
	}
	
	else if ([title isEqualToString:@"My Comments"]) {
		[self myComments];
	}
	

}



-(void) publishToFacebook{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:[Utils getValueForVar:kFacebookMessage]];
        
        [self presentViewController:facebookSheet animated:YES completion:nil];
    }  
	
}




-(void) publishToTwitter{
	if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[Utils getValueForVar:kTwitterMessage]];
        [self presentModalViewController:tweetSheet animated:YES];
    }
    
	
}

/* End of Updated Code By Ravindra */


- (void)updateInfo
{
	[_cardDecks updateProficiency];
	[_tableView reloadData];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	if (viewController == self)
		[self updateInfo];
}


- (void) clearView{
	[_detail.view removeFromSuperview];
}

- (void) setSelectedIndex:(NSInteger) index{
	_detail._selectedCardIndex=index;
}

- (void)viewDidUnload {
[self setANavBar:nil];
    [self setAImgView:nil];
    [self setATableView:nil];
    [self setDailyBlessingToolBar:nil];
    [self setDailyBlessingToolBar:nil];
    [self setSearchButton:nil];
    [self setIndexButton:nil];
    [self setSettingButton:nil];
    [self setHelpButton:nil];
    [self setInfoButton:nil];
    [self setAImgView:nil];
    [self setATableView:nil];
    [self setALabel:nil];
[super viewDidUnload];
}
@end
