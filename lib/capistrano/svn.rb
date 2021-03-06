load File.expand_path("../tasks/svn.rake", __FILE__)

require 'capistrano/scm'

class Capistrano::Svn < Capistrano::SCM
  
  # execute svn in context with arguments
  def svn(*args)
    args.unshift(:svn)
    context.execute *args
  end

  module DefaultStrategy
    def test
      test! " [ -d #{repo_path}/.svn ] "
    end

    def check
      test! :svn, :info, repo_url
    end

    def clone
      svn :checkout, repo_url, repo_path
    end

	def switch
		svn :switch, repo_url, repo_path
	end

    def update
	  if repo_url != fetch_repo_url	
	    switch
	  else
	    svn :update
	  end
    end

    def release
      svn :export, '.', release_path
    end

    def fetch_revision
      context.capture(:svn, "log -r HEAD -q |tail -n 2 |head -n 1 |sed 's/\ \|.*/\'\'/'")
    end
		
	def fetch_repo_url
	  context.capture(:svn, "info |grep 'URL: ' |awk '{print $2}'")
	end
  end

end
