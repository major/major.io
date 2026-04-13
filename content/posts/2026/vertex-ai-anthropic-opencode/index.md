---
author: Major Hayden
date: '2026-04-13'
summary: >
  Opencode makes it easy to use Anthropic's Claude models through 
  Google's Vertex AI platform.
tags:
- ai
- gcp
- opencode
- vertex-ai
title: Using Anthropic's models via Vertex AI in opencode
cover:
  image: feature.jpg
  alt: Long-billed Curlew, Marshall's Beach, San Francisco, California
  caption: |
    Photo by <a href="https://unsplash.com/@tykejones?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Tyke Jones</a> on <a href="https://unsplash.com/photos/a-bird-flying-over-a-body-of-water-6W9H4xNq3hs?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText">Unsplash</a>    
  relative: true
---

We use [Vertex AI] at work for accessing Anthropic's models and the opencode setup is quite smooth!
Although getting your authentication credentials from Google can be a little tricky, using them with [opencode] involves setting a few environment variables.

[Vertex AI]: https://cloud.google.com/vertex-ai/generative-ai/docs/partner-models/use-claude
[opencode]: https://github.com/anomalyco/opencode

# Setting up Vertex AI

Before you point opencode at Vertex AI, you need a few things on the GCP side.

## Prerequisites

1. A GCP project with the **Vertex AI API** enabled
2. IAM permissions for the Claude models (your account needs the `aiplatform.endpoints.predict` permission, or a broader role like `Vertex AI User`)
3. Either a service account key or Application Default Credentials (ADC)

## Authentication

You have two main options here.
The easiest for local development is ADC:

```bash
gcloud auth application-default login
```

This stores credentials locally and opencode picks them up automatically.

If you're using a [service account] (common in enterprise setups where your org provisions access), point to the key file:

[service account]: https://cloud.google.com/iam/docs/service-accounts-create

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your-service-account.json
```

## Environment variables

Set these in your shell profile or session:

```bash
export ANTHROPIC_VERTEX_PROJECT_ID=your-gcp-project-id
export GOOGLE_CLOUD_PROJECT=your-gcp-project-id
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your-service-account.json  # if not using ADC
```

You can also set `VERTEX_LOCATION` if you need a specific region, but the `global` endpoint is the default.
It routes to the nearest available region.

# Using opencode

You don't need to configure opencode at all!
It finds the environment variables and takes care of the rest for you.

You can type `/models`, press enter, and you should see the list of available models from Vertex AI.
From there, use CTRL-F to select any favorites that you use often.

# Troubleshooting

If you don't see any models, double check the environment variables to ensure they are set in your terminal session.
You may need to open a new terminal or source your shell profile to pick up the new variables.

You can also run `opencode models --refresh` to force a refresh of the model list from Vertex AI.
