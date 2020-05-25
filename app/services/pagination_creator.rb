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
      links: generate_link()
    }
  end

  def generate_link
    {
      self: current_link(),
      next: next_link(),
    }
  end

  def current_link
    "#{@base_url}/v1/patients?page_number=#{@page_index+1}"
  end

  def next_link
    if Patient.count > (@page_index+1) * PAGINATION_SIZE
      "#{@base_url}/v1/patients?page_number=#{@page_index+2}"
    else
      nil
    end
  end
end
