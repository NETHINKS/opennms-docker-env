<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		
		<!-- CSS: Bootstrap,  NETHINKS -->
		<link href="css/bootstrap.min.css" rel="stylesheet">
		<link href="css/nethinks.css" rel="stylesheet">

		<!-- JavaScript: Bootstrap -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
		<script src="js/bootstrap.min.js"></script>
		<title>OpenNMS Start</title>
	</head>
	<body>
		<div class="container nethinks-contentbox">
			<div class="row">
				<div class="col-md-3 nethinks-logo">
					<img src="img/nethinks_logo.png" alt="NETHINKS Logo" />
				</div>
			</div>
			<div class="row">
				<div class="col-md-6 col-sm-6">
					<div class="nethinks-blue">
	                    <h2><span class="glyphicon glyphicon-wrench"></span>Software</h2>
						<ul class="nav nav-pills nav-stacked">
                            {% for location in locations %}
							<li role="presentation">
								<a href="{{ location.location }}">
								    {{ location.name }}
								</a>
							</li>
                            {% endfor %}
                        </ul>
                    </div>
                </div>
				<div class="col-md-6 col-sm-6">
					<div class="nethinks-green">
						<h2><span class="glyphicon glyphicon-earphone"></span>
                            {% if parameters.support_text %}
                                Support
                            {% else %}
                                Info
                            {% endif %}
                        </h2>
                        <p>
                            {% if not parameters.support_text %}
                                OpenNMS Docker Environment was created by <br /><br />
                            {% endif %}

                            NETHINKS GmbH<br />
                            Bahnhofstra&szlig;e 16<br />
                            36037 Fulda<br />
                            <a href="http://www.nethinks.com/opennms">www.nethinks.com</a><br /><br />

                            {% if not parameters.support_text %}
                                Please see the <a href="https://github.com/NETHINKS/opennms-docker-env">Github Project</a> 
                                for further informations.
                            {% endif %}

                            {% if parameters.support_text %}
                                {{ parameters.support_text|replace("\n", "<br />") }}
                            {% endif %}
                        </p>
                    </div>
                </div>
			</div>
		</div>
	</body>
</html>
