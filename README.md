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
export PRFL_ARTISAN_PATH=/path/to/artisan/roasts/data
export PRFL_BOOST_PATH=/path/to/boost/roasts/data
export PRFL_TARGET_PATH=/path/to/merged/roasts/data
export PRFL_BOOST_EMAIL="email@email.com"
export PRFL_BOOST_PASSWORD="password"

# deployment paths
export PRFL_BIN_PATH=/path/to/executable
export PRFL_LIB_PATH=/path/to/library
```

When you're ready to deploy a new version, run the deploy script
```bash
$ chmod +x bin/deploy
$ bin/deploy VERSION
```

Pay attention to versioning. The deploy script will not run if you do not provide a version, nor will it run if you are trying to deploy the same version that is already in production. Before deploying, try running `$ prfl --version` to confirm the current version and to help decide what the new version number should be. `TODO:` Deploy script should also fail if you try to deploy a version number that is older than the current one.

# TODO:
- [x] Improve README

- [x] Pull all production directories in the deploy shell script from environment variables.

- [x] The `--all` command is matching roast names that contain the unwanted patterns in the middle of the string as long as the string doesn't start with one of the patterns. It should not match if the string contains the patterns anywhere

- [ ] *ADD TESTS!!!* Do this before working on any new features for production

- [ ] Write a Ruby script that wraps the deploy shell script, so we can pull the version number from the `Prfl::VERSION` constant. This way, we can have one source of truth for the version number and prevent accidental bad-versioning. Move the shell script to `src` and rename it `deploy.sh`. Remove its executable permission.

- [ ] Write an install script that installs the executable in a directory that is specified in an environment variable, and then optionally executes the deploy script. Call the install script from a Ruby wrapper, a la the deploy script.

- [ ] Add "prflName" value from profile metadata to profile data for all existing profile data files and new downloads

- [ ] Determine which boost profiles are replications by checking "prflName" in the metadata and add that status to the profile data for all existing and future files

- [ ] Determine which profiles were taken over manually midway by looking for an unnamed event in the artisan data

- [ ] In `fetch_profile_data.exs`, write files to the file system in the correct sorted order (descending by most recent datetime) *or* sort them at the merge step. The goal is for merged files to be listed in the correct order when sorted by datetime of the roast

- [ ] Add `-c --candidate BATCHES` option to copy the listed batches to the `references/candidates` directory.

- [ ] Add `-r --reference BATCHES` option to copy the listed batches to the references directory and move the ones they are replacing to the archives. Only merged profiles should be references, so it should fail if the profile is not merged *or* make an effort to merge it first. It should first check if the merged file is already in `references/candidates`, and if so move that copy to references.

- [ ] Add `-m --metadata` option to grab and persist metadata for all roasts

- [ ] Use Airtable's API to query weight loss, post-sort yield, and colortrack readings and add the data to the merged Artisan files. This could also be done with webhooks but we need a long running web app to listen for them at a permanent URL.

- [ ] Anytime we grab up-to-date metadata for all roasts, persist it. Check local metadata first whenever feasible before requesting all from the server
