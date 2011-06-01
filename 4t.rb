#!/usr/bin/ruby

class Config

  # default init
  def intialize
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
  
# def init_from_file
  
  # Abbrev is an empty string by default - how do we do this?
  def add_category cat abbrev
    # if @options[cat] != nil
      # return
    # @options[cat] == []
    # set_abbreviation()
  end

  # can set abreviation to empty string!
  def set_abbreviation cat abbrev
    # @abbreviations[cat] = abbrev
  end

  def get_options cat
    # return @options[cat]
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


p categories
p abbreviations

