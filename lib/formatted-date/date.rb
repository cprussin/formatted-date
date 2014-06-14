require 'date'

module FormattedDate

	# This module contains instance extensions for the `Date` class.
	module DateInstanceMethods

		# Returns the word _Today_, _Tomorrow_, or _Yesterday_ as appropriate
		# relative to the passed date.
		#
		# @param date [Date] the date to compare this object with
		# @return [String] _Today_, _Tomorrow_, _Yesterday_, or `nil`
		def alternative(date = Date.today)
			if self === date
				'Today'
			elsif self === date + 1
				'Tomorrow'
			elsif self === date - 1
				'Yesterday'
			end
		end

		# If the method called was one of the keys in the `Date.formats` hash, then
		# this will return the date formatted appropriately.  If a `Date` is
		# passed, then it will be used as the reference date whenever calling
		# `Date.alternative`.
		#
		# @param method [Symbol] the name of the called method
		# @param args [Array] the arguments passed
		# @return [String] the formatted date, if the called method was a format
		# @raise [NoMethodError] if the called method was not a format
		def method_missing(method, *args)
			if self.class.formats.has_key?(method)
				format = self.class.formats[method]
				if format.is_a?(Hash)
					alt = format.has_key?(:alternatives) ? format[:alternatives] : true
					format = format[:format]
				else
					alt = true
				end
				if alt
					args.empty? ? alternative : alternative(args.first)
				end || strftime(format)
			else
				super
			end
		end
	end

	# This module contains class extensions for the `Date` class.
	module DateClassMethods

		# This hash lists recognized formats on the `Date` class.  The keys are the
		# symbol names of the formats.  The values can be in one of two formats:
		#
		# - **A string**: this string is passed to `strftime` when using this
		#   format
		# - **A hash**: this hash has two keys:
		#   - **format**: this string is passed to strftime when using this format.
		#     The same as if the format was specified only with a string.
		#   - **alternatives**: `false` if you don't want the format to be replaced
		#     by the words _Today_, _Tomorrow_, or _Yesterday_, as appropriate.
		attr_accessor :formats
	end

	Date.include(DateInstanceMethods)
	Date.extend(DateClassMethods)
end
