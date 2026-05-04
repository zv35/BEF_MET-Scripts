# BEF_MET R Scripts
Scripts for processing BEF meteorological data.

## Setup

### Dropbox
For these scripts to run properly, Dropbox must first be set up. To check if the daemon is installed, use the command `dropbox status`, which will print some info about the client if it is running.

If the Dropbox command is not found, please refer to the [instructions on Dropbox's website for installing the daemon](https://www.dropbox.com/install-linux).

Additionally, ensure that Dropbox is running, logged in, starts on boot (see `dropbox autostart`), and is up to date. If all is working, you should see a Dropbox folder in your home directory.

### Environment
You must copy the environment template file from `.env.template` to `.env` for the script to run correctly.

After copying the template, read through the environment file and change all the variables to reflect your system. *Note that if there are spaces in the path, a backspace (for MacOS/Linux) must be affixed*; otherwise, bash will interpret the input as separate paths. Pressing the tab key while typing out the path should auto-complete this.

When adding the recipient addresses into the .env file, make sure that PRIMARY_EMAIL is set to a valid address before adding your CC recipients. If there are extra recipients in the .env file, leave them as null@example.com

## Crontab
The command `crontab -e` will open your crontab with your preferred EDITOR. Simply add the following line to the bottom. Please make sure that the path reflects the actual path of the script.
```
0 10 * * 1 /home/user/path/to/script/BEF_MET/BEF_MET_Script.sh
```

## Generating Plots Manually
Remember, if there are spaces in the path, a backspace must be affixed; otherwise, bash will interpret the input as separate paths. Pressing the tab key while typing out the path should auto-complete this.

If you want to output the plots to a different directory from the data directory, just add it as a second argument.

The `BEF_MET_Script.sh` file should *not* be ran directly. Instead, create a cronjob to have it run regularly.

## Examples
To read from the Dropbox and write to the plot directory (within the data directory):
```bash
Rscript ./BEFWeeklySummary.R /home/[user]/Dropbox/BEF\ Data\ 2012/
```

To output to a separate plot directory:
```bash
Rscript ./BEFWeeklySummary.R /home/[user]/Dropbox/BEF\ Data\ 2012/ /home/[user]/Documents/plots/
```

## Troubleshooting
When the `BEF_MET_Script.sh` script is run, a log that includes error messages is generated in the same directory as the script named `log.txt`. This text file can contain important information to help with troubleshooting. If running `BEFWeeklySummary.R` directly, any error messages may be found in the terminal.

**The first thing to check is whether or not Dropbox is running and syncing files!** Here are some useful commands for the Dropbox client:
```bash
dropbox status    # Prints the status of the Dropbox client
dropbox start     # Starts the client, if its not already running
dropbox autostart # Starts Dropbox on boot
dropbox update    # Important! Dropbox will not work if it is not updated!
```

### Plots are out of date or blank

Make sure that the DropBox daemon is up to date and running. This is the result if there isn't any data from the past week.

### NULL is printed in the terminal when running the script manually

This shouldn't be an issue on its own. If there are other errors, then there may be a bigger issue.

### Error message: `Stopped early on line [number]. Expected 29 fields but found [number]`

This error is typically caused by erroneously formatted lines in the file `Bartlett 21x Final.csv`. Check the line specified in the log. Usually there is a line that is too long. Fix the issue in the source file and re-run the script.

### Error message: `need finite 'ylim' values`

This can be caused by improperly formatted lines or missing data. Check the source CSV files to confirm that data is updating and formatted correctly.

### One plot is correct but the other is blank

This can be caused by the source computer not uploading correctly. This means it is most likely not a problem with this script.
