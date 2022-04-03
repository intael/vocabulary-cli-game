WORD_TYPES <-
  list("verbs", "nouns", "adjectives", "conjunctions", "adverbs")

parseCliArgs <- function(args) {
  if (length(args) == 0 || !args[1] %in% WORD_TYPES) {
    message(
      sprintf(
        "You need to specify the wordtype argument whose value can be one of: %s. It signals the type of words that will be asked. Example: make run wordtype=verbs",
        paste(WORD_TYPES, collapse = ", ")
      )
    )
    quit(status = 1, save = "no")
  }
  args[1]
}