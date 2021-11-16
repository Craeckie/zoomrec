resource "aws_efs_file_system" "zoomrec" {
  creation_token = "zoomrec-efs"
  encrypted      = false
}

resource "aws_efs_mount_target" "mnt" {
  count          = length(module.vpc.private_subnets)
  file_system_id = aws_efs_file_system.zoomrec.id
  subnet_id      = element(module.vpc.private_subnets,count.index)

  security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
  name        = "zoomrec-efs"
  description = "Allow inbound NFS from instances"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "TCP"
    security_groups = [module.vpc.default_security_group_id]
  }
}

resource "aws_efs_access_point" "zoomrec" {
  file_system_id = aws_efs_file_system.zoomrec.id
  root_directory {
    path = "/mnt/efs"
  }
}