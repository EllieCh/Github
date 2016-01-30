mkdir imdb
cd imdb/
rails new movie_review 
cd movie_review
git init
git status
git add .
git commit -m "Initial Commit"
rails s //to run the server
rails g scaffold Movie title:string year:integer rating:integer description:text
rake db:migrate

