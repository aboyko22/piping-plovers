# Piping Plovers

This repository represents all the code and resources used to deploy https://aboyko22.github.io/piping-plovers, a story written for a data journalism class at Northwestern University.

Below is a description of the folders at the root of the repository.

## .github

One aspect of the site involves the automation of data collection using a API. This was scheduled using cron and GitHub Actions, and the file governing that process is stored in this folder.

## data

All of the data used to create this project is store in this folder. A large portion of this is stored locally only, however, and does not exist in this repository.

## docs

The story was deployed using GitHub Pages. This folder serves as its root directory, and all of the files used to run the site are stored in here.

## scripts

To supplement the main story, data was cleaned, analyzed, and used to create multiple embedded visualizations. These scripts are where all of those processes originate from.