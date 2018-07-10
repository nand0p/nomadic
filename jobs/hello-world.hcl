job "helloworld" {
  datacenters = ["dc1"]
  type = "service"
  priority = 50

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  update {
    stagger = "10s"
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "2m"
  }

  group "hello" {
    count = 5
    restart {
      attempts = 2
      interval = "1m"
      delay = "10s"
      mode = "fail"
    }

    task "hello" {
      driver = "docker"

      config {
        image = "nand0p/hello-world:1.0"
        port_map {
          http = 8080
        }
        args = [
          "-version", "v1.3"
        ]
      }

      service {
        name = "${TASKGROUP}-service"
        tags = ["hello-world", "urlprefix-/"]
        port = "http"
        check {
          name = "alive"
          type = "http"
          interval = "10s"
          timeout = "3s"
          path = "/"
        }
      }

      resources {
        cpu = 100
        memory = 32
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
