# README #

## What is this repository for? ##

* A photo contest site for the Toronto Chapter of the Society for Conservation Biology
* The site is live at: http://www.scbtorontophotos.com
* SCB-TO http://www.scbtoronto.com
* Society for Conservation Biology http://conbio.org

## Up and running
- `bundle install`
- `mongod`
- *TODO* start resque
- `redis`
- `rails server`

## Environment variables

- `SECRET_KEY_BASE` generated from `rake secret`
- `MONGOHQ_URL` url to MongoDB. If blank, defaults to local mongo on default port
- `REDISTOGO_URL` url to Redis for Resque. If blank, defaults to local redis on default port

### AWS ###
S3 used to allow user to upload directly to S3 bucket
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_FOG_DIRECTORY` S3 bucket name

### Recaptcha ###
- `RECAPTCHA_PRIVATE`
- `RECAPTCHA_PUBLIC`
