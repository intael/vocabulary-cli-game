library(rjson)
library(argparser, quietly = TRUE)
source("src/parseUserInput.R")
source("src/stats.R")
source("src/cli.R")
source("src/wordMap.R")


argvals <- parse_args(argParser())
parsedArgs <- validateArgs(argvals)

wordsMap <-
  rjson::fromJSON(file = file.path("resources", paste0(parsedArgs$wordlist, ".json")))

cacheFile <- paste0(parsedArgs$wordlist, ".rds")
cacheFile <-
  ifelse(parsedArgs$reverse, paste0("reverse_", cacheFile) , cacheFile)
serializedWordWeightsFile <- file.path(".cache",  cacheFile)

if(parsedArgs$reverse){
  wordsMap<- reverseWordMap(wordsMap)
}
loadWordWeights(serializedWordWeightsFile, wordsMap, stats)
stats$wordWeights <-
  stats$wordWeights[order(names(stats$wordWeights))]
wordsMap <- wordsMap[order(names(wordsMap))]

stdIn <- file("stdin")

while (TRUE) {
  wordToBeAsked <-
    names(sample(wordsMap, size = 1, prob = stats$wordWeights))
  sampleProbability <-
    round(stats$wordWeights[[wordToBeAsked]] / sum(unlist(stats$wordWeights)) * 100, 2)
  message(sprintf(
    "Do translate the word %s [p=%s] (or press enter to skip)",
    toupper(wordToBeAsked),
    paste0(sampleProbability, "%")
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
  if (length(inputAnswer) > 0 && inputAnswer == "summary") {
    message(stats$formatStats())
    next
  }
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
          "Wrong! The right answer is NOT '%s', but '%s'.",
          inputAnswer,
          correctAnswers
        )
      )
    }
  }
}
