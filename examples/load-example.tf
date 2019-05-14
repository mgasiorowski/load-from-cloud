variable "private_key_path"  {}
variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  type="string"
  default="eu-central-1"
  description="Default aws region"
}
variable "home_path" {
  type        = "string"
  default     = "/home/centos"
  description = "User home path used on instance"
}
variable "user" {
  type        = "string"
  default     = "centos"
  description = "Username used on instance"
}
variable "run_date" {}
variable "tag_suffix" {
}

provider "aws" {
  region     = "${var.aws_region}"
}

resource "aws_instance" "load-example" {
  ami           = ""
  instance_type = "t2.micro"
  key_name      = "aws-tests"
  count         = 5

  tags = {
    Name = "Load Cloud - ${var.tag_suffix}"
  }

  connection {
    type        = "ssh"
    user        = "${var.user}"
    private_key = "${file("${var.private_key_path}")}"
    timeout     = "2m"
    agent       = false
  }

  provisioner "file" {
    source      = "resources/load-example"
    destination = "${var.home_path}"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${var.home_path}/load-example",
      "chmod +x gradlew",
      "./gradlew clean gatlingClasses --warning-mode all --stacktrace"
    ]
  }

    provisioner "remote-exec" {
    inline = [
      "cd ${var.home_path}/load-example",
      "chmod +x gradlew",
      "./gradlew clean gatlingRun --warning-mode all --stacktrace"
    ]
  }

  provisioner "local-exec" {
    command = "mkdir -p logs/test-report/${var.run_date} && scp -r -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.private_key_path} ${var.user}@${self.public_ip}:${var.home_path}/load-example/build/reports/gatling/ logs/test-report/${var.run_date}/${self.id}-${timestamp()}"
  }
}

output "instance_ids" {
 value = [
  "${aws_instance.load-example.*.id}"
 ]
}

output "instance_public_ips" {
  value = [
    "${aws_instance.load-example.*.public_ip}"
  ]
}
