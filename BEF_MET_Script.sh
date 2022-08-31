#!/bin/bash

# This file is the script that automates the plot generation
# and then emails them.
# It should be ran automatically every Monday at around 6am
# via a cronjob for my user

# Paths to the mounted dropbox drive and this script
SCRIPT_DIR=/home/zakv/Documents/BEF_MET/
DROPBOX_DIR=/home/zakv/Dropbox/BEF\ Met\ Data\ 2012/

echo "" >> $SCRIPT_DIR/log.txt
date >> $SCRIPT_DIR/log.txt

# Sometimes dropbox wont autostart
dropbox start >> $SCRIPT_DIR/log.txt

# Generate the plots
cd "$DROPBOX_DIR"
echo "Generating Plots..." >> $SCRIPT_DIR/log.txt
Rscript BEFWeeklySummary.R 2>> $SCRIPT_DIR/log.txt

# Email the plots
cd $SCRIPT_DIR
echo "Sending Email..." >> $SCRIPT_DIR/log.txt
mutt -s "BEF Weekly Summary for $(date +'%D')" \
	-a "${DROPBOX_DIR%%/}/plots/files_5HzData_count.png" \
	-a "${DROPBOX_DIR%%/}/plots/flux_soil_data.png" \
	-a "${DROPBOX_DIR%%/}/plots/met_data.png" \
	-c zgv4@nau.edu \
	-c ddb348@nau.edu \
	-- Andrew.Richardson@nau.edu < ${SCRIPT_DIR%%/}/email_template.txt
