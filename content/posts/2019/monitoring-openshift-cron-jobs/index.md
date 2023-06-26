---
aliases:
- /2019/11/18/monitoring-openshift-cron-jobs/
author: Major Hayden
date: '2019-11-18'
summary: Openshift (and Kubernetes) allow you to run jobs on schedule, but these jobs
  can fail from time to time. You can monitor them from bash!
tags:
- linux
- kubernetes
- openshift
- shell
title: Monitoring OpenShift cron jobs
---

Moving applications into an entirely containerized deployment, such as
OpenShift or Kubernetes, requires care and attention. One aspect of both that
is often overlooked is scheduled jobs, or cron jobs. ⏰

Cron jobs in OpenShift allow you to run certain containers on a regular basis
and execute certain applications or scripts in those containers. You can use
them to trigger GitLab CI pipelines, run certain housekeeping tasks in web
applications, or run backups.

This post will cover a quick example of a cron job and how to monitor it.

*Note: Almost all of these commands will work in a Kubernetes deployment by
changing `oc` to `kubectl`, but your mileage may vary based on your Kubernetes
version. All of these commands were tested on OpenShift 3.11.*

## Add a job

Here is a really simple cron job that gets the current date:

```yaml
# cronjob.yml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: get-date
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: get-date
            image: docker.io/library/fedora:31
            command:
              - date
```

The job definition says:

* Start a Fedora 31 container every minute
* Run `date` in the container
* Kill the container

Load this into OpenShift with: `oc apply -f cronjob.yml`

If you want to make more complex jobs, review the [OpenShift documentation on
cron job objects]. The [cron job API documentation] has much more detail.

[OpenShift documentation on cron job objects]: https://docs.openshift.com/container-platform/3.11/dev_guide/cron_jobs.html
[cron job API documentation]: https://docs.openshift.com/container-platform/3.11/dev_guide/cron_jobs.html
[Kuberntes documentation on cron jobs]: https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/

## Bad things happen to good cron jobs

Cron jobs come with certain limitations and these are explained in the
[Kuberntes documentation on cron jobs]. If a cron job is *missed* for a
certain period of time, the scheduler will think something has gone horribly
wrong and it won't schedule new jobs.

These situations include:

* the container takes too long to start
  (check `.spec.startingDeadlineSeconds`)

* one run of the job takes a very long time and another job can't start
  (usually when `concurrencyPolicy` is set to `Forbid`)

If 100 of the jobs are missed, the scheduler will not start any new jobs. This
could be a disaster for your application and it's a good place to add
monitoring.

## Monitor missed cron jobs with bash

Luckily, OpenShift makes an API available for checking on these situations
where cron jobs are missed. The API sits under the following URI:
`/apis/batch/v1beta1/namespaces/$NAMESPACE/cronjobs/$JOBNAME`

For our `get-date` example above, this would be:
`/apis/batch/v1beta1/namespaces/$NAMESPACE/cronjobs/get-date`

We can monitor this job using two handy tools: `curl` and `jq`.

```bash
#!/bin/bash

# Get unix time stamp of a last job run.
LAST_RUN_DATE=$(
  curl -s -H "Authorization: Bearer $YOUR_BEARER_TOKEN" \
    https://openshift.example.com/apis/batch/v1beta1/namespaces/$NAMESPACE/cronjobs/get-date | \
    jq  ".status.lastScheduleTime | strptime(\"%Y-%m-%dT%H:%M:%SZ\") | mktime"
)

# Get current unix time stamp
CURRENT_DATE=$(date +%s)

# How many minutes since the last run?
MINUTES_SINCE_LAST_RUN=$((($CURRENT_DATE - $LAST_RUN_DATE) / 60))

DETAIL="(last run $MINUTES_SINCE_LAST_RUN minute(s) ago)"
if [[ $MINUTES_SINCE_LAST_RUN -ge 2 ]]; then
  echo -n "FAIL ${DETAIL}"
  exit 1
else
  echo -n "OK ${DETAIL}"
  exit 0
fi
```

*Note: Getting tokens for the curl request is covered in [OpenShift's
Authentication documentation].*

If the cron job is running normally, the script output should be:

```test
$ ./check-cron-job.sh
OK (last run 0 minute(s) ago)
$ echo $?
0
```

And when things go wrong:

```test
$ ./check-cron-job.sh
FAIL (last run 22 minute(s) ago)
$ echo $?
1
```

[OpenShift's Authentication documentation]: https://docs.openshift.com/container-platform/3.11/rest_api/index.html#rest-api-authentication