class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence:true
  validates :content, presence: true, length:{maximum:140}
  mount_uploader :picture, PictureUploader
  default_scope -> {order(created_at: :desc)}
  validate :picture_size



  private
    def picture_size
      #self can be ignorred inside the model
      if picture.size>5.megabytes
        errors.add(:picture, 'should be less than 5 megabytes')
      end
    end
end
