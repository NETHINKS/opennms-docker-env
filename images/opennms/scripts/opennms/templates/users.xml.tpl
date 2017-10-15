<?xml version="1.0" encoding="UTF-8"?>
<userinfo xmlns="http://xmlns.opennms.org/xsd/users">
    <header>
        <rev>.9</rev>
        <created>Mittwoch, 24. Juni 2015 08:10:30 GMT</created>
        <mstation>master.nmanage.com</mstation>
    </header>
    <users>
        {% for user in users %}
        <user>
            <user-id>{{ user }}</user-id>
            <full-name>{{ users[user]['name'] }}</full-name>
            <user-comments>{{ users[user]['description'] }}</user-comments>
            <password>{{ users[user]['password'] }}</password>
            <role>{{ users[user]['role'] }}</role>
        </user>
        {% endfor %}

        <user>
            <user-id>rtc</user-id>
            <full-name>RTC</full-name>
            <user-comments>RTC user, do not delete</user-comments>
            <password>68154466F81BFB532CD70F8C71426356</password>
            <role>ROLE_RTC</role>
        </user>
    </users>
</userinfo>
