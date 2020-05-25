class PaginationCreator
  PAGINATION_SIZE = 10
  
  def initialize(base_url, page_index)
    @base_url = base_url
    @page_index = page_index
  end

  def generate_pagination
    {
      data:
        Patient.get_one_page(PAGINATION_SIZE, @page_index)
          .to_a
          .map { |p| p.generate_patient_response(@base_url) },
      links: generate_links()
    }
  end

  def generate_links
    {
      self: format_link(which_page: :current),
      next: next_link(),
    }
  end

  def next_link
    if Patient.count > (@page_index+1) * PAGINATION_SIZE
      format_link(which_page: :next)
    else
      nil
    end
  end

  def format_link(which_page:)
    "#{@base_url}/v1/patients?page_number=#{@page_index + (which_page == :current ? 1 : 2)}"
  end
end
