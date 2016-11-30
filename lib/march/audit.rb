require 'chronic_duration'

module March
  class Audit
    def self.complete(namespace, repository, interactive, destructive)
      repo = March::Repo.new(namespace, repository)

      merged(repo, interactive, destructive)
      puts
      age(repo, interactive, destructive)
    end

    def self.merged(repo, interactive, destructive)
      puts 'Auditing merged branches...'

      puts 'No merged branches.' if repo.merged_branches.empty?
      return                     if repo.merged_branches.empty?

      print 'These branches have been merged: '
      puts repo.merged_branches.join(', ')

      if interactive && destructive
        print 'Delete merged branches? (y/N) '
        bool = $stdin.gets

        case bool.chomp
        when 'y' then repo.delete_branches(repo.merged_branches)
        else puts 'Canceled action'
        end
      elsif destructive
        repo.delete_branches(repo.merged_branches)
      else
        puts 'Taking no action (destructive is disabled)'
      end
    end

    def self.age(repo, interactive, destructive)
      puts 'Auditing old branches...'
      msgs = repo.branch_age.each_with_object({}) do |(name, dates), acc|
        created = ChronicDuration.output(Time.now - dates[:oldest], weeks: true, units: 2)
        updated = ChronicDuration.output(Time.now - dates[:newest], weeks: true, units: 2)
        if (Time.now - dates[:newest]) > (ENV['MAX_AGE'] || 3600*24*14)
          acc[name] = "Branch #{name} was created #{created} ago and updated #{updated} ago and is probably owned by #{repo.branch_owners[name].join(', ')}"
        end
      end

      puts 'No old branches' if msgs.empty?
      return if msgs.empty?

      msgs.each { |_name, msg| puts msg }

      old_branches = msgs.map(&:first)

      if interactive && destructive
        print 'Delete old branches? (y/N) '
        delete = $stdin.gets

        case delete.chomp
        when 'y' then repo.delete_branches(old_branches)
        else puts 'Canceled action'
        end
      elsif destructive
        repo.delete_branches(old_branches)
      else
        puts 'Taking no action (destructive is disabled)'
      end
    end
  end
end
