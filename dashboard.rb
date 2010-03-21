require 'sinatra'
require 'haml'
PROJECTS = {'moo' => '?',
	    'moo2' => '?', 
	    'shavers' => '?',
	    'cfi' => '?'}

get '/?' do
	haml :index
end

post '/build/:project/:status' do |project, status|
	PROJECTS[project] = status
end

__END__
@@index
%html
  %head
    %title= "CI Dashboard"
    :javascript
      window.setTimeout('window.location.reload(true)', 20000)
    %style
      :plain
        body { font-size:3em; font-family:arial; }
        li.pass { color: #0d0; }
        li.fail { color: #d00; }
    %body
      %h2= "CI Dashboard"
      %ul
      - PROJECTS.each do |name, status|
        %li{:class => status}
          %a{:href => "/#{name}"}= "#{name}"
          (#{status})
