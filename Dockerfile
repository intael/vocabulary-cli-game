FROM r-base:4.3.2

WORKDIR /app

COPY renv.lock renv.lock

RUN Rscript -e "install.packages('renv');renv::restore()"

COPY . .