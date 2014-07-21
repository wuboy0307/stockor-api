notification :growl

guard :minitest, :all_on_start => false do
    watch(%r{^test/test_helper\.rb}) { 'test' }
    watch(%r{^lib/skr/api/controller\.rb}) { 'test/controller_test.rb' }

    watch(%r{^test/.+_test\.rb})
    watch(%r{^test/fixtures/skr/(.+)s\.yml})   { |m| "test/#{m[1]}_test.rb" }

    watch(%r{^lib/skr/(.+)\.rb})               { |m| "test/#{m[1]}_test.rb"          }
    watch(%r{^lib/skr/api/(.+)\.rb})           { |m| "test/core/#{m[1]}_test.rb"     }

end
