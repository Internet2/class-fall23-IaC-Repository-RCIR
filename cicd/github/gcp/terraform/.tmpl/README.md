# cicd / github / aws / terraform / .tmpl

## Description
The .tmpl folder is designed to contain template files that can be consumed by scripts, programs, and other processes
and easily filled in to handle the last mile pieces.
___
## Template Variables
Currently, there is only one file: main.tf.tmpl. Below are the template variables that should be filled out when copied
to the parent directly. Template variables start and end with % (ex: %text_here%), the whole string from start % to end
% should be replaced with the value it denotes. See the below table for more information.

**main.tf.tmpl**

| variable              | description                                                                        |
|-----------------------|------------------------------------------------------------------------------------|
