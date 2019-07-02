#!/usr/bin/env ruby


load "#{File.dirname(__FILE__)}/../../config.rb"

if ARGV.length > 0
  for arg in ARGV
    (0..$worker_count).each do |index|
      node = (index == 0) ? "k8s-master" : "k8s-worker-%d" % index
      if node.match(arg)
        puts node
      end
    end
  end
else
  (0..$worker_count).each do |index|
    node = (index == 0) ? "k8s-master" : "k8s-worker-%d" % index
    puts node
  end
end