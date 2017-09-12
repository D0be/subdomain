require 'coderay'

code = File.read('/tmp/mypoc/testApkTool.rb')

html = CodeRay.scan(code, :ruby).div(:line_numbers => :table)

puts html
