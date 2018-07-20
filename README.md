# bufferedHPGL
HPGL that reads the printers buffer size and delays sending another command if the buffer free space is below a threshold.

Speeds up printing by a huge margin.  Instead of waiting 10-100 milliseconds between each print command we properly wait until the printers buffer has enough room for the next command.

Its not perfect though.  It seems to not properly wait maybe once every 40,000 commands or so.  This is largely only an issue if your plot has curved lines that aren't using arc commands.

# Bugs

Randomly commands get sent too quickly.  Occurs infrequently but i wouldn't plot using expensive materials using this code yet.

Currently only supports files where there is one HPGL command per line.

Sends the entire command found on a line to the printer at once.  This is not ideal if the command is a comma separated list of many PD points which is how inkscape exports its files.

# TODO

Fix the bug where we randomly send commands too quickly.

Split files that are only a few lines into their commands by splitting on ;'s.

Intelligently split long single commands (PD 1,0,2,0,3,0,4,0,5,0) into multiple commands.

More easily allow users to define their plotter dimensions.

Export the application with a gui ( this will never happen )