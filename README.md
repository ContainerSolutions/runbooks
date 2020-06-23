# Runbooks

## The Manifesto

- We are tired of haphazardly hunting through messy threads of GitHub issues and StackOverflow when we hit a problem

- We don't want a one-off fix, we want to deepen our understanding of the problem space

## What

A collection of step by step guides for fixing common tech problems.

The content is published [here](https://containersolutions.github.io/runbooks/)

## Requirements

### Submodules

Hugo uses submodule for themes so when you are cloning this repository you should pass the `--recursive` flag:

```
git clone --recursive git@github.com:ContainerSolutions/runbooks.git
```

## Running hugo locally

### Docker

If you have docker compose installed you can simply call and you should see the blog at http://localhost:1313/runbooks/

```
docker-compose up
```

#### Local Install (runs really fast)

First [install hugo](https://gohugo.io/getting-started/installing/) then from this repository run:

```
hugo serve -D
```

## License

See [LICENSE](LICENSE)
