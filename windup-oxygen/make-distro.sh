# Prepare the latest update site zip from windup eclipse nightly job
if [ ! -f repository.zip ];
then
	# download zipped archived results
	curl http://jenkins.hosts.mwqe.eng.bos.redhat.com/hudson/view/Windup/job/windup-eclipse-plugin-NIGHTLY/lastSuccessfulBuild/artifact/**/repository.zip/*zip*/repository.zip -o repository.zip;
   # unzip it and get zipped update site
    unzip -jo repository.zip;
    # unzip update site as local repository directory
    unzip -q repository.zip -d repository;
fi;

# just in case p2 director executable is not already unzipped
if [ ! -f ../director/director ]; then unzip -q ../director_latest.zip -d .. ; fi;

export LOCAL_SITE=`pwd`/repository
if [ ! -d target ];
then
    echo "Creating target for build";
    mkdir target;
fi;

# replace token for local update site - IMPORTANT this needs to be absolute path!
sed -i "s,LOCAL_UPDATE_SITE,$LOCAL_SITE," oxygen-windup-plugin.conf

# run eclipse p2 wrapper to collect all features
# IMPORTANT all paths as arguments need to be absolute paths!
../eclipse-builder.sh --p2command ../director/director \
--platform linux \
--platform macosx \
--platform windows \
--destination `pwd`/target \
--name eclipse-windup-ide oxygen-java.conf oxygen-windup-plugin.conf

# replace default 512m with 2048m
find target -name eclipse.ini -exec sed -i "s/^\(-Xmx\)512/\12048/" {} \;

#************************ Archive installations into compressed files ************
if [ $? -eq 0 ]
then
	cd target;
    for directory in `ls -w1`;
    do 
        echo "found $directory for archive";
        zip -qr $directory.zip $directory ;
    done;
fi;
