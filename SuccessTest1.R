library(RSelenium)
library(rvest)
library(httr)

port <- sample(1000:9000, size = 1, replace = F)
# Start RSelenium with a specific ChromeDriver version and a different port
rD <- rsDriver(browser = "chrome", chromever = "126.0.6478.182", port = port)  # Adjust the version and port if necessary
remDr <- rD[["client"]]

# Navigate to the URL
url <- "https://maps.churchofjesuschrist.org/wards/25003"
remDr$navigate(url)

# Allow time for the page to load
Sys.sleep(2)

# Extract the page source after rendering
page_source <- remDr$getPageSource()[[1]]

# Parse the rendered HTML with rvest
webpage <- read_html(page_source)

# Extract the latitude and longitude data
lat_long_text <- webpage %>% html_node(".sc-fa5f450-1.khyCPl") %>% html_text(trim = TRUE)
lat_long <- strsplit(lat_long_text, ", ")[[1]]

latitude <- as.numeric(lat_long[1])
longitude <- as.numeric(lat_long[2])

# Print the latitude and longitude
print(c(latitude, longitude))

# Close RSelenium session
remDr$close()
rD[["server"]]$stop()

