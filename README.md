# README

Build the docker container:

`docker build -t YOUR-CONTAINER-NAME https://github.com/shofetim/ynab`

## FAQ

### Wine cannot start x?

This seems to be a permissions issue on latest versions of Ubuntu, try:

`xhost +`
