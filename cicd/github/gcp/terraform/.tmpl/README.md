# cicd / github / gcp / terraform / .tmpl

## Description
The .tmpl folder is designed to contain template files that can be consumed by scripts, programs, and other processes
and easily filled in to handle the last mile pieces.
___
## Template Variables
Currently, there is only one file: main.tf.tmpl. Below are the template variables that should be filled out when copied
to the parent directly. Template variables start and end with % (ex: %text_here%), the whole string from start % to end
% should be replaced with the value it denotes. See the below table for more information.

**main.tf.tmpl**

| variable                | description                                                                        |
|-------------------------|------------------------------------------------------------------------------------|
| %tfstate_bucket_name%   | The GCS bucket that will contain the terraform state file                          |
| %tfstate_bucket_prefix% | The GCS bucket prefix for the state file                                           |
| %region%                | The region the S3 bucket that contains the terraform state file is located in      |
| %project_id%            | The project id where the resources will be created                                 |
