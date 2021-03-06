//
//  ViewController.m
//  Frarkle
//
//  Created by Blake Mitchell on 5/21/14.
//  Copyright (c) 2014 Blake Mitchell. All rights reserved.
//

#import "ViewController.h"
#import "DieLabel.h"

@interface ViewController () <DieLabelDelegate>

@property (nonatomic, strong)IBOutlet DieLabel *die1;
@property (nonatomic, strong)IBOutlet DieLabel *die2;
@property (nonatomic, strong)IBOutlet DieLabel *die3;
@property (nonatomic, strong)IBOutlet DieLabel *die4;
@property (nonatomic, strong)IBOutlet DieLabel *die5;
@property (nonatomic, strong)IBOutlet DieLabel *die6;
@property NSArray *labelArray;
@property NSMutableArray *selectedDieArrayAfterRoll;
@property (nonatomic, strong)IBOutlet UILabel *userScore;
@property NSString *whichPlayer;
@property (nonatomic, strong)IBOutlet UILabel *whichPlayerLabel;
@property (nonatomic, strong)IBOutlet UILabel *playerOneScoreLabel;
@property (nonatomic, strong)IBOutlet UILabel *playerTwoScoreLabel;
@property (nonatomic, strong)IBOutlet UIButton *cashOutButton;
@property NSNumber *playerOneScore;
@property NSNumber *playerTwoScore;
@property NSNumber * potentialScoreNumber;
@property (strong, nonatomic) IBOutlet UILabel *potentialScoreLabel;
@property (strong, nonatomic) NSMutableArray *rolledDiceArray;
@property (strong, nonatomic) IBOutlet UIButton *rollButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.labelArray = [NSArray arrayWithObjects:self.die1,
                       self.die2,
                       self.die3,
                       self.die4,
                       self.die5,
                       self.die6,
                       nil];

    self.selectedDieArrayAfterRoll = [[NSMutableArray alloc]init];
    
    self.die1.delegate = self;
    self.die2.delegate = self;
    self.die3.delegate = self;
    self.die4.delegate = self;
    self.die5.delegate = self;
    self.die6.delegate = self;

    for (DieLabel *die in self.labelArray) {
        [die roll];
        self.playerOneScore = [NSNumber numberWithInt:0];
        self.playerTwoScore = [NSNumber numberWithInt:0];
    }

    [self.cashOutButton setEnabled:NO];

    self.potentialScoreNumber = 0;

    for (DieLabel *eachDieLabel in self.labelArray) {
        eachDieLabel.alpha = 0;
    }

    self.rolledDiceArray = [[NSMutableArray alloc]init];
}

- (IBAction)onRollButtonPressed:(UIButton*) sender
{

    if (self.cashOutButton.enabled == NO) {
        [self.cashOutButton setEnabled:YES];
    }

//    if (self.selectedDieArrayAfterRoll.count == 6) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Turn Over"
//                                                       message:@"Switch Player"
//                                                      delegate:nil
//                                             cancelButtonTitle:@"OK"
//                                             otherButtonTitles: nil];
//        [alert show];
//        [self whichPlayersTurn];
//        [self resetBoard];
//    }

    for (DieLabel *eachDieLabel in self.labelArray) {

        eachDieLabel.alpha = 1.0;

        if (eachDieLabel.isSelected == NO) {
            NSLog(@"not selected");
            [self.rolledDiceArray addObject:eachDieLabel];
        }

        if (![self.selectedDieArrayAfterRoll containsObject:eachDieLabel]) {
            [eachDieLabel roll];
        }

    } // end for loop

    NSLog(@"rolledDiceArray is %i",self.rolledDiceArray.count);

    if ([self didFarkle:self.rolledDiceArray]) {
        self.whichPlayerLabel.text = @"OOPS! YOU JUST FARKLED!";
        self.whichPlayerLabel.backgroundColor = [UIColor redColor];

        self.potentialScoreNumber = [NSNumber numberWithInt:0];
        self.potentialScoreLabel.text = @"0";
        [sender setEnabled:NO];
    }

    [self.rolledDiceArray removeAllObjects];

}

- (void)didChooseDie:(DieLabel *)dieLabel
{
    dieLabel.isSelected = YES;
    [self.selectedDieArrayAfterRoll addObject:dieLabel];
    NSNumber *score = [self returnScore:self.selectedDieArrayAfterRoll exisitingScore:self.playerOneScore];
    self.potentialScoreNumber = score;
    self.potentialScoreLabel.text = [NSString stringWithFormat:@"Potential Score: %i",[self.potentialScoreNumber intValue]];

    if ([self didCompleteBoard:self.labelArray]) {
        self.whichPlayerLabel.text = @"NICE MOVES!";
        self.whichPlayerLabel.backgroundColor = [UIColor greenColor];
        [self.rollButton setEnabled:NO];
    }
}

- (void)whichPlayersTurn
{
    self.editing = ! self.editing;

    if (!self.editing) {
        [self.selectedDieArrayAfterRoll removeAllObjects];
        self.whichPlayerLabel.text = @"Player 1's Turn";

    } else {
        [self.selectedDieArrayAfterRoll removeAllObjects];
        self.whichPlayerLabel.text = @"Player 2's Turn";
    }
}

- (IBAction)onCashOutButton:(id)sender
{
    [self.rollButton setEnabled:YES];
    self.whichPlayerLabel.backgroundColor = [UIColor whiteColor];

    if (!self.editing) {

        int addedCashedInScore = self.playerOneScore.intValue + self.potentialScoreNumber.intValue;
        self.playerOneScore = [NSNumber numberWithInt:addedCashedInScore];
        self.playerOneScoreLabel.text = [NSString stringWithFormat:@"%d", self.playerOneScore.intValue];
        [self whichPlayersTurn];
        [self resetBoard];

    } else {
        int addedCashedInScore = self.playerTwoScore.intValue + self.potentialScoreNumber.intValue;
        self.playerTwoScore = [NSNumber numberWithInt:addedCashedInScore];
        self.playerTwoScoreLabel.text = [NSString stringWithFormat:@"%d", self.playerTwoScore.intValue];
        [self whichPlayersTurn];
        [self resetBoard];
    }

//    if (self.playerOneScore.intValue > 1000) {
//        self.whichPlayerLabel.text = @"PLAYER 1 WINS!";
//        self.whichPlayerLabel.backgroundColor = [UIColor blueColor];
//    }
//
//    if (self.playerTwoScore.intValue > 1000) {
//        self.whichPlayerLabel.text = @"PLAYER 2 WINS!";
//        self.whichPlayerLabel.backgroundColor = [UIColor blueColor];
//    }


}

#pragma mark - Helper Methods

- (void)resetBoard
{
    for (DieLabel *eachDieLabel in self.labelArray) {
        eachDieLabel.backgroundColor = [UIColor greenColor];
        eachDieLabel.alpha = 0;
        eachDieLabel.isSelected = NO;
    }
    [self.cashOutButton setEnabled:NO];
    self.potentialScoreNumber = [NSNumber numberWithInt:0];
    self.potentialScoreLabel.text = @"";

}


- (NSNumber *)returnScore: (NSMutableArray *)array exisitingScore:(NSNumber *)number
{
    int score = 0;

    for (int i = 0;  i < 7; i++) {

        NSString *predicateCondition = [NSString stringWithFormat:@"value = %i", i];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateCondition];
        NSArray *diceWithCurrentNumber = [array filteredArrayUsingPredicate:predicate];

        if (i == 1 && diceWithCurrentNumber.count == 3) {
            score += 1000;
        }else if (i == 1 && diceWithCurrentNumber.count < 3){
            score += diceWithCurrentNumber.count * 100;
        }else if (i == 1 && diceWithCurrentNumber.count > 3){
            score += 1000;
            score += (diceWithCurrentNumber.count - 3) * 100;
        }
        else if (i == 5 && diceWithCurrentNumber.count == 3) {
            score += 500;
        }else if (i == 5 && diceWithCurrentNumber.count < 3){
            score += diceWithCurrentNumber.count * 50;
        }else if (i == 5 && diceWithCurrentNumber.count > 3){
            score += 500;
            score += (diceWithCurrentNumber.count - 3) * 50;
        }
        else if (diceWithCurrentNumber.count == 3) {
            score += i * 100;
        }

    }

    int calculatedNewScore = score - [number intValue];
    NSLog(@"calculatedNewScore is %d",calculatedNewScore);

    if (calculatedNewScore == 0) {

        [self whichPlayersTurn];
    }
    else {
        NSNumber *newScore = [NSNumber numberWithInt:score];
        return newScore;
    }
    return nil;
}

- (BOOL) didFarkle:(NSMutableArray *) rolledDiceArray {

    NSLog(@"rolledDiceArray count is %i",rolledDiceArray.count);

    for (int i = 0;  i < 7; i++) {

        NSString *predicateCondition = [NSString stringWithFormat:@"value = %i", i];

        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateCondition];
        NSArray *diceWithCurrentNumber = [rolledDiceArray filteredArrayUsingPredicate:predicate];

        NSLog(@"diceWithCurrentNumber count is %i",diceWithCurrentNumber.count);

        if (i == 1 && diceWithCurrentNumber.count > 0) {
            return NO;
        }else if (i == 5 && diceWithCurrentNumber.count > 0){
            return NO;
        }
        else if (diceWithCurrentNumber.count > 2) {
            return NO;
        }
    }
    return YES;
}

- (BOOL) didCompleteBoard:(NSArray *) allDiceArray{

    NSMutableArray* arrayOfSelectedDice = [[NSMutableArray alloc]init];

    for (DieLabel *eachDieLabel in allDiceArray) {
        if (eachDieLabel.isSelected) {
            [arrayOfSelectedDice addObject:eachDieLabel];
        }
    }

    if (arrayOfSelectedDice.count == 6) {
        return YES;
    }

    return NO;
}

@end
