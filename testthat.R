library(testthat)
library(testthat)
library(RSelenium)

kill_all <- function() {
  # quit the remote driver
  remDr$quit()
  if (interactive()) {
    # close Firefox & stop selenium server
    remDr$closeWindow()
    remDr$closeServer()
  } else {
    # stop phantomjs
    pJS$stop()
  }
}

run_test <- function() {
  # In case of potential errors in running the test, we make sure to kill 
  # all the background processes upon exiting this function.
  on.exit(kill_all(), add = TRUE)
  if (interactive()) {
    checkForServer(dir=system.file("bin", package="RSelenium"))
    startServer()
    Sys.sleep(5)
    remDr <<- remoteDriver(browserName="firefox")
  } else {
    ## phantomjs doesn't need a selenium server (and is lightning fast!)
    ## Idea is from -- vignette("RSelenium-headless", package = "RSelenium")
    pJS <<- RSelenium::phantom()
    Sys.sleep(5) # give the binary a moment
    remDr <<- remoteDriver(browserName = 'phantomjs')
  }
  remDr$open(silent = TRUE)
  # run the tests
  test_dir("tests")
}

run_test()