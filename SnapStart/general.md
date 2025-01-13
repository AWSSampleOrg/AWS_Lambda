# Confirm that SnapStart is activated for the function version

- https://docs.aws.amazon.com/lambda/latest/dg/snapstart-activate.html

```sh
aws lambda get-function-configuration --function-name my-function:1
```

If the response shows that `OptimizationStatus` is On and `State` is `Active`, then SnapStart is activated and a snapshot is available for the specified function version.

```
"SnapStart": {
     "ApplyOn": "PublishedVersions",
     "OptimizationStatus": "On"
  },
  "State": "Active",
```
