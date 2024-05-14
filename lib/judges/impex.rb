# frozen_string_literal: true

# Copyright (c) 2024 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'factbase'
require 'fileutils'
require_relative '../judges'

# Import/Export of factbases.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
class Judges::Impex
  def initialize(loog, file)
    @loog = loog
    @file = file
  end

  def import(strict: true)
    fb = Factbase.new
    if File.exist?(@file)
      fb.import(File.binread(@file))
      @loog.info("The factbase imported from #{@file.to_rel} (#{File.size(@file)} bytes)")
    elsif strict
      raise "The factbase is absent at #{@file.to_rel}"
    end
    fb
  end

  def import_to(fb)
    raise "The factbase is absent at #{@file.to_rel}" unless File.exist?(@file)
    fb.import(File.binread(@file))
    @loog.info("The factbase loaded from #{@file.to_rel} (#{File.size(@file)} bytes)")
  end

  def export(fb)
    FileUtils.mkdir_p(File.dirname(@file))
    File.binwrite(@file, fb.export)
    @loog.info("Factbase exported to #{@file.to_rel} (#{File.size(@file)} bytes)")
  end
end
