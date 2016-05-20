module GroupsHelper
  def is_user_of_group?(group)
    logged_in? && !Membership.where(user_id: current_user.id).where(group_id: group.id).empty?
  end

  # returns array of hash of category name and associated path
  def get_categories_and_path(group)
    categories = if is_user_of_group?(group)
      group.categories
    else
      group.categories.is_public
    end
    array =[]
    categories.each do |cat|
      path = case cat.type_no
      when 1
        root_path #org profile
      when 2
        root_path #calendar
      when 3
        root_path #task
      when 4
        root_path #file
      when 5
        root_path #contacts
      else
        nil
      end
      array.push({name: cat.name, path: path}) if path
    end
    logger.info array.size.to_s + "number of element(s)\n"
    return array
  end
end
