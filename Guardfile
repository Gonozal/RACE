# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# guard 'livereload' do
#   watch(%r{app/.+\.(html\.erb|haml|slim)})
#   watch(%r{app/helpers/.+\.rb})
#   watch(%r{(public/|app/assets).+\.(css|js|html|slim)})
#   watch(%r{(app/assets/.+\.css)\.scss}) { |m| m[1] }
#   watch(%r{(app/assets/.+\.js)\.coffee}) { |m| m[1] }
#   watch(%r{config/locales/.+\.yml})
# end

# guard 'yard' do
#   watch(%r{app/.+\.rb})
#   watch(%r{lib/.+\.rb})
#   watch(%r{ext/.+\.c})
# end

# guard 'spork' do
#   watch('config/application.rb')
#   watch('config/environment.rb')
#   watch(%r{^config/environments/.+\.rb$})
#   watch(%r{^config/initializers/.+\.rb$})
#   watch('spec/spec_helper.rb')
# end

# guard 'minitest' do
#   # with Minitest::Unit
#   watch(%r|^test/test_(.*)\.rb|)
#   watch(%r|^lib/(.*)([^/]+)\.rb|)     { |m| "test/#{m[1]}test_#{m[2]}.rb" }
#   watch(%r|^test/test_helper\.rb|)    { "test" }
# 
#   # with Minitest::Spec
#   # watch(%r|^spec/(.*)_spec\.rb|)
#   # watch(%r|^lib/(.*)\.rb|)            { |m| "spec/#{m[1]}_spec.rb" }
#   # watch(%r|^spec/spec_helper\.rb|)    { "spec" }
# end

# guard 'cucumber', :cli => '-s --drb -p guard'    do
#   watch(%r{^features/.+\.feature$})
#   watch(%r{^features/support/.+$})          { 'features' }
#   watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
# end

guard 'rspec', :version => 2 do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails example
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
  # Capybara request specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { |m| "spec/requests/#{m[1]}_spec.rb" }
end