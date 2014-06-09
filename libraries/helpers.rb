module OTRS
  module Helpers

    # Returns the currently installed version of OTRS
    #
    # @return [String]
    def installed_version?()
      symlink_path = node['otrs']['prefix'] + "/otrs"

      if File.symlink?(symlink_path)
        symlink_target = File.readlink(symlink_path)
        version = symlink_target.sub(/.*-/, '')
        return version
      else
        return nil
      end
    end

    # Compares the currently installed version of OTRS against the parameter version
    #
    # @return [Boolean]
    def installed_version_matches?(version)
      installed_version? == version
    end

  end
end