# [Formatted Date](https://connor.prussin.net/formatted-date)

Formatting extensions for ruby time classes.

[![Gem Version](https://badge.fury.io/rb/formatted-date.svg)](http://rubygems.org/gems/formatted-date) [![Build Status](https://api.travis-ci.org/cprussin/formatted-date.svg?branch=master)](https://travis-ci.org/cprussin/formatted-date) [![Code Climate](https://codeclimate.com/github/cprussin/formatted-date.png)](https://codeclimate.com/github/cprussin/formatted-date) [![Dependency Status](https://gemnasium.com/cprussin/formatted-date.svg)](https://gemnasium.com/cprussin/formatted-date)

## Description

Formatted Date extends the ruby built-in `Date`, `Time`, and `DateTime` classes
to allow easier access to consistent output formats.

## Install

Manually:

```bash
gem install formatted-date
```

or with Bundler (add to your `Gemfile`):

```ruby
gem 'formatted-date'
```

## Usage

```ruby
require 'formatted-date'

Date.formats = {long: '%A, %B %-d, %Y'}
date = Date.new(2014, 6, 11)
date.long            # => 'Wednesday, June 11, 2014'
date.long(date + 1)  # => 'Yesterday'
date.long(date)      # => 'Today'
date.long(date - 1)  # => 'Tomorrow'
```

## Extended Classes

This gem extends the `Date`, `Time`, and `DateTime` classes to provide named
formats.  Formats are specified by setting the `formats` class variable for
each class.  They are called by simply using dot notation; this gem uses
`method_missing` to provide dynamic methods so as long as the format is in the
`formats` hash, it will be available.

## Alternatives

When generating formatted strings, this library will try to replace date and
time parts with such short alternatives as _Today_, _Tomorrow_, _Yesterday_,
_Midnight_, and _Noon_.  This behavior can be suppressed on a per-format basis
by using appropriate parameters in the `formats` hash.

## The Formats Hash

For each key-value pair in the `formats` hash, the key specifies the name of
the format, and the method used to format the object.  Make sure the format
name does not clash with any method names on the objects, or you will be unable
to use the format.

The values are generally hashes, but can be strings for `Date` objects.  If the
value is a string, it is passed on to `strftime` when getting the formatted
object.  If it is a hash, then the keys expected are (for `Date` objects):

- **format**: the format string used for `strftime`
- **alternatives**: `false` if you don't want the format to be replaced by the
  words _Today_, _Tomorrow_, or _Yesterday_, as appropriate.

For `DateTime` and `Time` objects, the values must be hashes.  The keys of
these hashes are:

- **date**: the `strftime` format for the date part
- **time**: the `strftime` format for the time part
- **glue**: text to put between between the date and time parts (e.g. 'on'),
  surrounding spaces added automatically
- **alternatives**: `false` to suppress using alternatives like _Today_,
  _Midnight_, or _Noon_, `:date` to only use date alternatives, and `:time` to
  only use time alternatives
