job "hello-devops" {
  # The job type defines how the scheduler places the tasks.
  # 'service' is ideal for long-running processes.
  type = "service"

  # Minimal CPU and memory allocation
  datacenters = ["dc1"]
  
  group "greetings" {
    count = 1
    
    # Define minimal resources for the task
    task "hello-task" {
      driver = "docker"

      # Allocate minimal CPU (100 MHz) and memory (64 MB)
      resources {
        cpu    = 100 
        memory = 64
      }

      config {
        # CRITICAL: Use the Docker image built and pushed by the CD pipeline
        image = "ghcr.io/rahulkhairnar/devops_intern/devops-hello:latest"
        
        # The image will automatically run the command defined in the Dockerfile (python hello.py)
        # We don't need a command here unless we want to override the Dockerfile CMD.
      }
      
      # Define a simple service block as requested
      service {
        name = "hello-service"
        tags = ["devops", "greetings"]
        # Since this script doesn't expose a port, the service block is minimal.
      }
    }
  }
}
