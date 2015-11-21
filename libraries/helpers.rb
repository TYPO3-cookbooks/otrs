module OTRS
  module Helpers

    # Returns the path to OTRS
    #
    # @return [String]
    def otrs_path
      node['otrs']['prefix'] + "/otrs"
    end

    # Returns if OTRS is already installed
    #
    # @return [Boolean]
    def installed?
      File.symlink?(otrs_path)
    end

    # Returns the currently installed version of OTRS
    #
    # @return [String]
    def installed_version?
      symlink_path = node['otrs']['prefix'] + "/otrs"

      if installed?
        symlink_target = File.readlink(symlink_path)
        symlink_target.sub(/.*-/, '')
      else
        nil
      end
    end

    # Compares the currently installed version of OTRS against the parameter version
    #
    # @return [Boolean]
    def installed_version_matches?(version)
      installed_version? == version
    end

    # Returns the major version of a given version number (a from a.b.c)
    #
    # @return [String]
    def major_version(version = nil)
      version ||= installed_version?
      return "0" if version.nil?

      version.sub(/(\.\d+)+$/, '')
    end

    # Returns the minor version of a given version number (a.b from a.b.c)
    #
    # @return [String]
    def minor_version(version = nil)
      version ||= installed_version?
      return "0.0" if version.nil?

      version.sub(/\.\d+$/, '')
    end

    # Checks, if the upgrade from version from to version to is a patch-level upgrade.
    # we do not use Chef::VersionConstraint, as a patch-level downgrade should be also possible
    def patchlevel_upgrade?(to)
      nil unless installed?
      minor_version(installed_version?) == minor_version(to)
    end
  end
end