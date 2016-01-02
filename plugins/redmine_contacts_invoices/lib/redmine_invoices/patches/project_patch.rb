# This file is a part of Redmine Invoices (redmine_contacts_invoices) plugin,
# invoicing plugin for Redmine
#
# Copyright (C) 2011-2015 Kirill Bezrukov
# http://www.redminecrm.com/
#
# redmine_contacts_invoices is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_contacts_invoices is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_contacts_invoices.  If not, see <http://www.gnu.org/licenses/>.

module RedmineInvoices
  module Patches
    module ProjectPatch
      def self.included(base) # :nodoc:
        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
          has_many :invoices, :dependent => :destroy
        end
      end
    end
  end
end

unless Project.included_modules.include?(RedmineInvoices::Patches::ProjectPatch)
  Project.send(:include, RedmineInvoices::Patches::ProjectPatch)
end
