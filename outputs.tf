output "elb-dns" {
  value = "${aws_elb.app.dns_name}"
}
