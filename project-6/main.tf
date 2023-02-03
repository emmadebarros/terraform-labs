/*
Create this resource than change the content of it.
See if terraform modifies the content or deletes it when running the apply command.
*/

resource "local_file" "test" {
  content  = "This is my new content."
  filename = "test.txt"
}