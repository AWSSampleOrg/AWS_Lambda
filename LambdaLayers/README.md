[Layer paths for each Lambda runtime](https://docs.aws.amazon.com/lambda/latest/dg/packaging-layers.html#packaging-layers-paths)

When you add a layer to a function, Lambda loads the layer content into the **`/opt`** directory of that execution environment. For each Lambda runtime, the PATH variable already includes specific folder paths within the **`/opt`** directory. To ensure that your layer content gets picked up by the PATH variable, include the content in the following folder paths:

| Runtime      | Path                                                  |
| ------------ | ----------------------------------------------------- |
| Node.js      | nodejs/node_modules                                   |
|              | nodejs/node16/node_modules (NODE_PATH)                |
|              | nodejs/node18/node_modules (NODE_PATH)                |
|              | nodejs/node20/node_modules (NODE_PATH)                |
| Python       | python                                                |
|              | python/lib/python3.x/site-packages (site directories) |
| Java         | java/lib (CLASSPATH)                                  |
| Ruby         | ruby/gems/3.2.0 (GEM_PATH)                            |
|              | ruby/lib (RUBYLIB)                                    |
| All runtimes | bin (PATH)                                            |
|              | lib (LD_LIBRARY_PATH)                                 |
