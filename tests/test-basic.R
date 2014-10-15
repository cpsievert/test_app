context("Basic test")

# start up shiny app in a seperate R process
cmd <- "R -e \'shiny::runApp(port=6012, appDir=\"../\")\'"
system(cmd, intern = FALSE, wait = FALSE)

# run the test
test_that("can connect to app", {  
  remDr$navigate("http://127.0.0.1:6012")
  appTitle <- remDr$getTitle()[[1]]
  expect_equal(appTitle, "Hello Shiny!")  
})

# finally, kill the shiny process
system('pkill -f "shiny::runApp\\(port=6012"')

