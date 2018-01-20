_rake () {
  if [ -f .rake_tasks ]; then
    time_since=$(expr $(date +%s | bc) - $(stat -f%m .rake_tasks))

    if [ $time_since -gt 86400 ]; then
      rm .rake_tasks
    fi
  fi

  if [ -f Rakefile ]; then
    if [ -f Gemfile.lock ]; then
      if [[ ! -f .rake_tasks || Rakefile -nt .rake_tasks ]]; then
        bundle exec rake --silent --tasks -A | cut -d " " -f 2 > .rake_tasks
      fi
    else
      if [[ ! -f .rake_tasks || Rakefile -nt .rake_tasks ]]; then
        rake --silent --tasks -A | cut -d " " -f 2 > .rake_tasks
      fi
    fi

    compadd $(cat .rake_tasks)
  fi
}

compdef _rake rake
