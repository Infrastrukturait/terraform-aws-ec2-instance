variable "name" {
  type        = string
  default     = ""
  description = "Name to be used on EC2 instance created."
}

variable "ami" {
  type        = string
  default     = null
  description = "ID of AMI to use for the instance."
}

variable "associate_public_ip_address" {
  type        = bool
  default     = null
  description = "Whether to associate a public IP address with an instance in a VPC."
}

variable "assign_eip_address" {
  type        = bool
  default     = false
  description = "Assign an Elastic IP address to the instance. NOTE: elastic ip must already exist."
}

variable "eip_adress_allocation_id" {
  type        = string
  default     = null
  description = "ID for existing Elastic IP. Allowed only when `assign_eip_address` is set to `true`."
}

variable "maintenance_options" {
  type        = any
  default     = {}
  description = "The maintenance options for the instance."
}

variable "availability_zone" {
  type        = string
  default     = null
  description = "AZ to start the instance in."
}

variable "cpu_credits" {
  type        = string
  default     = null
  description = <<-EOT
    The credit option for CPU usage.
    Available options: `unlimited` or `standard`.
EOT
}

variable "disable_api_stop" {
  type        = bool
  default     = null
  description = "If true, enables EC2 Instance Stop Protection."
}

variable "disable_api_termination" {
  type        = bool
  default     = null
  description = "If true, enables EC2 Instance Termination Protection."
}

variable "ebs_block_device" {
  type        = list(any)
  default     = []
  description = "Additional EBS block devices to attach to the instance."
}

variable "attach_ebs_volumes" {
  type        = list(any)
  default     = []
  description = "Additional existing EBS block devices to connect to the instance."
}

variable "ebs_optimized" {
  type        = bool
  default     = null
  description = "If true, the launched EC2 instance will be EBS-optimized."
}

variable "enclave_options_enabled" {
  type        = bool
  default     = null
  description = "Whether Nitro Enclaves will be enabled on the instance. Defaults to `false`."
}

variable "ephemeral_block_device" {
  type        = list(map(string))
  default     = []
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance."
}

variable "get_password_data" {
  type        = bool
  default     = null
  description = "If true, wait for password data to become available and retrieve it."
}

variable "hibernation" {
  type        = bool
  default     = null
  description = "If true, the launched EC2 instance will support hibernation."
}

variable "host_id" {
  type        = string
  default     = null
  description = "ID of a dedicated host that the instance will be assigned to. Use when an instance is to be launched on a specific dedicated host."
}

variable "iam_instance_profile" {
  type        = string
  default     = null
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile."
}

variable "instance_initiated_shutdown_behavior" {
  type        = string
  default     = null
  description = <<-EOT
    Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances.
    Cannot be set on instance-store instance. Please visit [https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior).
EOT
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
  description = "The type of instance to start."
}

variable "instance_tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for the instance."
}

variable "ipv6_address_count" {
  type        = number
  default     = null
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet."

}

variable "ipv6_addresses" {
  type        = list(string)
  default     = null
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface."
}

variable "key_name" {
  type        = string
  default     = null
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource."
}

variable "launch_template" {
  type        = map(string)
  default     = {}
  description = "Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template."
}

variable "metadata_options" {
  type = map(string)
  default = {
    "http_endpoint"               = "enabled"
    "http_put_response_hop_limit" = 1
    "http_tokens"                 = "optional"
  }
  description = "Customize the metadata options of the instance."
}

variable "monitoring" {
  type        = bool
  default     = null
  description = "If true, the launched EC2 instance will have detailed monitoring enabled."
}

variable "network_interface" {
  type        = list(map(string))
  default     = []
  description = "Customize network interfaces to be attached at instance boot time."
}

variable "placement_group" {
  type        = string
  default     = null
  description = "The Placement Group to start the instance in."
}

variable "private_ip" {
  type        = string
  default     = null
  description = "Private IP address to associate with the instance in a VPC."
}

variable "root_block_device" {
  type        = list(any)
  default     = []
  description = "Customize details about the root block device of the instance. See Block Devices below for details."
}

variable "secondary_private_ips" {
  type        = list(string)
  default     = null
  description = <<-EOT
    A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC.
    Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a `network_interface block`.
EOT
}

variable "source_dest_check" {
  type        = bool
  default     = null
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "The VPC Subnet ID to launch in."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the resource."
}

variable "tenancy" {
  type        = string
  default     = null
  description = <<-EOT
    The tenancy of the instance (if the instance is running in a VPC).
    Available values: `default`, `dedicated`, `host`
EOT
}

variable "user_data" {
  type        = string
  default     = null
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see `user_data_base64` instead."
}

variable "user_data_base64" {
  type        = string
  default     = null
  description = <<-EOT
    Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string.
    For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption.
EOT
}

variable "user_data_replace_on_change" {
  type        = bool
  default     = null
  description = <<-EOT
    When used in combination with `user_data` or `user_data_base64` will trigger a destroy and recreate when set to true.
    Defaults to `false` if not set.
EOT
}

variable "volume_tags" {
  type        = map(string)
  default     = {}
  description = "A mapping of tags to assign to the devices created by the instance at launch time."
}

variable "enable_volume_tags" {
  type        = bool
  default     = true
  description = "Whether to enable volume tags (if enabled it conflicts with `root_block_device` tags)."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  default     = null
  description = "A list of security group IDs to associate with."
}

variable "timeouts" {
  type        = map(string)
  default     = {}
  description = "Define maximum timeout for creating, updating, and deleting EC2 instance resources."
}
