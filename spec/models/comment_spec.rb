require 'rails_helper'

RSpec.describe Comment, type: :model do
  it {should validate_presence_of :article_id}
  it {should validate_presence_of :content}
end
