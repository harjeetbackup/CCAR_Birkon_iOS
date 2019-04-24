//
//  CardDetails.m
//  FlashCards
//
//  Created by Friends on 1/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DBAccess.h"
#import "FlashCard.h"
#import "CustomWebView_iPhone.h"
#import "AppDelegate_iPhone.h"
#import "VideoGallaryViewController_iPhone.h"
#import "VoiceNotesViewController_iPhone.h"
#import "CommentsViewController_iPhone.h"
#import "SearchViewController_iPhone.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>

#import "CardDetails_iPhone.h"
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@implementation CardDetails_iPhone

@synthesize _selectedCardIndex;
@synthesize _searchText;
@synthesize mWindow;
@synthesize arrCards;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
   // _scrlView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    UIButton *buttonPrevious = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonPrevious.tintColor = [UIColor blackColor];
    [buttonPrevious addTarget:self
               action:@selector(loadPrevCardDetails:)
     forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"" forState:UIControlStateNormal];
    // [button setBackgroundImage:[UIImage imageNamed:@"backSeven.png"] forState:UIControlStateNormal];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
    [buttonPrevious setImage:[UIImage imageNamed:@"back-red_1.png"] forState:UIControlStateNormal];
    }
    else
    {
       [buttonPrevious setImage:[UIImage imageNamed:@"left_arw.png"] forState:UIControlStateNormal];
    }
    
    buttonPrevious.frame = CGRectMake(8.0, 5.0, 22.0, 38.0);
    buttonPrevious.contentMode=UIViewContentModeScaleAspectFit;
    buttonPrevious.hidden = NO;
    //[self.view addSubview: button];
    [self.customToolBarBottom addSubview: buttonPrevious];
    
    UIButton *buttonBookark = [UIButton buttonWithType:UIButtonTypeCustom];
   // buttonBookark.tintColor = [UIColor blackColor];
    [buttonBookark addTarget:self
                       action:@selector(bookMarkeds:)
             forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"" forState:UIControlStateNormal];
    // [button setBackgroundImage:[UIImage imageNamed:@"backSeven.png"] forState:UIControlStateNormal];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
       // [buttonBookark setImage:[UIImage imageNamed:@"bookmark_7.png"] forState:UIControlStateNormal];
         buttonBookark.frame = CGRectMake(150.0, 5.0, 30.0, 38.0);
   }
    else
   {
        //[buttonBookark setImage:[UIImage imageNamed:@"bookmark_6.png"] forState:UIControlStateNormal];
        buttonBookark.frame = CGRectMake(120.0, 5.0, 65.0, 35.0);
    }
    
   // buttonBookark.frame = CGRectMake(160.0, 5.0, 22.0, 38.0);
    buttonBookark.contentMode=UIViewContentModeScaleAspectFit;
    buttonBookark.hidden = NO;
    //[self.view addSubview: button];
    [self.customToolBarBottom addSubview: buttonBookark];
    
    UIButton *buttonNext = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonNext.tintColor = [UIColor blackColor];
    [buttonNext addTarget:self
                       action:@selector(loadNextCardDetails:)
             forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"" forState:UIControlStateNormal];
    // [button setBackgroundImage:[UIImage imageNamed:@"backSeven.png"] forState:UIControlStateNormal];
     if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
     {
    [buttonNext setImage:[UIImage imageNamed:@"next-red_1.png"] forState:UIControlStateNormal];
     }
    else
    {
        [buttonNext setImage:[UIImage imageNamed:@"right_arw.png"] forState:UIControlStateNormal];
 
    }
    buttonNext.frame = CGRectMake(290.0, 5.0, 22.0, 38.0);
    buttonNext.contentMode=UIViewContentModeScaleAspectFit;
    buttonNext.hidden = NO;
    //[self.view addSubview: button];
    [self.customToolBarBottom addSubview: buttonNext];
    //[_myNavBar addSubview:button];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        
        
        CGRect myFrameScrollView= _scrlView.frame;
        myFrameScrollView.origin.y = 44;
        _scrlView.frame = myFrameScrollView;
        _scrlView.autoresizingMask =(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        //self.dailyBlessingsTable.backgroundColor = [UIColor whiteColor];
        
       CGRect myFrameScrollViewHeight = _scrlView.frame;
        myFrameScrollViewHeight.size.height = 391;
        _scrlView.frame = myFrameScrollViewHeight;
        
    }
	
	[_prevButton setNeedsDisplay];
	_act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	_act.center = self.view.center;
	
	UIView* topRightBarView = [[UIView alloc] init];
	topRightBarView.frame = CGRectMake(210, 0, 100, 44);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        favImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        [favImg setFrame:CGRectMake(5, 8, 25, 25)];

    }
    else
    {
	favImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmarkTop_ic.png"]];
	[favImg setFrame:CGRectMake(5, 8, 25, 25)];
    }
	
	knowDontKnowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iknowTop_ic.png"]];
	[knowDontKnowImg setFrame:CGRectMake(28, 8, 25, 25)];
	knowDontKnowImg.hidden = YES;

	if ([AppDelegate_iPhone delegate].isVoiceNotesEnabled || [AppDelegate_iPhone delegate].isCommentsEnabled) {
			aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(52, 8, 25, 25)];
			actionImg = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, 25, 25)];
	}
	else {
		aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, 25, 25)];
		actionImg = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, 25, 25)];
		actionImg.hidden = YES;
	}

	
	//aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(52, 8, 25, 25)];
	[aduioImg setImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
	[aduioImg addTarget:self action:@selector(playAudioFile) forControlEvents:UIControlEventTouchUpInside];
	aduioImg.hidden = YES;

	searchImg = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, 25, 25)];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        [searchImg setImage:[UIImage imageNamed:@"zoom_btnSeven.png"] forState:UIControlStateNormal];
    }
    else
    {
	[searchImg setImage:[UIImage imageNamed:@"zoom_btn.png"] forState:UIControlStateNormal];
    }
	[searchImg addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
	searchImg.hidden = NO;
	
	//actionImg = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, 25, 25)];
	[actionImg setImage:[UIImage imageNamed:@"window_icon.png"] forState:UIControlStateNormal];
	[actionImg addTarget:self action:@selector(showActionSheet) forControlEvents:UIControlEventTouchUpInside];
	
	[topRightBarView addSubview:favImg];
	[topRightBarView addSubview:knowDontKnowImg];
	[topRightBarView addSubview:aduioImg];
	[topRightBarView addSubview:searchImg];
	[topRightBarView addSubview:actionImg];
	
	/*
	if ([AppDelegate_iPhone delegate].isVoiceNotesEnabled || [AppDelegate_iPhone delegate].isCommentsEnabled) {
		aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(52, 8, 25, 25)];
		[aduioImg setImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
		[aduioImg addTarget:self action:@selector(playAudioFile) forControlEvents:UIControlEventTouchUpInside];
		aduioImg.hidden = YES;
		[topRightBarView addSubview:actionImg];
	}
	else {
		aduioImg = [[UIButton alloc] initWithFrame:CGRectMake(80, 8, 25, 25)];
		[aduioImg setImage:[UIImage imageNamed:@"sound.png"] forState:UIControlStateNormal];
		[aduioImg addTarget:self action:@selector(playAudioFile) forControlEvents:UIControlEventTouchUpInside];
		aduioImg.hidden = YES;
	}
	*/
	[topRightBarView addSubview:aduioImg];
	
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:topRightBarView] autorelease];
	
	[self showBarButtonItem];
    [super viewDidLoad];

	[self updateCardDetails];
	_prevButton.enabled = NO;

	//_selectedCardIndex = 0;
	
	_cardType = kCardTypeFront;
	[topRightBarView release];
	
	mWindow = (TapDetectingWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0];
	mWindow.controllerThatObserves = self;
    [self loadArrayOfCards:arrCards];
}
-(void)viewDidAppear:(BOOL)animated
{
  //  _scrlView.frame = CGRectMake(0, 44, 320, 436);
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)loadPrevCardDetails:(id)sender
{
	_isDragging = NO;
	if(_selectedCardIndex - 1 >= 0)
	{
		--_selectedCardIndex;
		_cardType = kCardTypeFront;
        
		[self updateFlashCard];
		[_scrlView setContentOffset:CGPointMake(320 * _selectedCardIndex, 0) animated:YES];
		[self updateFlashDetails];
	}
}
- (void)loadNextCardDetails:(id)sender
{
	_isDragging = NO;
    
	if(_selectedCardIndex + 1 < [_arrayOfCards count])
	{
		++_selectedCardIndex;
        
		_cardType = kCardTypeFront;
        
		[self updateFlashCard];
		[_scrlView setContentOffset:CGPointMake(320 * _selectedCardIndex, 0) animated:YES];
		[self updateFlashDetails];
	}
}

- (void)bookMarkeds:(id)sender
{
	FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
	card.isBookMarked = !card.isBookMarked;
	[self updateCardDetails];
	[[AppDelegate_iPhone getDBAccess] setBookmarkedCard:((card.isBookMarked) ? 1 : 0) ForCardId:card.cardID];
	
	if ([AppDelegate_iPhone delegate].isBookMarked && !card.isBookMarked)
	{
		if (_arrayOfCards.count > 1)
		{
			[_arrayOfCards removeObjectAtIndex:_selectedCardIndex];
			--_totalCard;
            if(_arrayOfCards.count==_selectedCardIndex)
                _selectedCardIndex = ((_selectedCardIndex - 1) < 0) ? 0 : (_selectedCardIndex - 1);
			[_scrlView setContentSize:CGSizeMake(320 * [_arrayOfCards count], _scrlView.frame.size.height)];
            
			[self updateFlashDetails];
			[self updateFlashCard];
		}
		else
		{
           	FlashCardDeckList* deckList = [[FlashCardDeckList alloc] init];
            DeckViewController_iPhone* controller = [[DeckViewController_iPhone alloc] initWithNibName:@"DeckViewController_iPhone" bundle:nil];
            
            controller.cardDecks = deckList;
            [self.navigationController pushViewController:controller animated:YES];
            self.navigationItem.hidesBackButton=YES;
            [deckList release];
            [controller release];
		}
        
	}
}



- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewWillDisappear:(BOOL)animated
{
	//[_scrlView setContentOffset:CGPointZero];
	[self updateCardDetails];	
} 

- (void)showBarButtonItem
{
	UIImage* img = [UIImage imageNamed:@"back_btn_iPhone.png"];
	UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(5, 7, 50, 30);
	[button setImage:img forState:UIControlStateNormal];
	[button addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem* cancelButton = [[[UIBarButtonItem alloc]initWithCustomView:button] autorelease];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
    {
	self.navigationItem.leftBarButtonItem = cancelButton;
    }
}

- (void)popView
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc 
{
	[favImg release];
	[knowDontKnowImg release];
	[aduioImg release];
	[searchImg release];
	[_act release];
	
	[_scrlView release];
	[_playAudioFileButton release];
	[_searchButton release];
	[_favorite release];
	[_know release];
		
	[_toggleFavButton release];
	[_toggleKnowUnKnownButton release];
	
	[_prevButton release];
	[_nextButton release];
		
	[_viewTurnedBack release];
	
	[_arrayOfpages release];
	
	if(_moviePlayer != nil)
		[_moviePlayer release];
	
	[_arrayOfCards release];
    [_customToolBarBottom release];
    [super dealloc];
}

#pragma mark -
#pragma mark Methods

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	[player release];
}

- (IBAction)playAudioFile
{
	NSError* err = nil;
	Card* card = [[_arrayOfCards objectAtIndex: _selectedCardIndex] getCardOfType:_cardType];
	
	NSString* audioFileName = card.audioFile;

	if (audioFileName == nil)
		return;
	
	audioFileName = [[NSBundle mainBundle] pathForResource:audioFileName ofType:nil inDirectory:nil];
	
	//NSLog(@"%@", audioFileName);
	
	if (audioFileName == nil)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Associated file not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}

	AVAudioPlayer* player = [[AVAudioPlayer alloc] initWithContentsOfURL:
							 [NSURL fileURLWithPath:audioFileName] 
									error:&err];
	//player.delegate = self;
	[player play];
}

- (IBAction)search
{
    SearchViewController_iPhone* searchView = [[SearchViewController_iPhone alloc] initWithNibName:@"SearchView_iPhone" bundle:nil];
	[self.navigationController pushViewController:searchView animated:YES];
	[searchView release];
	/*Card* card = [[_arrayOfCards objectAtIndex: _selectedCardIndex] getCardOfType:_cardType];
	NSString* videoFileName = card.vedioFile;

	if (videoFileName == nil)
		return;
	
	// Setup the player
	_moviePlayer = [[VideoGallaryViewController_iPhone alloc] init];
	
	videoFileName = [[NSBundle mainBundle] pathForResource:videoFileName ofType:nil inDirectory:nil];
	
	//NSLog(@"%@", videoFileName);

	if(videoFileName == nil)
	{
		UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Associated file not found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
	
	NSURL* url = [NSURL fileURLWithPath:videoFileName];
	
	_moviePlayer.movieURL = url;
	
	[_moviePlayer readyPlayer];
	
	[self presentModalViewController:_moviePlayer animated:YES];*/
}

- (void)loadArrayOfCards:(NSArray*)cards
{
    NSLog(@"%@",cards);
	_arrayOfCards = (NSMutableArray*)[cards retain];
	
	if (_arrayOfpages == nil)
	{
		_arrayOfpages = [[NSMutableArray alloc] initWithCapacity:3];
	}
	 
	_totalCard = [_arrayOfCards count];
	int count = (_arrayOfCards.count > 3) ? 3 : _arrayOfCards.count;
	
	//[_scrlView setContentSize:CGSizeMake(320 * [_arrayOfCards count], _scrlView.frame.size.height)];
    _scrlView.contentSize = CGSizeMake(320 * [_arrayOfCards count], _scrlView.frame.size.height);
	_scrlView.scrollEnabled = YES;
	
	NSInteger index;
	NSInteger tempIndex=_selectedCardIndex;
	
	
	if (_selectedCardIndex >= 1 && _selectedCardIndex >= [_arrayOfCards count]-2) {
		tempIndex=_selectedCardIndex-1;
	}
	
	if (_totalCard > 2 && _selectedCardIndex > 1) {
		tempIndex=_selectedCardIndex-2;
	}
	
	
	for (int i = 0; i < count; i++)
	{
		index = tempIndex	+ i;
		
		//Card* card = [[_arrayOfCards objectAtIndex:index] getCardOfType: kCardTypeFront];
		CustomWebView_iPhone* page = [[CustomWebView_iPhone alloc] initWithFrame:CGRectMake(320 * i, 0, 320, _scrlView.frame.size.height)];
        page.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        Card* card = [[_arrayOfCards objectAtIndex:index] getCardOfType: kCardTypeFront];

		page.tag = 1100 + i;
		[page loadClearBgHTMLString:card.cardTitle];
		[_scrlView addSubview:page];
		[_arrayOfpages addObject:page];
		
		if (_searchText!=nil && [_searchText length] > 0) {
			page.searchText=_searchText;
		}
		if (i == 0) 
		{
			mWindow.viewToObserve = page;
		}
		
		[page release];
	}
	
	
	_scrlView.showsHorizontalScrollIndicator = NO;

	_nextButton.enabled = YES;
	_prevButton.enabled = NO;
	
	self.title = [NSString stringWithFormat:@"%d of %d", _selectedCardIndex + 1, [_arrayOfCards count]];
    

	//scrollview
	[self updateCardDetails];
	

	if (_totalCard >= 2 && _selectedCardIndex >= 1) {
		[self updateFlashCard];
		[_scrlView setContentOffset:CGPointMake(320 * _selectedCardIndex, 0) animated:YES];
		[self updateFlashDetails];
		
	}else if (_totalCard==1) {
		_nextButton.enabled=NO;
	}
	

}

- (void)userDidTapWebView:(id)tapPoint
{
    if ([[[Utils getValueForVar:kFlipOnTap] lowercaseString] isEqualToString:@"yes"]) {
		[self showCardBack];
	}
}


- (void)updateCardDetails
{	
	
	Card* card = [[_arrayOfCards objectAtIndex:_selectedCardIndex] getCardOfType: _cardType];

	aduioImg.hidden = YES;
	_playAudioFileButton.hidden = YES;
	searchImg.hidden = NO;
	_searchButton.hidden = YES;	
	
	
	if(card.audioFile != nil)
	{
		aduioImg.hidden = NO;
		_playAudioFileButton.hidden = NO;
	}
	
	if(card.vedioFile != nil)
	{
		searchImg.hidden = NO;
		_searchButton.hidden = NO;
	}
	
	[self updateNavBar];
}


-(void) updateFlashCardAtIndex:(int)index
{
	
	NSInteger tempIndex=(index % 3);
	CustomWebView_iPhone* webView = (CustomWebView_iPhone*)[_arrayOfpages objectAtIndex:tempIndex];
	webView.frame = CGRectMake(320 * index, 0, 320, _scrlView.frame.size.height);
	webView.tag = 1100 + index;
	
	//if (index != _selectedCardIndex){
		[webView loadClearBgHTMLString:[[_arrayOfCards objectAtIndex:index] getCardOfType: _cardType].cardTitle];
		mWindow.viewToObserve = webView;
		if (_searchText!=nil && [_searchText length] > 0) {
			webView.searchText=_searchText;
		}
	
		
	//}
	
}


- (void) updateFlashCard
{	
	_isDragging = NO;
	(_selectedCardIndex > 0) ? [self updateFlashCardAtIndex:(_selectedCardIndex - 1)] : -99;
	(_selectedCardIndex < (_totalCard - 1)) ? [self updateFlashCardAtIndex:(_selectedCardIndex + 1)] : -99;
	[self updateFlashCardAtIndex:_selectedCardIndex];
}


/*- (IBAction)loadNextCardDetails
{
	_isDragging = NO;

	if(_selectedCardIndex + 1 < [_arrayOfCards count])
	{
		++_selectedCardIndex;

		_cardType = kCardTypeFront;

		[self updateFlashCard];
		[_scrlView setContentOffset:CGPointMake(320 * _selectedCardIndex, 0) animated:YES];
		[self updateFlashDetails];
	}
}*/

/*- (IBAction)loadPrevCardDetails
{
	_isDragging = NO;
	if(_selectedCardIndex - 1 >= 0)
	{
		--_selectedCardIndex;
		_cardType = kCardTypeFront;

		[self updateFlashCard];
		[_scrlView setContentOffset:CGPointMake(320 * _selectedCardIndex, 0) animated:YES];
		[self updateFlashDetails];
	}
}*/

- (IBAction)showCardBack
{
	_cardType = (_cardType == kCardTypeBack) ? kCardTypeFront : kCardTypeBack;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.8];
	
	[UIView setAnimationTransition:(UIViewAnimationTransitionFlipFromLeft)
						   forView:_scrlView cache:NO];
	
	int tagVal = 1100 + _scrlView.contentOffset.x / 320;
	CustomWebView_iPhone* webView = (CustomWebView_iPhone*)[_scrlView viewWithTag:tagVal];
	[webView loadClearBgHTMLString:[[_arrayOfCards objectAtIndex:_selectedCardIndex] getCardOfType: _cardType].cardTitle];

	[UIView commitAnimations];
	[self updateCardDetails];
	
	if (_searchText!=nil && [_searchText length] > 0) {
		webView.searchText=_searchText;
	}
	
}

/*- (IBAction)bookMarked
{
	FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
	card.isBookMarked = !card.isBookMarked;
	[self updateCardDetails];
	[[AppDelegate_iPhone getDBAccess] setBookmarkedCard:((card.isBookMarked) ? 1 : 0) ForCardId:card.cardID];
	
	if ([AppDelegate_iPhone delegate].isBookMarked && !card.isBookMarked)
	{
		if (_arrayOfCards.count > 1)
		{
			[_arrayOfCards removeObjectAtIndex:_selectedCardIndex];
			--_totalCard;
            if(_arrayOfCards.count==_selectedCardIndex)
			_selectedCardIndex = ((_selectedCardIndex - 1) < 0) ? 0 : (_selectedCardIndex - 1);
			[_scrlView setContentSize:CGSizeMake(320 * [_arrayOfCards count], _scrlView.frame.size.height)];
            
			[self updateFlashDetails];
			[self updateFlashCard];
		}
		else
		{
           	FlashCardDeckList* deckList = [[FlashCardDeckList alloc] init];
            DeckViewController_iPhone* controller = [[DeckViewController_iPhone alloc] initWithNibName:@"DeckViewController_iPhone" bundle:nil];
            
            controller.cardDecks = deckList;
            [self.navigationController pushViewController:controller animated:YES];
            self.navigationItem.hidesBackButton=YES;
            [deckList release];
            [controller release];
		}

	}
}*/

- (IBAction)cardKnownUnKnown
{
	FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
	card.isKnown = !card.isKnown ;
	[self updateCardDetails];
	[[AppDelegate_iPhone getDBAccess] setProficiency:((card.isKnown) ? 1 : 0) ForCardId:card.cardID];
}

- (void)updateNavBar
{
	if(_selectedCardIndex < 0)
		return;
    
	FlashCard* card = [_arrayOfCards objectAtIndex:_selectedCardIndex];
if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
{
       
    
	if(card.isBookMarked)
	{
		_favorite.hidden = NO;
		favImg.hidden = NO;
		[_toggleFavButton setImage:[UIImage imageNamed:@"notBookmarkSeven.png"] forState:UIControlStateNormal];
        //[_toggleFavButton setFrame:CGRectMake(140, 0, 30, 38)];
	}
	else
	{
		_favorite.hidden = YES;
		favImg.hidden = YES;
		[_toggleFavButton setImage:[UIImage imageNamed:@"bookmark_7.png"] forState:UIControlStateNormal];
          // [_toggleFavButton setFrame:CGRectMake(140, 0, 30, 38)];
	}
	
	if(card.isKnown)
	{
		knowDontKnowImg.hidden = NO;
		[_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"dnt_knw.png"] forState:UIControlStateNormal];
		[_know setImage:[UIImage imageNamed:@"know.png"]];
	}
	else
	{
		knowDontKnowImg.hidden = YES;
		[_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"know.png"] forState:UIControlStateNormal];
		[_know setImage: [UIImage imageNamed:@"dnt_knw.png"]];
	}
	
	
	if (card.cardID!=0 && [[AppDelegate_iPhone getDBAccess] isCommentOrNotesAvailable:card.cardID]) {
		[actionImg setImage:[UIImage imageNamed:@"window_icon.png"] forState:UIControlStateNormal];
	}else {
		[actionImg setImage:[UIImage imageNamed:@"window_green.png"] forState:UIControlStateNormal];
	}
}
    else
    {
        if(card.isBookMarked)
        {
            _favorite.hidden = NO;
            favImg.hidden = NO;
            [_toggleFavButton setImage:[UIImage imageNamed:@"Unmark.png"] forState:UIControlStateNormal];
        }
        else
        {
            _favorite.hidden = YES;
            favImg.hidden = YES;
            [_toggleFavButton setImage:[UIImage imageNamed:@"bookmark_6.png"] forState:UIControlStateNormal];
        }
        
        if(card.isKnown)
        {
            knowDontKnowImg.hidden = NO;
            [_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"dnt_knw.png"] forState:UIControlStateNormal];
            [_know setImage:[UIImage imageNamed:@"know.png"]];
        }
        else
        {
            knowDontKnowImg.hidden = YES;
            [_toggleKnowUnKnownButton setImage:[UIImage imageNamed:@"know.png"] forState:UIControlStateNormal];
            [_know setImage: [UIImage imageNamed:@"dnt_knw.png"]];
        }
        
        
        if (card.cardID!=0 && [[AppDelegate_iPhone getDBAccess] isCommentOrNotesAvailable:card.cardID]) {
            [actionImg setImage:[UIImage imageNamed:@"window_icon.png"] forState:UIControlStateNormal];
        }else {
            [actionImg setImage:[UIImage imageNamed:@"window_green.png"] forState:UIControlStateNormal];
        }
        
    }
	
}

- (void) updateFlashDetails
{
	if(_selectedCardIndex == 0)
	{
		_nextButton.enabled = YES;
		_prevButton.enabled = NO;
	}
	else if(_selectedCardIndex >= _arrayOfCards.count - 1)
	{
		_prevButton.enabled = YES;
		_nextButton.enabled = NO;
	}
	else
	{
		_nextButton.enabled = YES;
		_prevButton.enabled = YES;
	}

	[self updateNavBar];
	[self updateCardDetails];
	if(_selectedCardIndex < 0)
		return;
	
	self.title = [NSString stringWithFormat:@"%d of %d", _selectedCardIndex + 1, [_arrayOfCards count]];
    
}


- (void)hideLoading
{
	[_act stopAnimating];
}

/// Comment to remove swipe feature from the application
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
	_isDragging = YES;
	if([scrollView isKindOfClass:[UITableView class]] == NO)
	{
		if (_isDragging)
		{
			[NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(slidingAction:) userInfo:scrollView repeats:NO];
		}		
	}
}

- (void) slidingAction:(NSTimer*)timer
{
	UIScrollView* scrollView = [timer userInfo];
	_selectedCardIndex = scrollView.contentOffset.x / 320;
	_cardType = kCardTypeFront;
	[self updateFlashCard];	
	[self updateFlashDetails];
	_isDragging = NO;
}


-(void) showActionSheet{
	
	UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@""
															 delegate:self
													cancelButtonTitle:nil
											   destructiveButtonTitle:nil
													otherButtonTitles:nil];
	
	
	if ([AppDelegate_iPhone delegate].isVoiceNotesEnabled) {
		[actionSheet addButtonWithTitle:@"Voice Notes"];
	}
	
	if ([AppDelegate_iPhone delegate].isCommentsEnabled) {
		[actionSheet addButtonWithTitle:@"Comments"];
	}
	
	[actionSheet addButtonWithTitle:@"Cancel"];
	actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
	
	
	[actionSheet showInView:self.view];
	[actionSheet release]; 

}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	NSString *title=[actionSheet buttonTitleAtIndex:buttonIndex];
	
	if ([title isEqualToString:@"Voice Notes"]) {
		
		// Load Voice Notes View
		VoiceNotesViewController_iPhone *detailViewController = [[VoiceNotesViewController_iPhone alloc] initWithNibName:@"VoiceNotesView_iPhone" bundle:nil];
		FlashCard* card=[_arrayOfCards objectAtIndex:_selectedCardIndex];
		[detailViewController setFlashCardId:[card cardID]];
		[detailViewController setParent:self];
		[self.navigationController presentModalViewController:detailViewController animated:YES];
		[detailViewController release];
	
	}
	
	else if ([title isEqualToString:@"Comments"]) {
		
		//Load Comments View
		CommentsViewController_iPhone *detailViewController = [[CommentsViewController_iPhone alloc] initWithNibName:@"CommentsView_iPhone" bundle:nil];
		[detailViewController setFlashCardId:[[_arrayOfCards objectAtIndex:_selectedCardIndex] cardID]];
		[detailViewController setParent:self];
		[self.navigationController presentModalViewController:detailViewController animated:YES];
		[detailViewController release];
	
	}

	//[title release];
}

- (void)viewDidUnload {
[self setCustomToolBarBottom:nil];
[super viewDidUnload];
}
@end

