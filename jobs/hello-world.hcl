job "hello-world" {
  datacenters = ["dc1"]
  type = "service"
  priority = 50

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  update {
    stagger = "1s"
    max_parallel = 2
    min_healthy_time = "2s"
    healthy_deadline = "2m"
  }

  group "hello-world" {
    count = 7
    restart {
      attempts = 2
      interval = "1m"
      delay = "10s"
      mode = "fail"
    }

    task "hello-world" {
      driver = "docker"
      config {
        image = "nand0p/hello-world:1.3"
        port_map {
          http = 80
        }
      }

      service {
        name = "${TASKGROUP}-service"
        tags = ["hello-world", "urlprefix-/"]
        port = "http"
        check {
          name = "hello-world"
          type = "tcp"
          interval = "10s"
          timeout = "3s"
          port = "http"
        }
      }

      resources {
        cpu = 500
        memory = 128
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
