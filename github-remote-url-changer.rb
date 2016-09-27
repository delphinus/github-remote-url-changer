#!/usr/bin/env ruby
require 'optparse'

opt = ARGV.getopts '', 'execute'

`ghq list -p`.split("\n").each do |path|

  if path =~ %r[\bgithub\.com/delphinus\b] && File.directory?(path)
    Dir.chdir path
  else
    next
  end

  `git remote -v`.scan %r[
    ^
    (?<name>\S+)\s+
    (?:https://|(?:ssh://)?git@)
    github\.com[:/]
    delphinus35/(?<repository>\S+?)(?:\.git)?
    \s+\(fetch\)
    $
  ]x do |name, repository|

    cmd = "git remote set-url #{name} git@github.com:delphinus/#{repository}"
    puts cmd
    if opt['execute']
      system cmd
      puts "errors has occurred: #{cmd}" unless $?.success?
    end
  end
end
