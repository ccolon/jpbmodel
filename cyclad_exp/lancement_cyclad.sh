#!/bin/sh
command1="matlab -nodisplay -nosplash -nodesktop -r \"run('/user/ccolon/Dropbox/PhD/4. models/jpb/model/experiments/param_n2c1.m'); exit;\""
command2="matlab -nodisplay -nosplash -nodesktop -r \"run('/user/ccolon/Dropbox/PhD/4. models/jpb/model/experiments/param_n10c3.m'); exit;\""
command3="matlab -nodisplay -nosplash -nodesktop -r \"run('/user/ccolon/Dropbox/PhD/4. models/jpb/model/experiments/param_n100c4.m'); exit;\""
echo $command1 | at now
echo $command2 | at now
echo $command3 | at now

