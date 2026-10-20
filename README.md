# Development

Install `ruby 4.0.7`, `erlang 29.1.2`, and `elixir 1.20.4-otp-29`. Recommended to use `asdf` package manager for all three.

After cloning the repo, `cd` into the top level directory and run `$ gem install bundler && bundle install` to set up Ruby dependencies.

In `~/.zprofile`, set environment variables
```bash
export PRFL_BOOST_EMAIL="email@email.com"
export PRFL_BOOST_PASSWORD="password"
```

To open an interactive Ruby console with all dependencies loaded, run `$ bin/console`



To run the executable in the development environment, first make sure permissions are set to run it:
```bash
$ chmod +x bin/exe
```

then:
```bash
$ bin/exe [OPTIONS]
```

Data is stored locally at `./data/` in development.

# Production

To set up a production environment, open `~/.zshrc` and add the `prfl` executable to the `$PATH`
```bash
# add prfl to path
PATH=$PATH:/Users/$USER/Dropbox/roasting/lib/bin
```

Open `~/.zprofile` and add these environment variables
```bash
export PRFL_ARTISAN_PATH=/Users/$USER/Dropbox/roasting/artisan/roasts/raw
export PRFL_BOOST_PATH=/Users/$USER/Dropbox/roasting/boost_data/raw
export PRFL_TARGET_PATH=/Users/$USER/Dropbox/roasting/artisan/roasts/merged
export PRFL_BOOST_EMAIL="email@email.com"
export PRFL_BOOST_PASSWORD="password"
```

When you're ready to deploy a new version, run the deploy script
```bash
$ chmod +x bin/deploy
$ bin/deploy VERSION
```

Pay attention to versioning. The deploy script will not run if you do not provide a version, nor will it run if you are trying to deploy the same version that is already in production. Before deploying, try running `$ prfl --version` to confirm the current version and to help decide what the new version number should be. `TODO:` Deploy script should also fail if you try to deploy a version number that is older than the current one.

# TODO:
- [x]  Improve README

- [ ] Add "prflName" value from profile metadata to profile data for all existing profile data files and new downloads

- [ ] Determine which boost profiles are replications by checking "prflName" in the metadata and add that status to the profile data for all existing and future files

- [ ] Determine which profiles were taken over manually midway by looking for an unnamed event in the artisan data

- [ ] In `fetch_profile_data.exs`, write files to the file system in the correct sorted order (descending by most recent datetime) *or* sort them at the merge step. The goal is for merged files to be listed in the correct order when sorted by datetime of the roast

- [ ] Add `-r --reference BATCHES` option to add the listed batches to the reference directory and move the ones they are replacing to the archives. Only merged profiles should be references, so it should fail if the profile is not merged *or* make an effort to merge it first

- [ ] Add `-m --metadata` option to grab and persist metadata for all roasts

- [ ] Anytime we grab up-to-date metadata for all roasts, persist it. Check local metadata first whenever feasible before requesting all from the server
