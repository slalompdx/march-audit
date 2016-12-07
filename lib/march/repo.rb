require 'chronic_duration'

module March
  class Repo
    def initialize(namespace, repo)
      @string = "#{namespace}/#{repo}"
      @repo = client.repo(@string)
    end

    def client
      March::Github.client
    end

    def id
      @repo.id
    end

    def default_branch_name
      @repo.default_branch
    end

    def default_branch
      branches[branches.find_index { |b| b.name == default_branch_name }]
    end

    def default_tip
      default_branch.commit.sha
    end

    def branches
      @branches ||= @repo.rels[:branches].get.data
    end

    def compare_branches
      branches.each_with_object({}) do |branch, acc|
        acc[branch.name] = client.compare(id, default_tip, branch.commit.sha)
      end
    end

    def merged_branches
      @merged_branches ||= compare_branches.select do |_name, diff|
        diff.commits.empty?
      end.map(&:first).reject { |name| name == default_branch.name }
    end

    def branch_owners
      @branch_owners ||=
        compare_branches.each_with_object({}) do |(name, diff), acc|
          author_ary   = diff.commits.map { |c| c.commit.author }
          authors      =
            author_ary.map do |h|
              h.map { |k, v| v if k == :email }.compact
            end.uniq

          acc[name] = authors.flatten
        end
    end

    def branch_age
      compare_branches.each_with_object({}) do |(name, diff), acc|
        oldest = diff.merge_base_commit.commit.author.date
        newest = diff.commits.map { |c| c.commit.author.date }.sort.last
        res = { oldest: oldest, newest: newest }
        acc[name] = res unless name == default_branch_name || newest.nil?
      end
    end

    def delete_branches(branch_names)
      raise ArgumentError unless branch_names.is_a?(Array)
      branch_names.each do |name|
        puts 'Deleting ' + name
        client.delete_branch(id, name)
      end
    end
  end
end
