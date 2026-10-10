# frozen_string_literal: true

require 'rake/testtask'

Rake::TestTask.new(:test) do |test_task|
  test_task.libs << 'lib' << 'test'
  test_task.test_files = FileList['test/**/*_test.rb']
  test_task.warning = true
end

task default: :test
