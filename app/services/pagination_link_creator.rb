class PaginationLinkCreator
  def initialize(base_url, page_index, page_size)
    @base_url = base_url
    @page_index = page_index
    @page_size = page_size
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
    if Patient.count > (@page_index+1) * @page_size
      "#{@base_url}/v1/patients?page_number=#{@page_index+2}"
    else
      nil
    end
  end
end
