FactoryGirl.define do
  factory :article, :class => 'Article' do
	title ('тест_' + Time.now.to_i.to_s)
	content 'в лесу родилась ёлочка'
	tag_list 'ёлка волк зима лес'
  end
end