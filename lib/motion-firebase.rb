unless defined?(Motion::Project::Config)
  raise "The motion-firebase gem must be required within a RubyMotion project Rakefile."
end


Motion::Project::App.setup do |app|

  # Pods dependencies
  app.pods do
    pod 'Firebase/Database', '~> 8'
    pod 'Firebase/Auth', '~> 8'
    pod 'Firebase/Crashlytics', '~> 8'
    pod 'Firebase/Analytics', '~> 8'
    #necessary to get firebase analytics to work, otherwise fails with sqlite error
#     pod 'SQLCipher'
    # pod 'Firebase', '= 6.13'
    # pod 'FirebaseDatabase', '= 6.1.2'
    # pod 'FirebaseAuth', '= 6.4'
  end

  # scans app.files until it finds app/ (the default)
  # if found, it inserts just before those files, otherwise it will insert to
  # the end of the list
  app.files.flatten!
  insert_point = app.files.find_index { |file| file =~ /^(?:\.\/)?app\// } || 0

  Dir.glob(File.join(File.dirname(__FILE__), 'firebase/**/*.rb')).reverse.each do |file|
    app.files.insert(insert_point, file)
  end

#   app.libs += ['/usr/lib/libicucore.dylib', '/usr/lib/libc++.dylib']
  app.frameworks += ['CFNetwork', 'Security', 'SystemConfiguration']
  # for twitter or facebook
  app.weak_frameworks += ['Accounts', 'Social']

end
