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
  module InvoiceReports
    class << self
      include Redmine::I18n
      include InvoicesHelper
      include RedmineCrm::MoneyHelper

      def invoice_to_pdf_prawn(invoice, type)
        saved_language = User.current.language
        set_language_if_valid(invoice.language || User.current.language)
        s = invoice_to_pdf_classic(invoice)
        set_language_if_valid(saved_language)
        s
      end

      def invoice_to_pdf_classic(invoice)
        pdf = Prawn::Document.new(:info => {
            :Title => "#{l(:label_invoice)} - #{invoice.number}",
            :Author => User.current.name,
            :Producer => InvoicesSettings[:invoices_company_name, invoice.project].to_s,
            :Subject => "Invoice",
            :Keywords => "invoice",
            :Creator => InvoicesSettings[:invoices_company_name, invoice.project].to_s,
            :CreationDate => Time.now,
            :TotalAmount => price_to_currency(invoice.amount, invoice.currency, :converted => false, :symbol => false),
            :TaxAmount => price_to_currency(invoice.tax_amount, invoice.currency, :converted => false, :symbol => false),
            :Discount => price_to_currency(invoice.discount_amount, invoice.currency, :converted => false, :symbol => false)
            },
            :margin => [50, 50, 60, 50])
        contact = invoice.contact || Contact.new(:first_name => '[New client]', :address_attributes => {:street1 => '[New client address]'}, :phone => '[phone]')

        fonts_path = "#{Rails.root}/plugins/redmine_contacts_invoices/lib/fonts/"
        pdf.font_families.update(
               "FreeSans" => { :bold => fonts_path + "FreeSansBold.ttf",
                               :italic => fonts_path + "FreeSansOblique.ttf",
                               :bold_italic => fonts_path + "FreeSansBoldOblique.ttf",
                               :normal => fonts_path + "FreeSans.ttf" })

        pdf.font("FreeSans", :size => 9)
        pdf.default_leading -5

        pdf.text l(:field_invoice_number) + ": " + invoice.number, :style => :bold
        pdf.text l(:field_invoice_date) + ": " + invoice.invoice_date.strftime("%d/%m/%Y"), :style => :bold

        pdf.move_down(10)

        pdf.text InvoicesSettings[:invoices_company_name, invoice.project].to_s, :style => :bold, :size => 18
        pdf.text InvoicesSettings[:invoices_company_representative, invoice.project].to_s if InvoicesSettings[:invoices_company_representative, invoice.project]
        pdf.text_box "#{InvoicesSettings[:invoices_company_info, invoice.project].to_s}", :at => [0, pdf.cursor], :width => 140

        pdf.bounding_box [pdf.bounds.width - 250, pdf.bounds.height - 28], :width => 250 do
          pdf.text contact.name, :style => :bold, :size => 18
          if contact.address
            pdf.text_box contact.post_address, :at => [0, pdf.cursor], :width => 140
          end
          pdf.text get_contact_extra_field(contact)
          pdf.move_down(90)
        end
        classic_table(pdf, invoice)
        if InvoicesSettings[:invoices_bill_info, invoice.project]
          pdf.text InvoicesSettings[:invoices_bill_info, invoice.project]
        end
        pdf.move_down(10)
        pdf.text invoice.description
        pdf.number_pages "<page>/<total>", {:at => [pdf.bounds.right - 150, -10], :width => 150,
                  :align => :right} if pdf.page_number > 1
        pdf.repeat(lambda{ |pg| pg > 1}) do
           pdf.draw_text "##{invoice.number}", :at => [0, -20]
        end

        pdf.render
      end

      def status_stamp(pdf, invoice)
        case invoice.status_id
        when Invoice::DRAFT_INVOICE
          stamp_text = "DRAFT"
          stamp_color = "993333"
        when Invoice::PAID_INVOICE
          stamp_text = "PAID"
          stamp_color = "1e9237"
        else
          stamp_text = ""
          stamp_color = "1e9237"
        end

        stamp_text_width = pdf.width_of(stamp_text, :font => "Times-Roman", :style => :bold, :size => 120)
        pdf.create_stamp("draft") do
          pdf.rotate(30, :origin => [0, 50]) do
            pdf.fill_color stamp_color
            pdf.font("Times-Roman", :style => :bold, :size => 120) do
              pdf.transparent(0.08) {pdf.draw_text stamp_text, :at => [0, 0]}
            end
            pdf.fill_color "000000"
          end
        end

        pdf.stamp_at "draft", [(pdf.bounds.width / 2) - stamp_text_width / 2, (pdf.bounds.height / 2) ] unless stamp_text.blank?
      end

      def classic_table(pdf, invoice)
        lines = invoice.lines.map do |line|
          [
            line.position,
            line.description,
            "x#{invoice_number_format(line.quantity)}",
            line.units,
            price_to_currency(line.price, invoice.currency, :converted => false, :symbol => false),
            price_to_currency(line.total, invoice.currency, :converted => false, :symbol => false)
          ]
        end
        lines.insert(0,[l(:field_invoice_line_position),
                   l(:field_invoice_line_description),
                   l(:field_invoice_line_quantity),
                   l(:field_invoice_line_units),
                   label_with_currency(:field_invoice_line_price, invoice.currency),
                   label_with_currency(:label_invoice_total, invoice.currency) ])  
        lines << ['']


    
    pdf.table lines, :width => pdf.bounds.width, 
                     :cell_style => {:borders => [:top, :bottom], 
                                     :border_color => "cccccc",
                                     :padding => [0, 5, 6, 5]}, 
                     :header => true do |t|
      # t.cells.padding = 405
      t.columns(0).width = 20
      t.columns(2).align = :center
      t.columns(2).width = 40
      t.columns(3).align = :center
      t.columns(3).width = 50
      t.columns(4..5).align = :right
      t.columns(4..5).width = 90
      t.row(0).font_style = :bold

      max_width =  t.columns(0).inject(0) { |width, cell| [width, pdf.width_of(cell.content, :style => :bold) + 15].max }
      t.columns(0).width = max_width if max_width < 100 

      max_width =  t.columns(2).inject(0) { |width, cell| [width, pdf.width_of(cell.content, :style => :bold) + 15].max }
      t.columns(2).width = max_width if max_width < 100 
      
      max_width =  t.columns(3).inject(0) { |width, cell| [width, pdf.width_of(cell.content, :style => :bold) + 15].max }
      t.columns(3).width = max_width if max_width < 100 
      
      max_width =  t.columns(4).inject(0) { |width, cell| [width, pdf.width_of(cell.content, :style => :bold) + 15].max }
      t.columns(4).width = max_width if max_width < 120 
      
      max_width =  t.columns(5).inject(0) { |width, cell| [width, pdf.width_of(cell.content, :style => :bold) + 15].max }
      t.columns(5).width = max_width if max_width < 120 

      t.row(0).borders = [:top]
      t.row(0).border_color = "000000"
      t.row(0).border_width = 1.5
      
      t.row(invoice.lines.count + 1).borders = []
      t.row(invoice.lines.count).borders = [:bottom, :top]
      t.row(invoice.lines.count).border_bottom_color = "000000"
      t.row(invoice.lines.count).border_bottom_width = 1.5
      
      t.row(invoice.lines.count + 2).padding = [5, 5, 3, 5]

      t.row(invoice.lines.count + 2..invoice.lines.count + 6).borders = []
      t.row(invoice.lines.count + 2..invoice.lines.count + 6).font_style = :bold      
    end
  end
  end
  end
end




