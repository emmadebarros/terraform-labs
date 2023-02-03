#"<provider>_<resource_type>" "<name>"

#https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file
resource "local_file" "my-file" {
  #reference attributes for resource dependcy (implicit dependcy)
  content = "My favourite pet is ${random_pet.my-rand-pet.id}"
  #content = var.file-content-list["statement2"]
  #content = var.my-variable-definition
  filename = "${var.filepath_prefix}.${var.filename}"
  file_permission = "0700" #only own of the file has read/write permissions on the file

  /*
  explicit dependency
  depends_on = [
    random_pet.my-rand-pet
  ]
  */
}

#https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet
resource "random_pet" "my-rand-pet" {
  prefix = var.prefix-list[1]
  separator = var.separator
  length = var.length
}

#gets printed on the screen
#type terraform output or terraform output pet-name
#the best way to use them is to feed them to other IaC tools liek Ansible or Shell scripts
output "pet-name" {
  value = random_pet.my-rand-pet.id #reference expression
  description = "Record the value of pet ID generated by the random_pet provider/resource"
}


#we added a new provider, so need to run terraform init again
#random provider is a logical provider, and it displays the result of the pet name on the console

#data sources allow terraform to read attributes from resources which are provisonned outside its control
#e.g. feed a local_file resource content's the content of a local file created outside of terraform