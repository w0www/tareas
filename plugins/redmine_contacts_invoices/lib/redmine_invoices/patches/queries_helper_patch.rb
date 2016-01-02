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

require_dependency 'queries_helper'

module RedmineInvoices
  module Patches
    module QueriesHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable
          alias_method_chain :column_value, :invoices
        end
      end


      module InstanceMethods
        def column_value_with_invoices(column, list_object, value)
          if column.name == :subject && list_object.is_a?(Invoice)
            list_object.subject
          elsif column.name == :number && list_object.is_a?(Invoice)
            link_to(list_object.number, invoice_path(list_object))
          elsif column.name == :invoice_date && list_object.is_a?(Invoice)
            format_date(list_object.invoice_date)
          elsif column.name == :due_date && list_object.is_a?(Invoice)
            format_date(list_object.due_date)
          elsif [:amount, :price].include?(column.name) && list_object.is_a?(Invoice)
            list_object.send("#{column.name.to_s}_to_s")
          elsif [:balance, :remaining_balance].include?(column.name) && list_object.is_a?(Invoice)
            list_object.send("#{column.name.to_s}_to_s") if (list_object.is_paid? || list_object.is_sent?)
          elsif value.is_a?(Invoice)
            invoice_tag(value, :no_contact => true, :plain => true)
          else
            column_value_without_invoices(column, list_object, value)
          end
        end

      end

    end
  end
end

unless QueriesHelper.included_modules.include?(RedmineInvoices::Patches::QueriesHelperPatch)
  QueriesHelper.send(:include, RedmineInvoices::Patches::QueriesHelperPatch)
end
