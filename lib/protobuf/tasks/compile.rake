namespace :protobuf do

  desc 'Clean & Compile the protobuf source to ruby classes. Pass PB_NO_CLEAN=1 if you do not want to force-clean first.'
  task :compile, [ :package, :source, :destination, :plugin ] do |tasks, args|
    args.with_defaults(:destination => 'lib')
    args.with_defaults(:source => 'definitions')
    args.with_defaults(:plugin => 'ruby')

    unless do_not_clean?
      force_clean!
      ::Rake::Task[:clean].invoke(args[:package], args[:destination])
    end

    command = []
    command << "protoc"
    command << "--#{args[:plugin]}_out=#{args[:destination]}"
    command << "-I #{args[:source]}"
    command << "#{args[:source]}/#{args[:package]}/*.proto"
    command << "#{args[:source]}/#{args[:package]}/**/*.proto"
    full_command = command.join(' ')

    puts full_command
    exec(full_command)
  end

end
