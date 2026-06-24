###
## debugg(able) mix-in helper
##      used for lexer & parser

module Debuggable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def debug=(value)
        raise ArgumentError, "true|false required for debug flag; got #{value}"  unless value.is_a?(TrueClass) || value.is_a?(FalseClass)
        @debug=value;
    end
    def debug()  @debug || false; end    ## note - default to false

    def debug?() @debug == true; end
  end


  ########
  ##  InstanceMethods
  def debug?() self.class.debug?; end

  ##
  ## todo/check - allow/support multiple msg args - why? why not?

  ##  note - use trace for debug for now - why? why not?
  def _trace( *args )  __log__( :DEBUG, *args ); end

  def _info( *args )   __log__( :INFO, *args );  end
  def _warn( *args)    __log__( :WARN, *args ); end
  def _error( *args )  __log__( :ERROR, *args ); end



private
  def __log__( level, *args )   ## :DEBUG, :INFO, :WARN, :ERROR, :FATAL etc.

    if level == :DEBUG && !debug?
        ## print nothing
    else
      msg = args.map do |arg|
                arg.to_str
               end.join(' | ')

      fout =  level == :WARN || level == :ERROR || level == :FATAL ? STDERR : STDOUT

      ## todo/check/fix - add/use/check for "local" logger
      fout.puts "#{level} [#{self.class.name}] -- #{msg}"
    end
  end
end  # module Debuggable