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
sleep 120 # Give dropbox enough time to sync

# Pre-process data
#echo "Running pre-process checks..." >> $SCRIPT_DIR/log.txt

# Generate the plots
echo "Generating plots..." >> $SCRIPT_DIR/log.txt
Rscript ${SCRIPT_DIR%%/}/BEFWeeklySummary.R "$DROPBOX_DIR" "$DROPBOX_DIR/plots/" \
    2>> $SCRIPT_DIR/log.txt

# Email the plots
echo "Sending email..." >> $SCRIPT_DIR/log.txt
mutt -s "BEF Weekly Summary for $(date +'%D')" \
	-a "${DROPBOX_DIR%%/}/plots/files_5HzData_count.png" \
	-a "${DROPBOX_DIR%%/}/plots/flux_soil_data.png" \
	-a "${DROPBOX_DIR%%/}/plots/met_data.png" \
	-c zgv4@nau.edu \
	-c ddb348@nau.edu \
	-- Andrew.Richardson@nau.edu < ${SCRIPT_DIR%%/}/email_template.txt

