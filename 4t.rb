#!/usr/bin/ruby

require 'time'


def get_new_id
  case RUBY_PLATFORM
  when /linux/
    return `uuidgen`.strip
  else
    raise 'UUID generation is not yet supported on #{RUBY_PLATFORM}'
  end
end


class Config

  class Category
    attr_accessor :id, :name, :abbreviation, :options
    def initialize name, abbreviation, options, *id
      @name = name
      @abbreviation = abbreviation
      @options = options
      if ! id.empty?
        @id = id[0]
      else
        @id = get_new_id()
      end
    end
  end

  def initialize
    @categories = [
      Category.new( 'Start time', 's', nil ),
      Category.new( 'End time',   'e', nil ),
      Category.new( 'Project',    'p', [] ),
      Category.new( 'Task',       't', [] ),
      Category.new( 'Class',      'c', [] )
    ]
  end
  
  def reinitialize categories
    @categories = categories
  end

  def add_category name, abbrev=''
    return if ! get_cats( :name, name ).empty?
    @categories.push == Category.new( cat, abbrev, [] )
  end

  def get_abbreviation name
    if ( ! ( cats = get_cats( :name, name ) ).empty? ) then return cats[0].abbreviation end
  end
  
  def set_abbreviation name, abbrev
    if ! ( cats = get_cats( :name, name ) ).empty? then cats[0].abbreviation = abbrev end
  end
  
  def get_full_name abbrev
    if ! ( cats = get_cats( :abbreviation, abbrev ) ).empty? then return cats[0].name end
  end

  def get_options name
    if ! ( cats = get_cats( :name, name ) ).empty? then return cats[0].options end
  end

private

  def get_cats attribute, value
    @categories.select { |v| v.method( attribute ).call == value }
  end
end

$config = Config.new


class Record
  attr_reader :description, :start_time, :end_time, :categories

  def initialize text
    self.reinitialize text
  end
  
  def reinitialize text
    description = []
    @start_time = nil
    @end_time = nil
    @categories = Hash.new( [] )
    
    ( text.split( /\s/ ) ).each do | word |

      case word

      when /:/
        abbrev, value = word.split( ':', 2 )
        full_name = $config.get_full_name abbrev

        case full_name
        when nil
          description.push word
        when 'Start time'
          @start_time = value=='' ? Time.now : Time.parse( value )
        when 'End time'
          @end_time = value=='' ? Time.now : Time.parse( value )
        else
          @categories[ full_name ] = @categories[ full_name ].push value
        end

      else
        description.push word
        
      end
      
    end
    
    @description = description.join ' '
  end

  # Return a string that could be parsed by Record#reinitialise to create an
  # identical Record.
  def to_text
    result = ''
    if ! @start_time.nil?
      result += $config.get_abbreviation( 'Start time' ) + ':'
      result += @start_time.strftime( '%Y-%m-%d-%H:%M' ) + " "
    end
    if ! @end_time.nil?
      result += $config.get_abbreviation( 'End time' ) + ':'
      result += @end_time.strftime( '%Y-%m-%d-%H:%M' ) + " "
    end
    @categories.each { |k,v| result += $config.get_abbreviation(k) + ":#{v} " }
    result += @description
  end
  
  def to_s indent=''
    result = ''
    result += "#{indent}Start time; #{@start_time}\n"
    result += "#{indent}End time; #{@end_time}\n"
    result += "#{indent}Description; #{@description}\n"
    result += "#{indent}Categories;\n"
    @categories.each { |k,v| result += "#{indent}  #{k} => #{v}\n" }
    result
  end
  
end

class RecordList

  def initialize
    @records = {}
  end
  
  def set_all records
    @records = records
  end

  def update_record id, record
    @records[id] = record
  end
  
  def add_record record
    @records[ get_new_id ] = record
  end
  
  def get_records_in_period start_time, end_time
    @records.select do |k,v|
      ( !v.start_time.nil?  &&  v.start_time < end_time ) || (  !v.end_time.nil?  &&  v.end_time > start_time )
    end
  end

  def to_s
    result = ''
    @records.each { |k,v| result += "#{k} =>\n#{v.to_s( '  ' )}" }
    result
  end
  
end


w = Record.new 's: e:2011-01-01-12:45:37.072 p:crap stuf and more stuff'
x = Record.new 's: p:ploppy stoopid stuff'
y = RecordList.new
y.add_record x
y.add_record w

puts
puts y
puts
puts x.to_text
puts
puts y.get_records_in_period Time.parse('2011-01-01-00:00:00'), Time.parse('2011-12-31-23:59:59')
puts
