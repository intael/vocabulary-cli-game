stats <- list2env(
  list(
    rightAnswers = 0L,
    wrongAnswers = 0L,
    totalAnswers = 0L,
    formatStats = function() {
      sprintf(
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
        "%"
      )
    },
    registerMistake = function(word) {
      stats$wrongAnswers <- stats$wrongAnswers + 1
      if (is.null(stats$mistakes[[word]])) {
        stats$mistakes[[word]] <- 1
      } else {
        stats$mistakes[[word]] <- stats$mistakes[[word]] + 1
      }
    }
  )
)
