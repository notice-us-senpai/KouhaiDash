module GroupsHelper
  def is_user_of_group?(group)
    logged_in? && !Membership.where(user_id: current_user.id, group_id: group.id, approved: true).empty?
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
      array.push({name: cat.name, path: [group,cat]})
    end
    #logger.info array.size.to_s + "number of element(s)\n"
    return array
  end
end
