# encoding: utf-8
#
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

require File.expand_path('../../test_helper', __FILE__)
require File.expand_path(File.dirname(__FILE__) + '/../../../../test/test_helper')

class RedmineInvoices::CommonViewsTest < ActiveRecord::VERSION::MAJOR >= 4 ? Redmine::ApiTest::Base : ActionController::IntegrationTest
  include RedmineInvoices::TestCase::TestHelper
  fixtures :projects,
           :users,
           :roles,
           :members,
           :member_roles,
           :issues,
           :issue_statuses,
           :versions,
           :trackers,
           :projects_trackers,
           :issue_categories,
           :enabled_modules,
           :enumerations,
           :attachments,
           :workflows,
           :custom_fields,
           :custom_values,
           :custom_fields_projects,
           :custom_fields_trackers,
           :time_entries,
           :journals,
           :journal_details,
           :queries

  fixtures :email_addresses if ActiveRecord::VERSION::MAJOR >= 4

  RedmineInvoices::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_contacts).directory + '/test/fixtures/', [:contacts,
                                                                                                                    :contacts_projects,
                                                                                                                    :contacts_issues,
                                                                                                                    :deals,
                                                                                                                    :notes,
                                                                                                                    :tags,
                                                                                                                    :taggings])

  RedmineInvoices::TestCase.create_fixtures(Redmine::Plugin.find(:redmine_contacts_invoices).directory + '/test/fixtures/', [:invoices,
                                                                                                                             :invoice_lines])

  def setup
    RedmineInvoices::TestCase.prepare

    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env['HTTP_REFERER'] = '/'
    @stub_settings = { 'invoices_company_name' => 'Your company name',
                       'invoices_company_representative' => 'Company representative name',
                       'invoices_template' => 'classic',
                       'invoices_cross_project_contacts'=> 1,
                       'invoices_number_format' => '#INV/%%YEAR%%%%MONTH%%%%DAY%%-%%ID%%',
                       'invoices_company_info' => "Your company address\nTax ID\nphone:\nfax:",
                       'invoices_company_logo_url' => "http://www.redmine.org/attachments/3458/redmine_logo_v1.png",
                       'invoices_bill_info' => "Your billing information (Bank, Address, IBAN, SWIFT & etc.)",
                       'invoices_units' => "hours\ndays\nservice\nproducts" }
  end

  test "View invoices activity" do
    with_invoice_settings @stub_settings do
      log_user("admin", "admin")
      get "/projects/ecookbook/activity?show_invoices=1"
      assert_response :success
    end
  end

  test "View invoices settings" do
    with_invoice_settings @stub_settings do
      log_user("admin", "admin")
      get "/settings/plugin/redmine_contacts_invoices"
      assert_response :success
    end
  end

  test "View invoices project settings" do
    with_invoice_settings @stub_settings do
      log_user("admin", "admin")
      get "/projects/ecookbook/settings/invoices"
      assert_response :success
    end
  end

  test "Global search with invoices" do
    with_invoice_settings @stub_settings do
      log_user("admin", "admin")
      get "/search?q=INV"
      assert_response :success
    end
  end


end
