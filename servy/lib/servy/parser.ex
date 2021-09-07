defmodule Servy.Parser do 

	alias Servy.Conv, as: StructConv
	def parse(request) do
 		# TODO: Parse the request string into a map:
 		[method, path, _] = 
 			request 
 			|> String.split("\n")
 			|> List.first #get first line @ vid.4
 			|>String.split(" ") #assigned every string to variable @vid.4
  		
  		%StructConv{ 
  			method: method, 
  			path: path,  
  			}
	end

end