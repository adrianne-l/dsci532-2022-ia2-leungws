# How to deploy a Dash-R app to Heroku

The deployed app is hosted here https://dsci532-2022-ia2-leungws.herokuapp.com/.

This repo contains the necessary files for deploying a Dash-R app to Heroku.

Steps to reproduce:

1. `git clone git@github.com:UBC-MDS/dsci532-2022-ia2-leungws.git`
2. `cd dsci532-2022-ia2-leungws`
3. `heroku create --stack container dsci532-2022-ia2-leungws`
4. `git push heroku main`
5. Wait ~15 min for the build to finish.
6. `heroku ps:scale web=1`
7. Navigate to `https://dsci532-2022-ia2-leungws.herokuapp.com` in your browser

