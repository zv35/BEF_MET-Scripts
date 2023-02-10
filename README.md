# BEF_MET R Scripts
Scripts for processing BEF meterological data

## Usage
Note that if there is spaces in the path, a backspace (for MacOS/Linux) must be affixed otherwise it will interprit it as seprate paths. Pressing the tab key while typing out the path should auto-complete this.

If you want to output the plots to a different directory from the data directory, just add it as a second argument.

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
