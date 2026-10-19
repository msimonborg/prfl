In `config.rb`, Set constants for the required directory paths:
```
ARTISAN_PATH = '/foo/'
BOOST_PATH = '/bar/'
TARGET_PATH = '/baz/'

```

Make sure permissions are set to run the executable:
```
chmod +x bin/exe
```

then:
```
bin/exe
```

# TODO:
* Improve README
* Add "prflName" value from profile metadata to profile data for all existing profile data files and new downloads
* Add `-m --metadata` option to grab and persist metadata for all roasts
* Anytime we grab up-to-date metadata for all roasts, persist it. Check local metadata first whenever feasible before requesting all from the server
