module GroupsHelper
  # approved member
  def is_user_of_group?(group)
    logged_in? && !Membership.where(user_id: current_user.id, group_id: group.id, approved: true).empty?
  end

  # not approved member
  def is_a_not_yet_approved_member_of_group?(group)
    logged_in? && !Membership.where(user_id: current_user.id, group_id: group.id, approved: false).empty?
  end

  def is_a_member_of_group?(group)
    logged_in? && !Membership.where(user_id: current_user.id, group_id: group.id).empty?
  end

  # returns array of hash of category name and associated path
  def get_categories_and_path(group)
    categories = if is_user_of_group?(group)
      group.categories.order(:order_no)
    else
      group.categories.is_public.order(:order_no)
    end
    array =[]
    categories.each do |cat|
      array.push({name: cat.name, path: [group,cat]}) if cat.id
    end
    #logger.info array.size.to_s + "number of element(s)\n"
    return array
  end

  def check_category_edit_auth(group,category)
    unless is_user_of_group? group
      flash[:notice] = "Join the group to make a change!"
      redirect_to [group,category]
    end
  end

  def check_category_view_auth(group,category)
    unless category.is_public || is_user_of_group?(group)
      flash[:notice] = "Join the group to see more!"
      redirect_to group
    end
  end

end
