library(rjson)
source("src/parseUserInput.R")
source("src/stats.R")
source("src/parseCliArgs.R")

wordType <- parseCliArgs(commandArgs(trailingOnly = TRUE))

words <-
  list2env(rjson::fromJSON(file = file.path("resources", paste0(wordType, ".json"))))

stdIn <- file("stdin")

while (TRUE) {
  wordToBeAsked <- names(sample(as.list(words), 1))
  message(sprintf("Do translate the word %s", wordToBeAsked))
  inputAnswer <- parseUserInput(
    scan(
      file = stdIn,
      what = "character",
      n = 1,
      nlines = 1,
      quiet = T,
      sep = "\n",
      skipNul = T,
      skip = 0
    )
  )
  if (inputAnswer == "exit") {
    message("Quitting! Remember: Practice makes perfect.")
    message("Performance:")
    message(stats$formatStats())
    closeAllConnections()
    quit(save = "no")
  }
  stats$totalAnswers <- stats$totalAnswers + 1
  if (inputAnswer %in% words[[wordToBeAsked]]) {
    message("Correct! :D")
    stats$rightAnswers <- stats$rightAnswers + 1
  } else{
    message(sprintf(
      "Wrong! The right answer is NOT '%s', but '%s'",
      inputAnswer,
      paste(words[[wordToBeAsked]], collapse = " or ")
    ))
    stats$registerMistake(wordToBeAsked)
  }
}