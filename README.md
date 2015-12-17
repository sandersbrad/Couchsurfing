# Neo4j Graph Creation 

## Notes

* I decided to use a hash to store pointers to nodes that were already created to increase the creation time of the graph, assuming space complexity wasn't an issue.  The other option is to query the database for an existing node instead, which I thought would slow down the process over a million + entries versus utilizing the O(1) lookup time of the hash.

* I have errors printing to the console when they are rescued.  I also considered storing these in an array so they could be accessed later.

* The script will initialize the database for you, assuming we have similar environments.
