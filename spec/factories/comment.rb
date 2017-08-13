FactoryGirl.define do
  factory :comment, :class => 'Comment' do
	content ('лучшая статья в мире ' + Time.now.to_i.to_s)
  end
end