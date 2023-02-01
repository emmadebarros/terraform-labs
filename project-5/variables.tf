#https://youtu.be/YcJ9IeukJL8

#just like the main.tf file, this file consists of blocks and arguments
#the var name should be the argument name for which we are using the variable (as a standard)

#to use the variables in the main.tf file, replace the argument values with the variable name, prefixed with var

variable "filepath_prefix" {
  default="C:\\Users\\egadoury\\Development\\Terraform Labs\\lab-1\\"
  type = string
  description = "the path of local file"
}

variable "filename" {
  default="output.txt"
  type = string
  description = "the file name"
}

variable "prefix" {
  default="Mrs"
  type = string
  description = "prefix to be set"
}

variable "separator" {
  default="."
  type = string
  description = "separator to be set"
}

variable "length" {
  default="1"
  description = "ranndom name length"
}

#list - numbered collection of values
variable "prefix-list" {
  default = ["Mr", "Mrs", "Sir"]
  type = list
}

#map - data represented as a format of key-value pairs
#we make use of key matching to access elements from
variable "file-content-list" {
  default = {
    "statement1" = "We love pets!"
    "statement2" = "We love animals!"
  }
  type = map
}

#we can also combine type constraints

#if we want of list of string type elements
variable "string-list" {
  default = ["Mr", "Mrs", "Sir"]
  type = list(string)
  #list(number)
  #etc.
}

#use map constraints for map as well
variable "string-map" {
  default = {
    "colour1" = "red"
    "colour2" = "blue"
  }
  type = map(string)
  #map(number)
  #etc.
}

#set (similar to a list)
#set vs list = set cannot hold duplicates
variable "string-set" {
  default = ["blue", "red", "green"]
  #["blue", "red", "green", "blue"] ERROR
  type = set(string)
  #set(number)
  #etc.
}

#objects
#with object, we can create complex data structures that can hold all the variable types seen so far
#the next variable is meant to hold the different attributes/features of this person variable
variable "person" {
  type = object({
    name = string
    last_name = string
    age = number
    favourite_food = list(string)
    has_favourite_pet = bool
  })
  default = {
    age = 1
    favourite_food = [ "cereal", "milk", "mashed_potatoes" ]
    has_favourite_pet = false
    last_name = "man"
    name = "spider"
  }
}

#tuple - sequence of element (similar to list)
#tuple vs list = list uses elements of the same variable type
#adding additional elements/incorrect types will result in an error
variable kitty {
  type = tuple([string, number, bool])
  default = ["cat", 1, false]
}

#if we don't provide default values, we will be prompted to enter each values in an interractive mode at the console when running terraform apply

#we can pass in values as command line arguments OR provide a variable definition files (they should end with .tfvars or .tfvars.json). These files only consists of variable assignments
variable "my-variable-definition" {
  type = string
}

/*
terraform.tfvars, terraform.tfvars.json, *.auto.tfvars, *.auto.tfvars.json are automatically loaded by terraform

if any other name is used, e.g. variables.tfvars, i will have to pass it along with a command line flag, i.e.:
terraform apply -var-file variables.tfvars
*/

/*
we can use any of the options seen so far to assign values to variables, but if we use multiple ways to assign values for the same variable, tf follows a variable definition precedence to understand which value it should accept

see youtube video section for more info

1. env variables
2. terraform.tfvars
3. *.auto.tfvars (.json) (alphabetical order)
4. -var or -var file (command-line flags)
*/