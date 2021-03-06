output "Axiom" {
  value = <<EOF
Axiom
-----

Edit axiom.nomad and set the following environment variables where necessary:

  AXIOM_STORAGE="${module.axiom.storage}"
  AXIOM_POSTGRES_URL="${module.axiom.postgres_url}"

Your deployment will be available at http://${module.hashistack.client_lb_ip}/

Nomad/Consul
------------

Client public IPs: ${join(", ", module.hashistack.client_public_ips)}
Server public IPs: ${join(", ", module.hashistack.server_public_ips)}

To connect, add your private key and SSH into any client or server with
`ssh ubuntu@PUBLIC_IP`. You can test the integrity of the cluster by running:

  $ consul members
  $ nomad server members
  $ nomad node status

If you see an error message like the following when running any of the above
commands, it usually indicates that the configuration script has not finished
executing:

  Error querying servers: Get http://127.0.0.1:4646/v1/agent/members: dial tcp 
  127.0.0.1:4646: getsockopt: connection refused

Simply wait a few seconds and rerun the command if this occurs.

The Nomad UI can be accessed at http://${module.hashistack.server_lb_ip}:4646/ui
The Consul UI can be accessed at http://${module.hashistack.server_lb_ip}:8500/ui

Tasks accepting traffic on port 80 can be reached at http://${module.hashistack.client_lb_ip}/

Set the following for access from the Nomad CLI:

  export NOMAD_ADDR=http://${module.hashistack.server_lb_ip}:4646

EOF
}