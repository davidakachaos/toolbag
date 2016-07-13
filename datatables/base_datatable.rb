class BaseDatatable
  delegate :params, :h, :link_to, to: :@view

  def initialize(view,user,search,view_type, klass)
    @view_type = view_type
    @search = search
    @user = user
    @view = view
    @klass = klass
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: @klass.count,
        iTotalDisplayRecords: fetch.total_entries,
        aaData: data
    }
  end

  def data
    raise StadardError, "You need to overwrite the date method!"
  end

  def fetch
    @klass.accessible_by(current_ability).search(@search).order("#{sort_column} #{sort_direction}").page(page).per_page(per_page)
    #raise "#{sort_column} #{sort_direction}"
  end

  def columns
    @klass.attribute_names
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def sort_column
    columns[params[:iSortCol_0].to_i]
  end

  def current_ability
    @current_ability ||= Ability.new(@user)
  end
end