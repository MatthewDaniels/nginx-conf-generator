<!doctype html>
<html class="no-js" lang="">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>NGINX Conf Generator</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.6.0/themes/prism-okaidia.min.css">
    <style>
    body {
        padding-top: 0px;
        padding-bottom: 20px;
    }
    </style>
    <link rel="stylesheet" href="css/bootstrap-theme.min.css">
    <link rel="stylesheet" href="css/main.css">
    <script src="js/vendor/modernizr-2.8.3.min.js"></script>
</head>

<body>
    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="jumbotron">
        <div class="container">
            <h1>Nginx Site conf Generator</h1>
            <p>An opinionated nginx sites conf generator. I was sick of doing this over and over again, so time to program it!</p>
            <p>Select a site type, fill in the form and copy the conf.</p>
        </div>
    </div>
    <div class="container">
        <section class="row">
            <div class="col-sm-5">
                <div class="dropdown" id="siteTypeSelector">
                    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                        Site type
                        <span class="caret"></span>
                    </button>
                    <ul id="siteTypeSelectorList" class="dropdown-menu" aria-labelledby="dropdownMenu1">
                    </ul>
                </div>
            </div>
            <div class="col-sm-7">
                <p id="selectedTypeDisplay" class="text-right lead"></p>
            </div>
        </section>
        <hr>
        <!-- form to fill out (dynamically populated) -->
        <form class="" role="form" id="input-form" data-persist="garlic">
          <div class="row">
            <div class="col-sm-6">
                <div class="form-group">
                    <label for="siteName">Site Name</label>
                    <input type="text" placeholder="Site Name" class="form-control" name="siteName">
                </div>
                <div class="form-group">
                    <label for="hostname">Hostname</label>
                    <input type="text" placeholder="Hostname (space separated for more than one)" class="form-control" name="hostname">
                </div>

                <div class="form-group">
                    <label for="rootPath">Root Path</label>
                    <input type="text" placeholder="Root Path (make it absolute eg: /home/ubuntu/code/platform/public)" class="form-control" name="rootPath">
                </div>
            </div>
            <div class="col-sm-6">
                <div class="form-group">
                    <label for="accessLogName">Access Log Name</label>
                    <input type="text" placeholder="Access Log Name" class="form-control" name="accessLogName">
                </div>
                <div class="form-group">
                    <label for="errorLogName">Error Log Name</label>
                    <input type="text" placeholder="Error Log Name" class="form-control" name="errorLogName">
                </div>
            </div>
            </div>
            <div class="row">
                
              <div id="upstreamContainer" class="col-sm-6">
                  <div class="form-group">
                      <label for="upstreamName">Upstream Name</label>
                      <input type="text" placeholder="Upstream Name" class="form-control" name="upstreamName">
                  </div>
                  <div class="form-group">
                      <label for="upstreamPort">Upstream Port</label>
                      <input type="text" placeholder="Upstream Port" class="form-control" name="upstreamPort">
                  </div>
              </div>
              <div id="optionsContainer" class="col-sm-6">
                  <div class="checkbox">
                      <label>
                          <input id="sslOption" type="checkbox" value="" name="isSSL">SSL?
                      </label>
                  </div>

                  <!-- Displayed only when the conf is a PHP one -->
                  <!-- wordpress
                  laravel
                  plain php -->
                  
                  <div id="phpOptionsContainer" class="form-group">
                      <label class="radio-inline">
                          <input type="radio" name="phpTypeOptions" id="inlineRadio2" value="laravel" checked> Laravel
                      </label>
                      <label class="radio-inline">
                          <input type="radio" name="phpTypeOptions" id="inlineRadio1" value="php"> Plain PHP
                      </label>
                      <label class="radio-inline">
                          <input type="radio" name="phpTypeOptions" id="inlineRadio3" value="worpdress"> Wordpress
                      </label>
                  </div>
              </div>

            </div>

<!--   upstream:
    port
    name #optional
  error-log-name
  access-log-name -->
        
        </form>
        <div class="row">
          <div class="col-sm-12">
            <button class="btn btn-primary" id="updateConfig">Update Config</button>
          </div>
        </div>
        <section class="row">
            <header>
                <h2>Conf output</h2>
                <p class="smalltext">Copy the below and paste into your conf file</p>
            </header>
            <pre class="col-sm-12 language-nginx"><code class="language-nginx" id="nginx-conf-output"></code>
            
          </pre>
        </section>
        <hr>
        <footer>
            <p>&copy; Matt Daniels <?php echo date('Y'); ?></p>
        </footer>
    </div>
    <!-- /container -->
    <!-- templates -->
    <script type="text/template" src="js/templates/static-site.tpl" data-site-type="Static Site">
      <?php 
       echo file_get_contents('./js/templates/static-site.tpl', true);
      ?>
    </script>
    <script type="text/template" src="js/templates/php-site.tpl" data-site-type="PHP Site (PHP-FPM)">
      <?php 
        echo file_get_contents('./js/templates/php-site.tpl', true);
      ?>
    </script>
    <script type="text/template" src="" data-site-type="Docker / Reverse Proxy Site">
      <?php 
        echo file_get_contents('./js/templates/docker-site.tpl', true);
      ?>
    </script>
    <!-- END templates -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script>
    window.jQuery || document.write('<script src="js/vendor/jquery-1.11.2.min.js"><\/script>')
    </script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/garlic.js/1.3.0/garlic.min.js"></script>
    <script type="https://cdnjs.cloudflare.com/ajax/libs/prism/1.6.0/components/prism-nginx.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.8.3/underscore-min.js"></script>
    <script src="js/vendor/bootstrap.min.js"></script>
    <script src="js/main.js"></script>
</body>

</html>
