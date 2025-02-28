# frozen_string_literal: true

module RedmineGitHosting::Plugins::Sweepers
  class BaseSweeper < RedmineGitHosting::Plugins::GitolitePlugin
    attr_reader :repository_data, :gitolite_repo_name, :gitolite_repo_path, :delete_repository, :git_cache_id

    def initialize(repository_data, _options = {})
      @repository_data    = repository_data
      @gitolite_repo_name = repository_data[:repo_name]
      @gitolite_repo_path = repository_data[:repo_path]
      @delete_repository  = repository_data[:delete_repository]
      @git_cache_id       = repository_data[:git_cache_id]
    end

    private

    def delete_repository?
      Additionals.true? delete_repository
    end
  end
end
