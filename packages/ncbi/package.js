Package.describe({
  summary: 'NCBI package'
});

Package.on_use( function(api) {
  api.use('coffeescript',['server']);
  api.add_files('ncbi.coffee', 'server');
  if (api.export) 
    api.export('NCBI');
});
