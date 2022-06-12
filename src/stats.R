stats <- list2env(
  list(
    rightAnswers = 0L,
    wrongAnswers = 0L,
    totalAnswers = 0L,
    wordWeights = list(),
    formatStats = function() {
      baseMesssage <- sprintf(
        "  --> Total Answers: %s.\n  --> Right Answers: %s\n  --> %s Correct: %s%s\n",
        stats$totalAnswers,
        stats$rightAnswers,
        "%",
        round(
          ifelse(
            stats$totalAnswers == 0,
            0,
            stats$rightAnswers / stats$totalAnswers
          ),
          3
        ) * 100,
        "%\n"
      )
      strugglingWords <- stats$wordWeights[stats$wordWeights > 1]
      if (length(strugglingWords) > 0) {
        topThree <-
          unlist(strugglingWords[order(unlist(strugglingWords), decreasing = T)][1:3]) # unlist drops nulls
        topThreeWithMistakes <-
          sapply(names(topThree), function(word)
            paste0(word, " (", topThree[[word]], ")"))
        top3Message <-
          paste0(
            "The top 3 words you're struggling the most with are (cumulative mistakes in parenthesis): ",
            paste(topThreeWithMistakes, collapse = ", ")
          )
        baseMesssage <- paste0(baseMesssage, top3Message)
      }
      baseMesssage
    },
    registerMistake = function(word) {
      stats$wrongAnswers <- stats$wrongAnswers + 1
      stats$wordWeights[[word]] <- stats$wordWeights[[word]] + 1
    },
    registerCorrectAnswer =  function(word) {
      stats$rightAnswers <- stats$rightAnswers + 1
      stats$wordWeights[[word]] <-
        max(stats$wordWeights[[word]] - 1, 1)
    }
  )
)
