# Libra

Paste a url and see how heavy is a webpage.

## Dependencies

The project needs elixir 1.4, Postgresql >= 9 and PhantomJS >= 2.0 (for testing).

## Initial setup

The project provides a VM definition, so you can just run `vagrant up` and then `vagrant ssh`.

Once the vm is provisioned and you've ssh'ed into it you can run `make setup` to install
all dependencies and perform the initial setup steps.

## Run the server

`make server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Run the server with an interactive console

`make console`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Run tests

`make test`

## Check coverage

`make cover`

## Create docs

`make docs`

## Run dialyzer

`make dialyzer`

# Build a release

`make release`
