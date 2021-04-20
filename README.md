CFA-Insta AD2020 MinesSweeper

This program is written in elm, it's a project for an educationnal purpose in order to learn and play around functional programming.

Running the program:

	-To run this program on your server or computer,you 'll need firts of all to install:

		node.js -> https://nodejs.org/en/download/
		elm language (0.19.1) -> https://guide.elm-lang.org/install/elm.html

	Once set up, you should be able to use elm 
	-From the containing directory, open the terminal and execute the following command: 

        ./run.sh 

        or

		npm install
		npm start
 
	A link to the localHost will be given to access the game.

Playing the game, quickly:
	
	-Rules are simple -> 
		Finding the cases which hosts mines without clicking on them.
		You lose when you click on a case that hosts a mine.
		You win when you hav found all the cases that are not fullfilled by a mine.
		When you find a mine, simply right-click to put a flag on it, this case is no longer clickable,
		unless you remove the flag with the same action

	An ATH is provided to give you the number of second taken till the end of the game (right corner) and the number of case clicked (left corner).
	A reset button is hidden under the kind smiley, you can reload a new grid at any moment to restart a game !
	
	