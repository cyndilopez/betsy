class ReviewUpdateCommentDatatype < ActiveRecord::Migration[5.2]
  def change
    change_column :reviews, :comment, :string
  end
end
