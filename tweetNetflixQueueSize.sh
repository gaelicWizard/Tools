#!/bin/bash

set -e
    # Don't let anything fail.
set -o pipefail
    # Not even the pipeline

QueueURL="$(defaults read net.gaelicWizard.tweetNetflix fullQueue)"
QueueName="$(defaults read net.gaelicWizard.tweetNetflix queueName)"
QueueNum="$(defaults read net.gaelicWizard.tweetNetflix queueNum)"
    # Easy configuration!

numberOfItemsInQueue="$(curl --silent -- "$QueueURL" | xpath '/rss/channel/item[last()]/title' 2>/dev/null | sed 's/.*>\(.*\)-.*/\1/g')"
    # 1)  Get the RSS feed for the full queue (curl), quietly (--silent)
    # 2)  Parse it to get the title of the last item (xpath), quietly (stderr to /dev/null)
    # 3)  Grab the queue-position of that item (sed), which is part of the title

numberOfItemsInQueueLastTime="$(defaults read net.gaelicWizard.tweetNetflix numberOfItemsInQueue)"

if [ "$numberOfItemsInQueue" -ne "$numberOfItemsInQueueLastTime" ]
    # TODO: tweet that the queue is empty.
    # NOTE: zero is an impossible condition, even assuming that nothing fails in any way. That is, there will never be a zeroth item in the queue, which is what the above pipeline parses. 
then
    defaults write net.gaelicWizard.tweetNetflix numberOfItemsInQueue -int "$numberOfItemsInQueue"
    exec updateStatus.sh "still has $numberOfItemsInQueue discs to go until Netflix Zero. (On profile '$QueueName' (#${QueueNum:-?}.))"
else
    echo "Skipping queue size retweet."
fi
