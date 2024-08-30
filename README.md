# BEF_MET R Scripts
Scripts for processing BEF meterological data.

## Usage
Note that if there are spaces in the path, a backspace (for MacOS/Linux) must be affixed; otherwise, bash will interpret the input as separate paths. Pressing the tab key while typing out the path should auto-complete this.

If you want to output the plots to a different directory from the data directory, just add it as a second argument.

The `BEF_MET_Script.sh` file should not be run directly.

## Examples
To read from the Dropbox and write to the plot directory (within the data directory):
```bash
Rscript ./BEFWeeklySummary.R /home/[user]/Dropbox/BEF\ Data\ 2012/
```

To output to a separate plot directory:
```bash
Rscript ./BEFWeeklySummary.R /home/[user]/Dropbox/BEF\ Data\ 2012/ /home/[user]/Documents/plots/
```

## Crontab
crontab -e in Terminal to automate the script at 6 AM on Mondays
```bash
crontab -e Rscript '/Users/jml684/Dropbox (NAU)/BEF Met Data 2012/BEFWeeklySummary.R'
```

In the crontab:
```
0 6 * * 1 Rscript '/Users/jml684/Dropbox (NAU)/BEF Met Data 2012/BEFWeeklySummary.R'
```

## Troubleshooting
When the `BEF_MET_Script.sh` script is run, a log that includes error messages is generated in the same directory as the script named `log.txt`. This text file can contain important information to help with troubleshooting. If running `BEFWeeklySummary.R` directly, any error messages may be found in the terminal.

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
