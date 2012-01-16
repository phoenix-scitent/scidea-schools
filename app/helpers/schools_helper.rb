module SchoolsHelper

  def school_selected_id(school, params)
    if school && !school.new_record?
      school.id
    elsif params[:user] and params[:user][:profile_attributes] and params[:user][:profile_attributes][:school_id]
      params[:user][:profile_attributes][:school_id]
    else
      ''
    end
  end

  def school_select_zipcode(school, params)
    if school && !school.new_record?
      school.zipcode
    else
      params[:school_zipcode] || ''
    end
  end

end

