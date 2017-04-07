#!/bin/bash
##########################################################################
#                                                                        #
# NETHINKS OpenNMS Docker environment                                    #
# OpenNMS Container                                                      #
# support.sh                                                             #
#                                                                        #
# support@nethinks.com                                                   #
#                                                                        #
##########################################################################

# create support data
ETC_ACTIVE='/data/container/etc'
ETC_ORIG='/data/ref/etc'
ETC_DIFF='/data/container/support/etc_diff'

rm -Rf "${ETC_DIFF}"/*

# diff between active and orig dirctory
changed_files=`diff --brief -Nr ${ETC_ACTIVE} ${ETC_ORIG} | cut -d ' ' -f 2`

for changed_file in $changed_files;
do
  changed_file_new_name=`echo $changed_file | sed "s#${ETC_ACTIVE}/##g"`
  target_file_name="${ETC_DIFF}/$changed_file_new_name"
  target_file_dir=`dirname $target_file_name`
  # only copy if the file exists
  if [ -f $changed_file ]
  then
      mkdir -p $target_file_dir
      cp $changed_file $target_file_name
  fi
done
