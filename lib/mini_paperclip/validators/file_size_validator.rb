# frozen_string_literal: true

module MiniPaperclip
  module Validators
    class FileSizeValidator < ActiveModel::EachValidator
      def validate_each(record, attribute, value)
        attachment_file_size_name = "#{attribute}_file_size"
        attachment_file_size = record.read_attribute_for_validation(attachment_file_size_name)
        if attachment_file_size
          if check_value = options[:less_than]
            unless attachment_file_size < check_value
              count = ActiveSupport::NumberHelper.number_to_human_size(check_value)
              record.errors.add(attribute, :less_than, count: count)
              record.errors.add(attachment_file_size_name, :less_than, count: count)
            end
          end

          if check_value = options[:greater_than]
            unless attachment_file_size > check_value
              count = ActiveSupport::NumberHelper.number_to_human_size(check_value)
              record.errors.add(attribute, :greater_than, count: count)
              record.errors.add(attachment_file_size_name, :greater_than, count: count)
            end
          end

          if check_value = (options[:within] || options[:in])
            unless check_value.include?(attachment_file_size)
              record.errors.add(attribute, :within, count: formatted_range(check_value))
              record.errors.add(attachment_file_size_name, :within, count: formatted_range(check_value))
            end
          end
        end
      end

      private

      def formatted_range(range)
        dots = range.exclude_end? ? "..." : ".."
        first = ActiveSupport::NumberHelper.number_to_human_size(range.begin)
        last = ActiveSupport::NumberHelper.number_to_human_size(range.last)
        "#{first}#{dots}#{last}"
      end
    end
  end
end
