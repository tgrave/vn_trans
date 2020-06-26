# set path to application
app_dir = File.expand_path("../..", __FILE__)
shared_dir = "#{app_dir}/shared"
working_directory app_dir

# Set unicorn options
worker_processes 2
preload_app true
timeout 180

# Set up socket location
listen "#{shared_dir}/sockets/unicorn.sock", :backlog => 64

# Logging
stderr_path "#{shared_dir}/log/unicorn.stderr.log"
stdout_path "#{shared_dir}/log/unicorn.stdout.log"

# Set master PID location
pid "#{shared_dir}/pids/unicorn.pid"

initialized = false
before_fork do |server, worker|
  unless initialized
    # V8 does not support forking, make sure all contexts are disposed
    ObjectSpace.each_object(MiniRacer::Context) { |c| c.dispose }

    initialized = true
  end
end
