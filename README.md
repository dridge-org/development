# dridge - development

Development environment modeling a complete `dridge` instance including a "proxy" and a "worker" node, a PostgreSQL database and a Valkey cache. The Python package containing the node daemon can be found in the Git submodule [service](https://github.com/dridge-org/service), the Java source for the Paper in-game integration in the submodule [plugin](https://github.com/dridge-org/plugin) and the SvelteKit frontend in the submodule [interface](https://github.com/dridge-org/interface).

## Installation

> **Note:** This guide assumes you have `git`, `make`, `docker`, `docker-compose`, `python` and `poetry` installed on your system. `make` is not strictly neccessary, see the `Makefile` for the commands it runs.

1. Clone the repository.

```sh
git clone https://github.com/dridge-org/development && cd development
```

2. Install dependencies and pre-commit hooks.

```sh
make install
```

3. Copy `.env.example` to `.env` and adjust the values as needed.

```sh
cp .env.example .env
```

## Development

> The `Makefile` contains a number of useful scripts for development. Run `make` or `make help` to see a list of available commands.

### Running the services

Start the services using `docker-compose` or the following helper.

```sh
make dev
```

The JSON API is now accessible at `http://localhost:25443`. Swagger UI is available [here](http://localhost:25443/schema/swagger).
