# Deploy DIDroom Microservices on EC2
Build EC2 with ncr (trought tf-ncr) and install mircoservices in it with one simple comand

How this works: the Makefile runs *opentofu* to start an EC2 on AWS and the install the microservices code on it.  

## To clone the repo
```
   git clone --recurse-submodules  https://github.com/g7240/pipe-tf-ncr.git
```
## To deploy microservices on your EC2 run
```
   make
```
If you have problem with make, be shure to follow the aws config steps [here](https://github.com/g7240/tf-ncr)


## To stop the deployment run
```
    make destroy
``` 
