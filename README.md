# README

## Install project

`bundle install && rails db:migrate`

## Run application

`rails s`

## Request example

``````
curl --location 'localhost:3000/api/v1/pages' \
--header 'Content-Type: application/json' \
--data '{ 
"url": "https://www.alza.cz/aeg-7000-prosteam-lfr73964cc-d7635493.htm", "fields": { 
"meta": ["keywords", "twitter:image"],
"price": ".price-box__prce", 
"rating_count": ".ratingCount", 
"rating_value": ".ratingValue" 
} 
} '