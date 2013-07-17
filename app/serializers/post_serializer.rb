class PostSerializer < ActiveModel::Serializer
  attributes :id, :name, :image, :uid, :shelter,
  :state, :city, :story, :share_count,
  :adopted, :promoted

  def share_count
    object.share_count || object.real_share_count
  end

  def image
    object.image.url(:gallery)
  end
end
