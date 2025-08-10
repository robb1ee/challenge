# Testing of new feature

1. Log into the scratch org.
2. Open the Sales app via App Launcher (click on the nine dots in the top left corner).
3. Check if table with four columns (Publisher, Author, Title, Edition) is shown.
4. Wait a couple of seconds for the data to load.
5. Check if four rows containing books are visible in the table.
6. Check if every book has an edition of greater than 600000.
7. Check if the books are sorted in a descending order.
8. Log out

These steps assume that the data delivered by https://eop0fqfuwjjx6lx.m.pipedream.net/ is constant.
If the data may change over time, you would have to open the page, determine the current expected result and adjust step 4, i.e. the number of rows in the table, accordingly.

Validation of the deployment including tests can be achieved with running

`sf project deploy validate --manifest manifest/package.xml --target-org TargetOrg`

in the console.
