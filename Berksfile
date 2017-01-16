source "https://supermarket.chef.io"
source "http://chef.typo3.org:26200"

metadata

def fixture(name)
  cookbook name, path: "test/fixtures/cookbooks/#{name}"
end

group :integration do
  cookbook 'apt'
  fixture 'otrs_test'
end
