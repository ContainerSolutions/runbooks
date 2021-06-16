# Runbooks

## The Manifesto

- We are tired of haphazardly hunting through messy threads of GitHub issues and StackOverflow when we hit a problem

- We don't want a one-off fix, we want to deepen our understanding of the problem space

- We want to give people a resource where they can benefit from our experience without taking up our time

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
$ docker-compose up
```

Alternatively, without docker compose:

```
$ docker build -t runbooks-hugo
...
$ docker run -v $PWD:/src -p 1313:1313 -d runbooks-hugo
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

## Debugging

The Hugo docs can occasionally be a bit vague about what methods are available or what they return. There also seems to be quite a bit of [push](https://github.com/gohugoio/hugo/issues/4081#issuecomment-442384273)-[back](https://github.com/gohugoio/hugo/issues/3957#issuecomment-364657015) to adding general debugging tools. One user has created a theme that includes a partial and a shortcode to work around this limitation.

If you are working from inside a partial or layout file you can include the following partial and pass the property that you wish to inspect. I'm using `.File` in the example below.

    {{ partial "debugprint.html" .File }}

This will show you various properties available via `.File`.

If working within a content file things are a lot more limited but you can pass the following variants to get appropriate output:

    {{< debug "params" >}}
    {{< debug "site" >}}
    {{< debug param="title" >}}

but generally you will get more use when invoking the `debugprint` partial directly.

## Adding content

Run:

```
hugo new posts/path/article-name.md
```

Then git add, commit, raise PR as normal.


## License

See [LICENSE](LICENSE)

