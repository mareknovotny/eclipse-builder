if [ ! $PLATFORMS -z ];
then
    export PLATFORMS="--platform linux"
fi;

# run eclipse p2 wrapper to collect all features
# IMPORTANT all paths as arguments need to be absolute paths!
./eclipse-builder.sh --p2command ./director/director \
$PLATFORMS \
--destination `pwd`/target \
--name eclipse-windup-ide neon-java.conf windup-plugin.conf
