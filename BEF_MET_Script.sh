#!/bin/bash

# This file is the script that automates the plot generation
# and then emails them.
# It should be ran automatically every Monday at around 6am
# via a cronjob for my user

# Flush log
echo "" >> $SCRIPT_DIR/log.txt
date >> $SCRIPT_DIR/log.txt

# Load in .env file
if [ ! -f ".env" ]; then
    echo "No environment file found!" >> $SCRIPT_DIR/log.txt
    exit
fi
source .env

# Sometimes dropbox wont autostart
dropbox start >> $SCRIPT_DIR/log.txt
sleep 120 # Give dropbox enough time to finish syncing

# Generate the plots
echo "Generating plots..." >> $SCRIPT_DIR/log.txt
Rscript ${SCRIPT_DIR%%/}/BEFWeeklySummary.R "$DROPBOX_DIR" "$DROPBOX_DIR/plots/" \
    2>> $SCRIPT_DIR/log.txt

# Email the plots
echo "Sending email..." >> $SCRIPT_DIR/log.txt
mutt -s "BEF Weekly Summary for $(date --iso-8601)" \
	-a "${DROPBOX_DIR%%/}/plots/files_5HzData_count.png" \
	-a "${DROPBOX_DIR%%/}/plots/flux_soil_data.png" \
	-a "${DROPBOX_DIR%%/}/plots/met_data.png" \
	-c $CC_EMAIL1 \
	-c $CC_EMAIL2 \
	-c $CC_EMAIL3 \
	-c $CC_EMAIL4 \
	-c $CC_EMAIL5 \
	-- $PRIMARY_EMAIL < ${SCRIPT_DIR%%/}/email_template.txt

