In `~/.zprofile`, set environment variables
```
export PRFL_ARTISAN_PATH=~/Dropbox/roasting/artisan/roasts/raw
export PRFL_BOOST_PATH=~/Dropbox/roasting/boost_data/raw
export PRFL_TARGET_PATH=~/Dropbox/roasting/artisan/roasts/merged
export PRFL_BOOST_EMAIL="email@email.com"
export PRFL_BOOST_PASSWORD="password"
```

Make sure permissions are set to run the development executable:
```
chmod +x bin/exe
```

then:
```
bin/exe [options]
```

# Production
To set up a production environment, open `~/.zshrc` and add the `prfl` executable to the `$PATH`
```
PATH=$PATH:~/Library/CloudStorage/Dropbox/roasting/lib/bin
```

# TODO:
* Improve README
* Add "prflName" value from profile metadata to profile data for all existing profile data files and new downloads
* Add `-m --metadata` option to grab and persist metadata for all roasts
* Anytime we grab up-to-date metadata for all roasts, persist it. Check local metadata first whenever feasible before requesting all from the server
