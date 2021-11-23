# `name` (required) is used to override the default decorator for elements in
# the stack.  This allows for more than one environment per account.
#  - This name can only contain alphanumeric characters.  If it is not provided 
#    here, it will be requested interactively.
name = "axiom-nomad"

# `key_name` (required) -  The name of the AWS SSH keys to be loaded on the
# instance at provisioning.  
# If it is not provided here, it will be requested interactively.
key_name = "Arne Bahlo"

# `nomad_binary` (optional, null) - URL of a zip file containing a nomad
# executable with which to replace the Nomad binaries in the AMI.
#  - Typically this is left commented unless necessary. 
#nomad_binary = "https://releases.hashicorp.com/nomad/0.10.0/nomad_0.10.0_linux_amd64.zip"

# `region` - sets the AWS region to build your cluster in.
region = "us-west-2"

# `ami` (required) - The base AMI for the created nodes, This AMI must exist in
# the requested region for this environment to build properly.
#  - If it is not provided here, it will be requested interactively.
ami = "ami-0f83b480fe2ea470c"

# The S3 bucket name to create.
bucket = "arnes-nomad2"

# `server_instance_type` ("t2.medium"), `client_instance_type` ("t2.medium"),
# `server_count` (3),`client_count` (4) - These options control instance size
# and count. They should be set according to your needs.
#
# * For the GPU demos, we used p3.2xlarge client instances.
# * For the Spark demos, you will need at least 4 t2.medium client
#   instances.
server_instance_type = "t2.medium"
server_count         = "3"
client_instance_type = "c4.2xlarge"
client_count         = "6"

# `allowlist_ip` (required) - IP to allow for the security groups (set
# to 0.0.0.0/0 for world).  
#  - If it is not provided here, it will be requested interactively.
allowlist_ip = "0.0.0.0/0"
