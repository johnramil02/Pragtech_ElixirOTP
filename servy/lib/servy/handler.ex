defmodule Servy.Handler do 
	@moduledoc "Handles http requests."

	@pages_path File.read("lib/pages/about.html")

	@doc "Transforms a request into a response."

	import Servy.Plugins
	import Servy.Parser

	alias Servy.Conv, as: StructConv

	def handle(request)do
	# transform to pipe line vid.3 
		request
		|> parse
		|> rewrite_path
		|> log	
		|> route
		|> track
		|> format_response
	
	end

	
	def route(%StructConv{ method: "GET", path: "/wildthings"} = conv) do 
		%{ conv | status: 200, resp_body: "Bears, Lions, Tigers"}
	end

	def route(%StructConv{ method: "GET", path: "/bears"} = conv) do
		%{ conv | status: 200, resp_body: "Teddy, Panda, Polar"}
	end

	def route(%StructConv{ method: "GET", path: "/bears/" <> id} = conv) do 
		%{ conv | status: 200, resp_body: "Bear #{id}" }
	end

	
	def route(%StructConv{ method: "GET", path: "/about"} = conv) do 
		@pages_path
		|> handle_file(conv)
	end
	
	def handle_file({:ok, content},conv)do 
		%{ conv | status: 200, resp_body: content }
	end 

	def handle_file({:error, :enoent},conv)do 
		%{ conv | status: 404, resp_body: "File not found" }
	end

	def handle_file({:error, reason},conv)do 
		%{ conv | status: 500, resp_body: "File error: #{reason}"}
	end
			

	def route(%StructConv{path: path} =conv) do
  		%{ conv | status: 404, resp_body: "No #{path} here!"}
	end


	def format_response(%StructConv{} = conv) do
  		# TODO: Use values in the map to create an HTTP response string:
  		"""
  		#making format_response dynamic @vid.5 - 7

  		HTTP/1.1 #{StructConv.full_status(conv)}
  		Content-Type: text/html
  		Content-Length: #{String.length(conv.resp_body)}

  		#{conv.resp_body}
 		"""
	end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Servy.Handler.handle(request)

IO.puts response
