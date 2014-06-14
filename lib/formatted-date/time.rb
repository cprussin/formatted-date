require 'date'

module FormattedDate

	# This module contains instance extensions for the `Time` and `DateTime`
	# classes.
	module TimeInstanceMethods

		# Returns the word _Today_, _Tomorrow_, or _Yesterday_ as appropriate
		# relative to the passed date.
		#
		# @param date [Date] the date to compare this object with
		# @return [String] _Today_, _Tomorrow_, _Yesterday_, or `nil`
		def date_alternative(date = Date.today)
			to_date.alternative(date)
		end

		# Returns the word _Midnight_ or _Noon_ as appropriate for this time.
		#
		# @return [String] _Midnight_, _Noon_, or `nil`
		def time_alternative
			if hour == 0 && min == 0 && sec == 0
				'Midnight'
			elsif hour == 12 && min == 0 && sec == 0
				'Noon'
			end
		end

		# If the method called was one of the keys in the `formats` hash, then this
		# will return the time object formatted appropriately.  If a `Date` is
		# passed, then it will be used as the reference date whenever calling
		# `date_alternative`.
		#
		# @param method [Symbol] the name of the called method
		# @param args [Array] the arguments passed
		# @return [String] the formatted date, if the called method was a format
		# @raise [NoMethodError] if the called method was not a format
		def method_missing(method, *args)
			if self.class.formats.has_key?(method)
				format = self.class.formats[method]
				alt = format[:alternatives]
				str = []
				if format.has_key?(:date)
					str << (if alt.nil? || [true, :date].include?(alt)
						args.empty? ? date_alternative : date_alternative(args.first)
					end || strftime(format[:date]))
				end
				str << format[:glue] if format.has_key?(:glue)
				if format.has_key?(:time)
					str << (if alt.nil? || [true, :time].include?(alt)
						time_alternative
					end || strftime(format[:time]))
				end
				str.join(' ')
			else
				super
			end
		end
	end

	# This module contains class extensions for the `Time` and `DateTime`
	# classes.
	module TimeClassMethods

		# This hash lists recognized formats for time classes.  The keys are the
		# symbol names of the formats.  The values are hashes with the following
		# keys (note that each key is optional and if left out, the corresponding
		# section will be hidden from formatted output):
		#
		# - **date**: the `strftime` format for the date part
		# - **time**: the `strftime` format for the time part
		# - **glue**: text to put between between the date and time parts (e.g.
		#   'on'), surrounding spaces added automatically
		# - **alternatives**: `false` to suppress using alternatives like _Today_,
		#   _Midnight_, or _Noon_, `:date` to only use date alternatives, and
		#   `:time` to only use time alternatives
		attr_accessor :formats
	end

	DateTime.include(TimeInstanceMethods)
	DateTime.extend(TimeClassMethods)
	Time.include(TimeInstanceMethods)
	Time.extend(TimeClassMethods)
end
