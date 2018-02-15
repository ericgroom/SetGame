# SetGame
An iOS implementation of [Set](https://en.wikipedia.org/wiki/Set_(game)) created as a part of completing Stanford's CS 193P course in iOS 11

## Features:
  1. Plays a game of Set according to the rules listed on Wikipedia
  2. Custom drawing of cards and card faces using Core Graphics
  3. Implement animations via UIViewPropertyAnimator's and UIView transitions
  
## Possible Future Improvements
  1. Implement a way to keep high scores and share them among friends
  2. In most games, you aren't able to completely clear the board so find a way to end the game:
    a) One solution could be analyzing the board and ending the game when there are no more sets available. I don't like this solution because the the last few matches are usually quite hard and ending the game like this would let the user know if there is another set or not.
    b) Allow the user to end the game whenever they feel there is no set left on the board. I like this solution better but the UX doesn't feel great so I remain undecided for the moment.
  3. Improve the appearance of the UI
