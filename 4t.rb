#!/usr/bin/ruby

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

  def get_options cat
    return @options[cat]
  end
end


class TimeRecord
  # Do we want a data structure for a TimeRecord, or do we just want to keep all
  # info as a string? Could provide accessors that always parse the string.
  # Presumably, we should persist in the same form that we store in memory.

  #accessor_attr @start_time @end_time @description @categoryBag

  # Should be class function. How is this done?
  def parse text
    # split text by spaces (not tabs or newlines - keep them for formatting)
    # for each "word"
      # Does word contain a colon?
        # is text before colon a known abbreviation?
          # add to start or end time or a category and replace in text with any included white space (possibly none)
    # add all remaining words and white space to description
    # new time record
  end

  def initialize text
    # return parse text
  end
  
  def update_record text
  end
end


#p categories
#p abbreviations

