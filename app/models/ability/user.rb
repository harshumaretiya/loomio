module Ability::User
  def initialize(user)
    super(user)

    can :show, ::User do |u|
      user.is_logged_in? && u.deactivated_at.nil?
    end

    can [:update,
         :see_notifications_for,
         :subscribe_to], ::User do |u|
      user == u
    end

    can [:deactivate], ::User do |u|
      (user == u || user.is_admin?) && u.deactivated_at.nil?
    end

    can [:redact], ::User do |u|
      (user == u || user.is_admin?) && !u.email.nil?
    end

    can [:contact], ::User do |u|
      ContactableQuery.contactable(actor: user, user: u)
    end
  end
end
