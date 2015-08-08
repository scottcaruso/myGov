//
//  loadingScreenFacts.m
//  myGov
//
//  Created by Scott Caruso on 6/20/13.
//  Copyright (c) 2013 Scott Caruso. All rights reserved.
//

#import "loadingScreenFacts.h"

@implementation loadingScreenFacts

-(id)init
{
    facts = [NSArray arrayWithObjects:
             @"The U.S. congress is over 220 years old!",
             @"Because every state has two—and only two—Senators, each Senator represents a vastly different number of people. For example, each Senator from Wyoming represents 246,981 residents, whereas each Senator from California represents 18,378,333 constituents.",
             @"The word Senator is an ancient Roman term derived from the Latin senex, meaning old man.",
             @"The annual salary of a U.S. Senator is $174,000.",
             @"The U.S. Senate first met in New York City on March 4, 1789. It moved to Philadelphia in April 1790, and finally to the newly established city of Washington, D.C. in November 1800.",
             @"As per the U.S. Constitution, Senators were elected by each state legislature until the 17th Amendment, ratified in 1912, allowed for direct election by the voters in each state.",
             @"According to Senate rules, flowers are not permitted in the Senate chamber, except on the desk of a deceased sitting Senator on the day of his eulogy.",
             @"The oldest Senator ever was Strom Thurmond (Republican-SC) who was 100 years old when he retired in December 2002. ",
             @"The longest serving Senator ever is Robert C. Byrd (D-WV), who has served in the Senate continuously since January 3, 1959.",
             @"he first female senator was Rebecca Felton (D-GA), who was appointed in 1922. The first woman elected to the Senate was Hattie W. Caraway (D-Ark.), who was elected in 1932",
             @"The first—and so far—only father and son to serve in the Senate simultaneously were Henry Dodge of Wisconsin who served from 1848 to 1857, and Augustus Dodge of Iowa, who served from 1855 to 1858.",
             @"There are 535 voting Members of Congress; the House of Representatives has a membership of 435 and the Senate has a membership of 100.",
             @"Historically, an incumbent candidate wins re-election 90 percent of the time.",
             @"The House initiates impeachment cases, while the Senate decides impeachment cases.",
             @"The Congressional Record—the official record of the proceedings and debates of the House and Senate—was first printed on March 5, 1873.",
             @"Frederick A.C. Muhlenberg was named the first Speaker of the House  on April 1, 1789, the day the House organized itself during the First Federal Congress (1789–1791)",
             @"James Madison was the first U.S. President to have been a member of the House of Representatives first",
             @"In 1968, Shirley Chisolm (NY) became the first African-American woman elected to Congress.",
             @"On May 24, 1844, inventor Samuel Morse sent the first official telegraph from the Capitol to his partner in Baltimore, MD.",
             @"On January 3, 1947, the first live television broadcast from the House Chamber occurred during the opening session of the 80th Congress (1947–1949). ",
             @"During the Civil War, the Capitol building briefly was used as a bakery, hospital, and military barracks.",
             @"On December 10, 1824, the Marquis de Lafayette, the French general and Revolutionary War hero, became the first foreign dignitary to address the House of Representatives in its chamber. ",
             @"Originally a Capitol tradition, the annual Easter egg roll shifted to the White House when the House passed the Turf Protection Law on April 21, 1876, outlawing the use of the Capitol grounds for any activity which may damage the surrounding landscape. ",
             @"Since 1934, the Annual Message or State of the Union Address is delivered every January or February. President Lyndon B. Johnson gave the first evening State of the Union Address on January 4, 1965.",
             @"The record for the most flags flown over the Capitol was set on July 4, 1976. 10,471 flags were flown over the Capitol to celebrate America’s Bicentennial.",
             nil];
    return self;
}

-(NSArray*)returnArrayOfFacts
{
    return facts;
}

@end
