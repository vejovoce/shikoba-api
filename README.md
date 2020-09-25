<p align="left">
   <img src="docs/images/logo.png" width="450"/>
</p>

> This is the Elixir and Phoenix backend API for Vertico

[![Languages](https://img.shields.io/github/languages/count/vertico/vertico-api?color=%23000&style=flat-square)](#)
[![Stars](https://img.shields.io/github/stars/vertico/vertico-api?color=000&style=flat-square)](https://github.com/vertico/vertico-api/stargazers)
[![Forks](https://img.shields.io/github/forks/vertico/vertico-api?color=%23000&style=flat-square)](https://github.com/vertico/vertico-api/network/members)
[![Contributors](https://img.shields.io/github/contributors/vertico/vertico-api?color=000&style=flat-square)](https://github.com/vertico/vertico-api/graphs/contributors)

## Installation

### Requirements

You will need to install the following:

- [Elixir](http://elixir-lang.org/install.html)
- [PostgreSQL](https://www.postgresql.org/download/)

### Clone this repository

You'll want to [clone this repository](https://help.github.com/articles/cloning-a-repository/) with `git clone git@github.com:vertico/vertico-api.git`. If you plan on contributing, you'll want to fork it too!

## To start your Phoenix server:

  * Install dependencies with `cd backend/ && mix deps.get` and `cd frontend/ && yarn install`
  * Configure database credentials: `cp backend/config/dev.secret.example.exs backend/config/dev.secret.exs`
  * Create and migrate your database with `cd backend/ && mix ecto.setup`
  * Start Phoenix endpoint with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.
