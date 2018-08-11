This workflow is designed to maximize overhead and stress-test drake. The goal is to improve drake's internals so this example runs fast.

Let n be the number of targets. There are n * (n - 1) / 2 non-file dependency connections among all the targets, which is the maximum possible. For i = 2, ..., n, target i depends on targets 1 through i - 1.
