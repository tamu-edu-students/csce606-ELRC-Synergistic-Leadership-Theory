# frozen_string_literal: true

module Services
  # Paginate an ActiveRecord collection
  class Pagination
    attr_reader :collection, :params, :sections, :offsets

    def initialize(collection, params = {})
      @collection = collection
      @params = params.merge(count: effective_count(params[:per_page]))
    end

    def cumsum(arr)
      arr.inject([0]) { |(p, *ps), v| [v + p, p, *ps] }.reverse[1..]
    end

    def next_multiple(val, base)
      val + base - 1 - ((val + base - 1) % base)
    end

    def effective_count(per_page)
      counts = collection.group(:section).count.values
      rounded_counts = counts.map { |v| next_multiple v, per_page }

      @sections = cumsum rounded_counts

      @offsets = counts.map.with_index { |count, i| rounded_counts[i] - count }

      rounded_counts.reduce(0) { |acc, count| acc + count }
    end

    def section(offset = nil)
      offset ||= metadata.offset
      sections.each_index.detect { |i| sections[i] > offset } || 0
    end

    def effective_offset
      offset = metadata.offset

      return offset if section.zero?

      offsets.take(section).each { |value| offset -= value }

      offset
    end

    def effective_limit
      limit = metadata.per_page

      return limit if section(metadata.offset) == section(metadata.offset + metadata.per_page)

      metadata.per_page - offsets[section]
    end

    def metadata
      @metadata ||= ViewModel::Pagination.new(params)
    end

    def results
      collection
        .limit(effective_limit)
        .offset(effective_offset)
    end
  end
end

module ViewModel
  # Paginate an ActiveRecord collection
  class Pagination
    DEFAULT = {
      page: 6,
      per_page: 6
    }.freeze

    attr_reader :page, :count, :per_page

    def initialize(params = {})
      @page = (params[:page] || DEFAULT[:page]).to_i
      @count = params[:count]
      @per_page = params[:per_page] || DEFAULT[:per_page]
    end

    def offset
      return 0 if page <= 1

      per_page * (page.to_i - 1)
    end

    def next_page
      page + 1 unless last_page?
    end

    def next_page?
      page < total_pages
    end

    def prev_page
      page - 1 unless first_page?
    end

    def prev_page?
      page > 1
    end

    def last_page?
      page == total_pages
    end

    def first_page?
      page == 1
    end

    def total_pages
      (count / per_page.to_f).ceil.to_i
    end
  end
end

# Paginate a SurveyQuestion collection
module Pagination
  def paginate(collection:, params: {})
    pagination = Services::Pagination.new(collection, params)

    [pagination.metadata, pagination.results, pagination.section]
  end
end
