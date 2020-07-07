class UserPolicy < ApplicationPolicy
  def destroy?
    user.admin? && user.id != record.id
  end
end
