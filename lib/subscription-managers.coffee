
# store regular subs (lists and stuff) shorter and less
@Subs = new SubsManager cacheLimit:5, expire:3

# store the recents for longer
@RecentSubs = new SubsManager cacheLimit:100, expire:20

# store more singles, and store them longer
@SingleSubs = new SubsManager cacheLimit:20, expire:10
