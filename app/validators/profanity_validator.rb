# frozen_string_literal: true

class ProfanityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    if Obscenity.profane?(value)
      record.errors.add(attribute, "contains inappropriate language")
    end
  end
end
