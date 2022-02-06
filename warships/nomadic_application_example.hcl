job "nomadic" {
  datacenters = ["dc-aws-001"]
  type = "service"
  priority = 50

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  update {
    stagger = "1s"
    max_parallel = 3
    min_healthy_time = "2s"
    healthy_deadline = "2m"
  }

  group "nomadic" {
    count = 3 
    restart {
      attempts = 2
      interval = "10s"
      delay = "10s"
      mode = "fail"
    }

    task "nomadic" {
      driver = "docker"
      config {
        image = "nand0p/nomadic:0.1"
        port_map {
          http = 80
        }
        #volumes = [
        #  "/efs/nomadic:/mnt"
        #]
      }

      service {
        name = "${TASKGROUP}-service"
        tags = ["nomadic", "urlprefix-/"]
        port = "http"
        check {
          name = "nomadic"
          type = "http"
          interval = "10s"
          timeout = "3s"
          path = "/"
        }
      }

      resources {
        cpu = 250
        memory = 12
        network {
          mbits = 1
          port "http" {}
        }
      }

      logs {
        max_files = 10
        max_file_size = 15
      }

      kill_timeout = "10s"
    }
  }
}
