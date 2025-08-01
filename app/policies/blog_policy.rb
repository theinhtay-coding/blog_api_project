class BlogPolicy < ApplicationPolicy
  def index?
    admin? || user?
  end

  # def index?
  #   allowed_roles = [:admin, :user, :editor]
  #   allowed_roles.include?(user[:role].to_sym)
  # end

  def create?
    admin? || user?
  end

  def show?
    admin? || user?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def export?
    admin? || user?
  end

  def user?
    user[:role].to_sym == :user
  end
  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
