#!/usr/bin/ruby

require 'time'

class Config

  def initialize
    @abbreviations = {
      's' => 'Start time',
      'e' => 'End time',
      'p' => 'Project',
      't' => 'Task',
      'c' => 'Class'
    }
    @options = {
      'Project' => [],
      'Task' => [],
      'Class' => []
    }
  end
  
  def set_all abbreviations, options
    @abbreviations = abbreviations
    @options = options
  end

  def add_category cat, abbrev=''
    return if @options[cat] != nil
    @options[cat] == []
    set_abbreviation( abbrev )
  end

  def set_abbreviation cat, abbrev
    return if @options[cat] == nil
    @abbreviations[cat] = abbrev
  end
  
  def get_full_name abbrev
    @abbreviations[abbrev]
  end

  def get_options cat
    return @options[cat]
  end
end

$config = Config.new


class Record
  attr_reader :description, :start_time, :end_time, :categories

  def initialize text
    self.set_all text
  end
  
  def set_all text
    @categories = Hash.new( [] )
    description = []
    
    ( text.split /\s/ ).each do | word |

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

  def to_text
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
    @records.select { |k,v| v.start_time < end_time || v.end_time > start_time }
  end

  def to_s
    result = ''
    @records.each { |k,v| result += "#{k} =>\n#{v.to_s( '  ' )}" }
    result
  end
  
private

  def get_new_id
    case RUBY_PLATFORM
    when /linux/
      return `uuidgen`.strip
    else
      raise 'UUID generation is not yet supported on #{RUBY_PLATFORM}'
    end
  end

end


x = Record.new 's: e:2011-01-01-12:45:37.072 p:crap stuf and more stuff'
y = RecordList.new
y.add_record x
puts y

