# CLI Vocabulary Game

This is just a CLI program that asks you to translate words from finnish to english. Found out that learning vocabulary this way is way more entertaining than any other ways I have tried.

The mistakes you make will increase the probability of being asked that same word again. Conversely, translating a word correctly will lessen the probability of that word being asked, although the probability is never 0.

## Usage

You'll need `docker` and optionally `make` installed. If you don't have `make` installed, you can also run the docker commands directly (pick them from the `Makefile`).

If it's the first time you use it, build the docker image:

```shell
make build
```

Run it selecting the type of words you want to practice, for instance for verbs that'd be:

```shell
make run wordtype=verbs
```

The available word types are: `verbs`, `adjectives`, `nouns`, `adverbs`, `conjunctions` and `prepositions`.

You can skip a given word so that it does not count on your performance report by just pressing enter.

To exit the program, type and enter `exit` when prompted for a translation. You'll get some quick stats on your performance.



## Adding new words

Just add the words on the right json file under `resources`. The english translations are in an array in order to make available more than one single translation per word.