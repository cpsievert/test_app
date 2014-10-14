library(shiny)
library(RSelenium)

# start up shiny app in a seperate R process
cmd <- "R -e \'shiny::runApp(port=6012, appDir=\"../\")\'"
system(cmd, intern = FALSE, wait = FALSE)

# start up phantomjs
pJS <- RSelenium::phantom()
Sys.sleep(5) # give the binary a moment
remDr <- remoteDriver(browserName = 'phantomjs')
remDr$open(silent = TRUE)

# run the test
test_that("can connect to app", {  
  remDr$navigate("http://127.0.0.1:6012")
  appTitle <- remDr$getTitle()[[1]]
  expect_equal(appTitle, "Hello Shiny!")  
})

# close everything up and stop the phantom process
remDr$close()
pJS$stop()
stopApp()

# finally, kill the shiny process
system('pkill -f "shiny::runApp\\(port=6012"')