library(rjson)
source("src/parseUserInput.R")
source("src/stats.R")
source("src/parseCliArgs.R")
source("src/loadWordWeights.R")

wordType <- parseCliArgs(commandArgs(trailingOnly = TRUE))

wordsList <-
  rjson::fromJSON(file = file.path("resources", paste0(wordType, ".json")))

wordsMap <- list2env(wordsList)

serializedWordWeightsFile <-
  file.path(".cache",  paste0(wordType, ".rds"))
loadWordWeights(serializedWordWeightsFile, wordsMap, stats)

stdIn <- file("stdin")

while (TRUE) {
  wordToBeAsked <-
    names(sample(wordsList, size = 1, prob = stats$wordWeights))
  message(sprintf(
    "Do translate the word %s (or press enter to skip)",
    toupper(wordToBeAsked)
  ))
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
  if (length(inputAnswer) > 0 && inputAnswer == "exit") {
    message("Quitting! Remember: Practice makes perfect.")
    message("Performance:")
    message(stats$formatStats())
    saveRDS(stats$wordWeights, file = serializedWordWeightsFile)
    closeAllConnections()
    quit(save = "no")
  }
  stats$totalAnswers <- stats$totalAnswers + 1
  if (length(inputAnswer) > 0 &&
      inputAnswer %in% wordsMap[[wordToBeAsked]]) {
    message("Correct! :D")
    stats$registerCorrectAnswer(wordToBeAsked)
  }
  else {
    stats$registerMistake(wordToBeAsked)
    correctAnswers <-
      paste(toupper(wordsMap[[wordToBeAsked]]), collapse = " or ")
    if (length(inputAnswer) == 0) {
      message(sprintf("Skipping! It means: '%s'.", correctAnswers))
    } else {
      message(
        sprintf(
          "Wrong! The right answer is NOT '%s', but '%s'. Weight: %s",
          inputAnswer,
          correctAnswers,
          stats$wordWeights[[wordToBeAsked]]
        )
      )
    }
  }
}
