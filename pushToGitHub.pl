#!/usr/bin/perl -I/home/phil/perl/cpan/DataTableText/lib/ -I/home/phil/perl/cpan/GitHubCrud/lib/
#-------------------------------------------------------------------------------
# Maven and Gradle on Github
# Philip R Brenan at gmail dot com, Appa Apps Ltd Inc., 2021
#-------------------------------------------------------------------------------
use warnings FATAL => qw(all);
use strict;
use Carp;
use Data::Dump qw(dump);
use Data::Table::Text qw(:all);
use GitHub::Crud qw(:all);
use feature qw(say current_sub);

my $home = q(/home/phil/people/Ashley/java/mvn/);                               # Local files
my $user = q(philiprbrenan);                                                    # User
my $repo = q(mavenAndGradle);                                                   # Repo
my $wf   = q(.github/workflows/main.yml);                                       # Work flow on Ubuntu

push my @files, sort                                                            # Files in play
  grep {m(README\.md|\.pl|\.java)}
  searchDirectoryTreesForMatchingFiles($home);

for my $s(@files)                                                               # Upload each selected file
 {my $t = swapFilePrefix($s, $home);
  my $p = readFile($s);
  my $w = writeFileUsingSavedToken($user, $repo, $t, $p);                       # Write file to github
  lll "$w $s $t";
 }

my $y = <<END;
# Test NasmX86

name: Test

on:
  push

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout\@v2
      with:
        ref: 'main'

    - name: Download other repos
      run: |
        curl -sL https://github.com/philiprbrenan/DataTableText/archive/refs/heads/main.zip > DataTableText.zip
        unzip DataTableText
        cp -R DataTableText-main/* .

    - name: Install Data::Dump
      run: |
        sudo cpan install -T Data::Dump

    - name: Tree
      run: |
        tree

    - name: Test
      run: |
        sudo apt install maven gradle

    - name: Install Mvn
      run: |
        mvn -B archetype:generate -DgroupId=com.ashley.test  -DartifactId=test -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4

    - name: Maven downloads so we do not time network activity
      run: |
        cd test
        mvn test
        rm -f ./target/classes/com/ashley/test/App.class
        rm -f ./build/classes/java/main/com/ashley/test/App.class

    - name: Maven on one file
      run: |
        cd test
        mvn test

    - name: Gradle Init
      run: |
        cd test
        gradle init

    - name: Upgrade fix gradle file as gradle init does not do an entirely satisfactory job
      run: |
        perl -Ilib upgradeVersion.pl

    - name: Gradle Build one file
      run: |
        cd test
        gradle test

    - name: Create lots of classes for maven
      run: |
        perl -Ilib create.pl -- 1000

    - name: Maven on lots of files
      run: |
        cd test
        mvn test

    - name: Maven on one file amongst many
      run: |
        cd test
        rm src/main/java/com/appaapps/test/App.java
        mvn test

    - name: Create lots of classes for gradle
      run: |
        perl -Ilib create.pl -- 1000

    - name: Gradle on lots of files
      run: |
        cd test
        gradle test

    - name: Gradle on file amonsgt many
      run: |
        cd test
        rm src/main/java/com/appaapps/test/App.java
        gradle test
END

lll "Ubuntu work flow for $repo ", writeFileUsingSavedToken($user, $repo, $wf, $y);
