defmodule Servy.Plugins do 

	alias Servy.Conv, as: StructConv
	@doc "logs 404 requests."
	def track(%StructConv{status: 404, path: path} = conv) do
		IO.puts "Warning #{path} is on the loose!"
		conv
	end

	def track(%StructConv{} = conv), do: conv

	def rewrite_path(%StructConv{path: "/wildlife"} = conv) do
		%{conv | path: "/wildthings"} 
	
	end

	def rewrite_path(%StructConv{} = conv), do: conv

	def log(%StructConv{} = conv), do: IO.inspect conv
end