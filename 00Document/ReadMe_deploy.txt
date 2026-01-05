--1) cmd dos
D:\zSvrJavaMavenTomcat\apache-tomcat-7.0.109\conf\tomcat-users.xml


--2 muncul editor edit save
<role rolename="manager-gui"/>
<role rolename="manager-script"/>
<role rolename="manager-status"/>
<role rolename="admin-gui"/>
<role rolename="admin-script"/>

<user username="admin" password="admin123" roles="manager-gui,manager-script,manager-status,admin-gui,admin-script"/>

--3) stop star tomcat7
net stop Tomcat7
net start Tomcat7

--4) test bowser
http://localhost:8080/manager/text


mvn clean package tomcat7:deploy
mvn tomcat7:redeploy


logs/catalina.<tanggal>.log

----
Ubah baris ini:
<Server port="8005" shutdown="SHUTDOWN">
Menjadi:
<Server port="8006" shutdown="SHUTDOWN">

--
Aktifkan juga executor (hapus komentar):
<Executor name="tomcatThreadPool" namePrefix="catalina-exec-"
    maxThreads="150" minSpareThreads="4"/>

netstat -ano | findstr :8080
netstat -ano | findstr :8006


----
Cara membuat settings.xml di .m2

Masuk ke folder:
C:\Users\adi.setiadi\.m2\settings.xml


Buat file baru bernama:
settings.xml


Isi dengan template dasar seperti ini:

<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                              https://maven.apache.org/xsd/settings-1.0.0.xsd">

    <localRepository>C:\Users\adi.setiadi\.m2\repository</localRepository>

    <mirrors>
        <mirror>
            <id>central</id>
            <mirrorOf>*</mirrorOf>
            <url>https://repo.maven.apache.org/maven2</url>
        </mirror>
    </mirrors>

    <profiles>
        <profile>
            <id>default</id>
            <properties>
                <java.home>C:\Program Files\Java\jdk-17</java.home>
            </properties>
        </profile>
    </profiles>

    <activeProfiles>
        <activeProfile>default</activeProfile>
    </activeProfiles>

</settings>


---
mvn clean package tomcat7:deploy

curl -u admin:admin123 http://localhost:8080/manager/text/list

mvn tomcat7:deploy
mvn tomcat7:redeploy

