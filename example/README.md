# airplane_mode_checker_example

Example app for the `airplane_mode_checker` plugin.

## What it shows

- One-time airplane mode checks with `checkAirplaneMode()`
- Continuous updates with `listenAirplaneMode()`

## Run it

```sh
flutter run
```

The UI includes:

- A button to query the current airplane mode state
- A `StreamBuilder` that reflects the latest stream event from the plugin
