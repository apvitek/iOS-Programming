//
//  ViewController.m
//  GuessingGame
//
//  Created by Andrea Borghi on 10/22/14.
//  Copyright (c) 2014 Developers Guild. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) UIAlertController *alertController;
@property (strong, nonatomic) UIAlertController *instructionsAlertController;
@property (nonatomic, strong) CollectionViewController *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *lowOrHighImage;
@property (nonatomic, strong) UILabel * labelAboveKeyboard;
@property (nonatomic, strong) NSMutableArray * numbersAlreadyGuessed;

@property int guesses;
@property int numberToGuess;
@property BOOL gameOver;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.collectionView) {
        self.collectionView = [self.childViewControllers lastObject];
    }
    
    [self getKeyboardShownNotification];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(submitAnswerTap:)];
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer * swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    [self presentViewController:self.instructionsAlertController animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)showKeyboard {
    [self.textField becomeFirstResponder];
}

- (NSMutableArray *)numbersAlreadyGuessed {
    if (!_numbersAlreadyGuessed) {
        self.numbersAlreadyGuessed = [[NSMutableArray alloc] init];
    }
    
    return _numbersAlreadyGuessed;
}

- (void)getKeyboardShownNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLabelAboveKeyboard:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLabelAboveKeyboard:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)updateLabelAboveKeyboard:(NSNotification*)notification {
    if ([self.textField isFirstResponder]) {
        [_labelAboveKeyboard removeFromSuperview];
        _labelAboveKeyboard = nil;
        [self showLabelAboveKeyboard:notification];
    }
}

- (void)showLabelAboveKeyboard:(NSNotification*)notification {
    int textSize = 20;
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    int labelSize = self.view.bounds.size.width;
    
    if (!_labelAboveKeyboard) {
        _labelAboveKeyboard = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - keyboardFrameBeginRect.size.height - textSize, labelSize, textSize)];
        _labelAboveKeyboard.backgroundColor = [UIColor whiteColor]; ////
        _labelAboveKeyboard.textAlignment = NSTextAlignmentCenter;
        _labelAboveKeyboard.text = @"Tap anywhere to send your answer.";
        _labelAboveKeyboard.textColor = [UIColor blackColor];
        [_labelAboveKeyboard setFont:[UIFont systemFontOfSize:textSize]];
    }
    _labelAboveKeyboard.alpha = 0.0;
    
    [self.view addSubview:_labelAboveKeyboard];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:0 animations:^{
        _labelAboveKeyboard.alpha = 1.0;
    } completion:nil];
}

- (void)hideLabelAboveKeyboard {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:0 animations:^{
        _labelAboveKeyboard.alpha = 0.0;
    } completion:^(BOOL finished) {
        _labelAboveKeyboard = nil;
    }];
}

- (IBAction)submitAnswer:(id)sender {
    [self hideLabelAboveKeyboard];
    
    int possibleGuess = (int)[self.textField.text integerValue];
    
    if ([self isNumberAlreadyGuesses:[NSNumber numberWithInt:possibleGuess]]) {
        [self displayOverheadMessageWithString:@"Already entered!"];
    } else {
        if (possibleGuess == 0) {
            [self displayOverheadMessageWithString:@"Nothing entered!"];
        } else if (possibleGuess > self.numberToGuess) {
            [self displayOverheadMessageWithString:@"Too high!"];
            self.lowOrHighImage.image = [UIImage imageNamed:@"high"];
            ++self.guesses;
            [self.numbersAlreadyGuessed addObject:[NSNumber numberWithInt:possibleGuess]];
        } else if (possibleGuess < self.numberToGuess) {
            [self displayOverheadMessageWithString:@"Too low!"];
            self.lowOrHighImage.image = [UIImage imageNamed:@"low"];
            [self.numbersAlreadyGuessed addObject:[NSNumber numberWithInt:possibleGuess]];
            ++self.guesses;
        } else {
            [self displayOverheadMessageWithString:@"YOU WON!"];
            self.guesses = 0;
            self.gameOver = true;
            self.lowOrHighImage.image = [UIImage imageNamed:@"hand"];
            [self presentViewController:self.alertController animated:YES completion:nil];
        }
        
        [self animateArrowPicture];
        
        [self.collectionView highlightNumberInCollectionView:[NSNumber numberWithInt:possibleGuess]];
    }
    
    [self clearInput];
    
    [self.textField resignFirstResponder];
}

- (int)generateNumber {
    int randomNumber = arc4random() % 100 + 1;
    NSLog(@"%i", randomNumber);
    return randomNumber;
}

- (void)clearInput {
    self.textField.text = @"";
}

- (void)generateNewGame {
    self.numberToGuess = [self generateNumber];
    self.gameOver = false;
    [self clearInput];
    [self.numbersAlreadyGuessed removeAllObjects];
    [self.collectionView resetView];
}

- (UIAlertController *)alertController {
    if (!_alertController) {
        self.alertController = [UIAlertController alertControllerWithTitle:@"Game over!" message:@"Would you like to play again?" preferredStyle:UIAlertControllerStyleAlert];
        [self.alertController addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self generateNewGame];
        }]];
        [self.alertController addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self.textField resignFirstResponder];
        }]];
    }
    
    return _alertController;
}

- (UIAlertController *)instructionsAlertController {
    if (!_instructionsAlertController) {
        self.instructionsAlertController = [UIAlertController alertControllerWithTitle:@"Welcome!" message:@"Try to guess a number from 1 to 100. The game will warn you if your guess is too high or too low. Tap anywhere to send your entered number." preferredStyle:UIAlertControllerStyleAlert];
        [self.instructionsAlertController addAction:[UIAlertAction actionWithTitle:@"Got it!" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self generateNewGame];
        }]];
    }
    
    return _instructionsAlertController;
}

- (void)displayOverheadMessageWithString:(NSString *)string {
    int labelSize = self.view.bounds.size.width;
    
    UILabel * messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - (labelSize / 2), self.view.center.y - (labelSize / 2), labelSize, labelSize)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.text = string;
    messageLabel.textColor = [UIColor blueColor];
    [messageLabel setFont:[UIFont systemFontOfSize:labelSize / 4]];
    messageLabel.numberOfLines = 2;
    
    [self.view addSubview:messageLabel];
    
    messageLabel.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:0 animations:^{
        messageLabel.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:0 animations:^{
            messageLabel.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height + messageLabel.frame.size.height);
        } completion:^(BOOL finished) {
            [messageLabel removeFromSuperview];
        }];
    }];
}

- (void)submitAnswerTap:(UITapGestureRecognizer *) sender
{
    if ([self.textField isFirstResponder]) {
        [self submitAnswer:sender];
        [self.textField resignFirstResponder];
    }
}

- (void)animateArrowPicture {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:0 animations:^{
        self.lowOrHighImage.transform = CGAffineTransformMakeScale(1.3,1.3);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10 options:0 animations:^{
            self.lowOrHighImage.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }];
}

- (BOOL)isNumberAlreadyGuesses:(NSNumber *)number {
    return [self.numbersAlreadyGuessed containsObject:number];
}

@end