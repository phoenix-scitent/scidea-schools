# see https://github.com/cucumber/cucumber/wiki/Hooks

AfterConfiguration do |config| # run once after cucumber configuration load
end

Before do |scenario|
  SeedUserRoles.seed
end

After do |scenario| # each scenario
  SeedUserRoles.clean
end

at_exit do # after all scenarios are finished (global tear-down)
end

