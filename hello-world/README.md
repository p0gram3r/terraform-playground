# Hello World wih Terraform and AWS

In this simple tutorial we will spawn a publicly accessible EC2 instance with 
Ubuntu and a [busybox http daemon](https://openwrt.org/docs/guide-user/services/webserver/http.httpd) that returns some static text. The instance
will be created in `eu-central-1` (Frankfurt) by default. 


### Prerequisites
- create AWS credentials file (`~/.aws/credentials`):
    ```
    aws configure
    ```
- download the required terraform plugins
    ```
    terraform init
    ```


### Create and destroy infratructure
```
# show execution plan
terraform plan

# actually build the infrastructure 
terraform apply
```
After terraform has finished, it will print out a URL. Use `curl` or a browser 
to call the service and fetch the message.

*Note:* Sometimes the connection to the server will fail although the EC2 is 
already in "running" state. In this case you have to wait until all "Status
Checks" in the AWS console have passed.

To remove all created resources from AWS, run:
```
terraform destroy
```


### Drawing dependency graph of Terraform resources
You can draw a visual representation of all resources using the 
[Terraform graph](https://www.terraform.io/docs/commands/graph.html) 
command! The output of the command is in the DOT format, which can easily be
converted to an SVG image by GraphViz:
```
terraform graph | dot -Tsvg > /tmp/graph.svg && open /tmp/graph.svg
``` 


### Configuration
The service can be configured using environment variables. Make sure to use the 
`TF_VAR_` prefix, e.g.:
```
TF_VAR_SERVER_MESSAGE="Hi there!" terraform apply
```

The following options are available:

| variable       | description                                          | default value               |
|----------------|------------------------------------------------------|-----------------------------|
| SERVER_PORT    | the HTTP listener port of the server                 | `8080`                      |
| SERVER_MESSAGE | the message the server will respond with             | `Hello World!`            |
| INSTANCE_NAME  | name of the EC2 instance                             | `tf-playground-hello-world` |
| AWS_REGION     | AWS region to create the instances in                | `eu-central-1`              |
| AWS_PROFILE    | name of the AWS profile to read the credentials from | (none)                      |
