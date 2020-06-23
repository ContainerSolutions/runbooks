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

#### Github pages deploy

The deploy to Github Pages is controlled by [this action](https://github.com/containersolutions/gh-actions-hugo-deploy-gh-pages). The reference to this is found in [.github/workflows/main.yml](https://github.com/ContainerSolutions/runbooks/blob/80767a47c4ed2db5176bea6b489df9069c1282ff/.github/workflows/main.yml#L15).

To update the key used
1) create an SSH key and put the private key into a secret called `GIT_DEPLOY_KEY` [here](https://github.com/ContainerSolutions/runbooks/settings/secrets).
2) add the public key as a deploy key with write access [here](https://github.com/ContainerSolutions/runbooks/settings/keys).

More granular details are available on the [action page](https://github.com/containersolutions/gh-actions-hugo-deploy-gh-pages#secrets).

## License

See [LICENSE](LICENSE)

