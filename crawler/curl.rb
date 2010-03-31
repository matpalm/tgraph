# note: only need -u when using rate limited calls that require whitelisted uid

def curl fetch_url, output = nil
  cmd = "curl"
  cmd += " -u #{ENV['UID_PWD']}" if ENV['UID_PWD']
  cmd += " -m 5 -s #{fetch_url}"
  cmd += " -o #{output}" if output
  #puts "cmd=#{cmd}"
  `#{cmd}`
end
