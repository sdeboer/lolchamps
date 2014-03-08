require 'interactive_editor'
require 'irb/ext/save-history'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = File.join(ENV['HOME'], '.irb_history')
