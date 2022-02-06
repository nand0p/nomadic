job "nomadic" {
  datacenters = ["dc-aws-001"]
  type        = "service"
  priority    = 50

  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  update {
    stagger          = "1s"
    max_parallel     = 3
    min_healthy_time = "1s"
    healthy_deadline = "10s"
  }

  group "nomadic" {
    count = 3 
    network {
      port "http" {
        to = 80
        #static = 80
      }
    }
    restart {
      attempts = 2
      interval = "5s"
      delay    = "1s"
      mode     = "fail"
    }

    task "nomadic" {
      driver = "docker"
      config {
        image = "nand0p/nomadic:0.1"
        ports = ["http"]
      }

      service {
        name         = "${TASKGROUP}-service"
        port         = "http"
        address_mode = "driver"
        tags         = ["nomadic", "urlprefix-/"]
        check {
          name         = "nomadic"
          port         = "http"
          interval     = "5s"
          timeout      = "2s"
          type         = "tcp"
        }
      }

      resources {
        cpu    = 20
        memory = 12
      }

      logs {
        max_files     = 10
        max_file_size = 15
      }

      kill_timeout = "1s"
    }
  }
}
