###### variable for vpc #######
variable "Prod_Vpc" {
   default = "main-vpc"
}

variable "vpc-cidr" {
   default = "192.168.0.0/16"
}

variable "basename" {
   description = "AZ_LIST for resources names"
   default = "MY_SUBNET"
}

# mapping for create subnets
variable "AZ_LIST" {
   type = map
   default = {
      sub-1 = {
         az = "use1-az1"
         cidr = "192.168.1.0/24"
      }
      sub-2 = {
         az = "use1-az2"
         cidr = "192.168.2.0/24"
      }
      sub-3 = {
         az = "use1-az3"
         cidr = "192.168.3.0/24"
      }
   }
}

variable "internet_gateway" {
    description = "for internet gateway"
    type = string
    default = "internet_gateway"
  
}

variable "ami" {
   type = string
   default = "ami-08fdec01f5df9998f"
   #ami_id = "ami-00874d747dde814fa"    
      
    } 



variable "instance_name" {
   description = "SERVER_LIST for resources names"
   default = "MY_SERVER"
}

variable "server_name" {
   type = set(string)
   default = ["apache_server1" , "apache_server2" , "apache_server3"]
}
   
   
   
   