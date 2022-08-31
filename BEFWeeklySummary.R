#crontab -e in Terminal to automate the script at 6 AM on Mondays
#crontab -e Rscript '/Users/jml684/Dropbox (NAU)/BEF Met Data 2012/BEFWeeklySummary.R'
#0 6 * * 1 Rscript '/Users/jml684/Dropbox (NAU)/BEF Met Data 2012/BEFWeeklySummary.R'


# IMPORTANT: If running on a different system,
# make sure that these directories are correct!
# TODO use a different method for selecting directories...

# path to the folder contains the data
input_dir <- '/home/zakv/Dropbox/BEF Met Data 2012/'
# path to put the outputs
output_dir <- '/home/zakv/Dropbox/BEF Met Data 2012/plots/'

#create if not exist
dir.create(output_dir, showWarnings = FALSE)

#load required libraries
if(!require(data.table)) {
    install.packages('data.table')
    library(data.table)
}

# today's date
today <- Sys.Date()

# date range to plot
# date_range <- today - c(33:26)
# date_range <- today - c(27:20)
date_range <- today - c(7:0) # Past 7 Days

# counting files in 5Hz Directory
dir_5HzData <- paste0(input_dir, '5HzData')

files_5HzData <- dir(dir_5HzData, full.names = TRUE)

files_5HzData_info <- file.info(files_5HzData)
files_5HzData_info <- setDT(files_5HzData_info)

files_5HzData_count <- files_5HzData_info[,
                                          .(count = .N),
                                          .(date  = as.Date(mtime))]

png(paste0(output_dir, 'files_5HzData_count.png'),
    width = 8, height = 5, units = 'in', res = 300)
plot(files_5HzData_count[date  %in% date_range, ],
     xlim = range(date_range),
     ylim = c(0, 5),
     ylab = 'Daily Count',
     type = 'l')
mtext('Number of 5Hz Files', line = 1)
dev.off()


# flux and soil data
flux_soil_data <- fread(paste0(input_dir, 'FLUX+SOIL_halfhour.csv'), skip = 1)
flux_soil_data <- flux_soil_data[-(1:2), .(TIMESTAMP = as.POSIXct(TIMESTAMP),
                                           CO2_Avg = as.numeric(CO2_Avg),
                                           H2O_Avg = as.numeric(H2O_Avg),
                                           T_Avg = as.numeric(T_Avg),
                                           U_Avg = as.numeric(U_Avg),
                                           V_Avg = as.numeric(V_Avg),
                                           W_Avg = as.numeric(W_Avg))]

png(paste0(output_dir, 'flux_soil_data.png'), width = 6, height = 7, units = 'in', res = 300)

par(mfcol = c(3,2), mar = c(3,4,1,2))

flux_soil_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, CO2_Avg, col = "#FFCC00", type = 'l', ylab = 'CO2 (ppm)', xaxt = "n")]
axis.POSIXct(1, date_range, format = "%d %b")
flux_soil_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, H2O_Avg, col = "#3399FF", type = 'l', ylab = 'Water Vapor (ppt)', xaxt = "n")]
axis.POSIXct(1, date_range, format = "%d %b")
flux_soil_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, T_Avg, col = "#CC0000", type = 'l', ylim=c(10,35), ylab = 'Temperature (°C)', xaxt = "n")]
axis.POSIXct(1, date_range, format = "%d %b")
flux_soil_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, U_Avg, col = "#FF6600", type = 'l', ylim=c(-6,6), ylab = 'Wind Speed, u (m/s)', xaxt = "n")]
axis.POSIXct(1, date_range, format = "%d %b")
flux_soil_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, V_Avg, col = "#66CC66", type = 'l', ylim=c(-6,6), ylab = 'Wind Speed, v (m/s)', xaxt = "n")]
axis.POSIXct(1, date_range, format = "%d %b")
flux_soil_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, W_Avg, col="#003366", type = 'l', ylim=c(-1,1), ylab = 'Wind Speed, w (m/s)', xaxt = "n")]
axis.POSIXct(1, date_range, format = "%d %b")

dev.off()




# met data
# Read in csv
met_data <- fread(paste0(input_dir, 'MET 21X_final_storage_1.csv'), skip = 1)
# Correct the date
met_data[V3==2400, V2:=V2+1]
met_data[V3==2400, V3:=0]

met_data <- met_data[, .(TIMESTAMP = as.POSIXct(sprintf('%s %02d:%02d:00', as.Date('2021-12-31')+V2, floor(V3/100), V3%%100)),
                         BattV = V4,
                         TairPlat = V7,
                         TairHMP = V8,
                         PPFD1 = V15,
                         PPFD2 = V17,
                         RH = V12,
                         Tsoil1 = V10,
                         Tsoil2 = V11,
                         Kipp1 = V20,
                         Kipp2 = V21)]

png(paste0(output_dir, 'met_data.png'), width = 6, height = 7, units = 'in', res = 300)

par(mfcol = c(3,2), mar = c(3,4,1,2))
#Plot tips
#mar: margin from bottom, left, top, right for each panel
#col = ‘#ff0000'
#lty= 2 for dashed
#lty= 1 for solid line
#col= ‘#ff000080' the 80 is half way to ff for full opacity
#lwd= 1 for line width

met_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, BattV, col= "#FF6600", type = 'l', ylab = 'Batt (V)', xaxt = "n")]
axis.POSIXct(1, date_range, format = "%d %b")

met_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, TairPlat, col= "#FF6600", type = 'l', ylab = 'Temperature (°C)', xaxt = "n")]
met_data[as.Date(TIMESTAMP) %in% date_range, lines(TIMESTAMP, TairHMP, col = "#000099")]
axis.POSIXct(1, date_range, format = "%d %b")
legend('topright', legend = c('TairPlat', 'TairHMP'), col = c("#FF6600", "#000099"), bty = 'n', lwd =2)

met_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, PPFD1, col = "#003300", type = 'l', ylim = c(0, 2500), ylab = 'PPFD (μmol/sm2)', xaxt = "n")]
met_data[as.Date(TIMESTAMP) %in% date_range, lines(TIMESTAMP, PPFD2, col = "#66CC66")]
axis.POSIXct(1, date_range, format = "%d %b")
legend('topleft', legend = c('PPFD1', 'PPFD2'), col = c("#003300", "#66CC66"), bty = 'n', lwd =2)

met_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, RH, col = "#3399FF", type = 'l', ylab = 'Relative Humidity (%)', xaxt = "n")]
axis.POSIXct(1, date_range, format = "%d %b")

met_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, Tsoil1, ylim=c(10,25), col = "#666666", type = 'l', ylab = 'Temperature (°C)', xaxt = "n")]
met_data[as.Date(TIMESTAMP) %in% date_range, lines(TIMESTAMP, Tsoil2, col  = "#FF6600")]
axis.POSIXct(1, date_range, format = "%d %b")
legend('bottomright', legend = c('Tsoil1', 'Tsoil2'), col = c("#666666", "#FF6600"), bty = 'n', lwd =2)

met_data[as.Date(TIMESTAMP) %in% date_range, plot(TIMESTAMP, Kipp1, col = 1, type = 'l',  ylim = c(0, 1500), ylab = 'Shortwave Radiation (W/m2)', xaxt = "n")]
met_data[as.Date(TIMESTAMP) %in% date_range, lines(TIMESTAMP, Kipp2, col ="#FFCC00")]
axis.POSIXct(1, date_range, format = "%d %b")
legend('topright', legend = c('Kipp1', 'Kipp2'), col = c(1, "#FFCC00"), bty = 'n', lwd =2)

dev.off()

 
