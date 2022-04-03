FROM r-base:4.1.3

WORKDIR /app

COPY . .

RUN Rscript -e "install.packages('renv');renv::restore()"
