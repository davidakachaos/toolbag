class UsersDatatable < BaseDatatable

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: User.count,
        iTotalDisplayRecords: users.total_entries,
        aaData: data
    }
  end

  private

  def data
    users.map do |user|
      [
          user.username,
          user.email,
          user.sign_in_count,
          user.last_sign_in_at? ? user.last_sign_in_at.strftime("%d-%m-%Y %H:%M") : nil,
          user.last_sign_in_ip,
          user.user_role,
          determin_buttons(user)
      ]
    end
  end

  def determin_buttons(user)
    #Get buttons for this user
    buttons = "<img src='/assets/icons/edit.png' class='edit' title='#{I18n.t('table_user.edit')}' data-url='user/#{user.id}/edit' data-div='#user-form' data-width='800' data-height='660' data-title='#{I18n.t('table_user.edit')}' data-form='.edit_user' />"

    buttons += "#{@view.link_to @view.raw("<img src='/assets/icons/trash.png' class='trash' title='#{I18n.t('table_user.delete')}' />"), user, :confirm => I18n.t('general.confirm'), :method => :delete}"
    
    buttons
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    puts "params: #{params.inspect}"
    params[:search].delete(:meta_sort) if params[:search] && params[:search][:meta_sort]
    if params[:client]
      users = User.search(params[:search])
    else
      users = User.for_overview.search(params[:search])
    end

    if params[:sSearch].present?
      users = users.where("lower(username) like lower(:search) or lower(email) like lower(:search)", search: "%#{params[:sSearch]}%")
    end

    users = users.page(page).per_page(per_page).order("#{sort_column} #{sort_direction}")

    users
  end

  def sort_column
    columns = %w[ username email sign_in_count DATE(last_sign_in_at) last_sign_in_ip role_id id ]
    columns[params[:iSortCol_0].to_i]
  end

end