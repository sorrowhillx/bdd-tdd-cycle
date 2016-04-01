# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
end

Then /I should (not )?see movies rated: (.*)/ do |negation, rating_list|
  if rating_list.eql?("all")
    ratings = Movie.group(:rating).map(&:rating)
  else
    ratings = rating_list.split(",")
    ratings = Movie.all_ratings - ratings if negation
  end
  db_size = filtered_movies = Movie.find(:all, :conditions => {:rating => ratings}).size
  #or Movie.select{ |x| ratings.include?(x.rating).count
  page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{db_size} ]")
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.delete!("\"")
  if uncheck.nil?
    rating_list.split(',').each do |field|
      check(field)
    end
  else
    rating_list.split(',').each do |field|
      uncheck(field)
    end
  end
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  # making sure that e1 appears before e2
  body = page.body.to_s
  e1_index = body.index(e1)
  e2_index = body.index(e2)
  assert e1_index < e2_index
end


Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
 Movie.find_by_title(arg1).director == arg2
end

Then /I should see all of the movies/ do
  page.should have_css("table#movies tbody tr",:count => value.to_i)
end

Then /I should not see all of the movies/ do
  page.should have_no_css("table#movies tbody tr")
end