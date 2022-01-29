job "maxout" {
  datacenters = ["dc1"]
  type = "batch"

  constraint {
    attribute = "${attr.kernel.name}"
    value = "linux"
  }

  periodic {
    cron = "*/10 * * * * * *"
    prohibit_overlap = false
  }

  group "maxout" {
    count = 10
    restart {
      interval = "20s"
      attempts = 2
      delay    = "5s"
      mode     = "delay"
    }
    task "maxout" {
      driver = "docker"
      config {
        image = "nand0p/maxout:1.0"
      }
      resources {
        cpu = 100 # Mhz
        memory = 16 # MB
        network {
          mbits = 1
        }
      }
    }
  }
}
