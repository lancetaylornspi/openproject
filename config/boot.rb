#-- encoding: UTF-8
#-- copyright
# OpenProject is an open source project management software.
# Copyright (C) 2012-2020 the OpenProject GmbH
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See docs/COPYRIGHT.rdoc for more details.
#++

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

# Load any local boot extras that is kept out of source control
# (e.g., silencing of deprecations)
if File.exists?(File.join(File.dirname(__FILE__), 'additional_boot.rb'))
  instance_eval File.read(File.join(File.dirname(__FILE__), 'additional_boot.rb'))
end

require 'bundler/setup' # Set up gems listed in the Gemfile.

env = ENV['RAILS_ENV']
# Disable deprecation warnings early on (before loading gems), which behaves as RUBYOPT="-w0"
# to disable the Ruby 2.7 warnings in production.
# Set OPENPROJECT_PROD_DEPRECATIONS=true if you want to see them for debugging purposes
if env == 'production' && ENV['OPENPROJECT_PROD_DEPRECATIONS'] != 'true'
  require 'structured_warnings'
  Warning[:deprecated] = false
  StructuredWarnings::BuiltInWarning.disable
  StructuredWarnings::DeprecationWarning.disable
end

if env == 'development'
  $stderr.puts "Starting with bootsnap."
  require 'bootsnap/setup' # Speed up boot time by caching expensive operations.
end
