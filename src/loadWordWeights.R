loadWordWeights <- function(serializedWordWeightsFile, wordMap, stats) {
  if (file.exists(serializedWordWeightsFile)) {
    deserializedWordWeights <- readRDS(serializedWordWeightsFile)
    wordsNotInCache <-
      names(wordMap)[!names(wordMap) %in% names(deserializedWordWeights)]
    stats$wordWeights <-
      c(
        deserializedWordWeights,
        sapply(wordsNotInCache, function(word)
          1, simplify = F, USE.NAMES = T)
      )
  } else {
    stats$wordWeights <- lapply(wordMap, function(word)
      1)
  }
}
