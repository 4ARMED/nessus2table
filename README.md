## Nessus2Table

This is one of those scripts you end up knocking up to save you time, then can't remember where you put it so next time have to do it again. So we're sharing this one so we always know where it is!

Sometimes you need to include a table of vulnerabilities in a report (particularly PSN Healthcheck reports) with a big list of systems and the issues that affect them.

Rather than do this by hand, this script takes an exported Nessus CSV file and converts it into a CSV file you can open in Excel, then copy/paste into Word to make a nice table.

### Installation

1. Clone this Github repo

```ShellSession
git clone https://github.com/4armed/nessus2table.git
```

2. Install the dependencies (there's only one - trollop)

```ShellSession
 cd nessus2table
 bundle install
 ```

3. Run the ruby script with the location of your exported Nessus CSV and the filename you'd like the output in.

```ShellSession
ruby nessus2table.rb -i <NessusCVSfile> -o <TargetCVSFile>
```


That's it.

Any questions ping us on Twitter <a href="https://twitter.com/4ARMED">@4ARMED</a> or me <a href="https://twitter.com/marcwickenden">@marcwickenden</a>.
