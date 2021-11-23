job "axiom" {
  datacenters = ["dc1"]

  group "axiom" {
    count = 6

    network {
      mode = "bridge"

      port "ingress" {
        static = 80 
        to     = 80
      }
    }

    service {
      name = "axiom"
      port = "80"

      connect {
        sidecar_service {
        }
      }
    }

    task "core" {
      leader = true
      driver = "docker"
      config {
        image = "axiomhq/axiom-core:1.15.0"
      }

      env {
        AXIOM_POSTGRES_URL="<paste the postgres url from the terraform output>"
        AXIOM_DB_URL="http://localhost:8080"
      }

      resources {
        cpu    = 8000
        memory = 4000
      }
    }

    task "db" {
      driver = "docker"
      config {
        image = "axiomhq/axiom-db:1.15.0"
        args = ["serve", "-listen-address=:8080"]
        ports = [8080]
      }

      env {
        AXIOM_POSTGRES_URL="<paste the postgres url from the terraform output>"
        AXIOM_STORAGE="<paste the storage url from the terraform output>"
      }

      resources {
        cpu    = 14000
        memory = 4000
      }
    }
  }
}
