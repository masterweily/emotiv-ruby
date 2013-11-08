require 'inline'
class Emotiv

	def self.bool_method(method)
		alias_method "int_#{method}", method
		define_method method do |*args|
			send("int_#{method}",*args) == 1
		end
	end
	def self.bool_methods(*methods)
		methods.each { |m| bool_method(m) }
	end

	inline(:C) do |builder|
		builder.include "<edk.h>"
		builder.c "
			int test1() 
			{
				int x = 10;
				return x;
			}
		"
		builder.c "
			int test2() 
			{
				return (1==1);
			}
		"
		builder.c "
			int test3(int num) 
			{
				return (num==10);
			}
		"

		builder.c "
			int int_connect()
			{
				return EE_EngineConnect() == EDK_OK;
			}
		"
	end
	bool_methods :test2,:test3

end

e = Emotiv.new
puts e.test1
puts e.test2
puts e.test3(1)
puts e.test3(10)
