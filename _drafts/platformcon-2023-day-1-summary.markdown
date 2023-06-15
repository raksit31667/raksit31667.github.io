---
layout: post
title: "สรุปสิ่งที่ได้เรียนรู้จาก PlatformCon 2023 วันที่ 1"
date: 2023-06-15
tags: [platform]
---

Build abstractions, not illusions
- Abstraction provides a higher-level vocab that shields the user from the underlying complexity.
- Abstraction forms a cohesive language and useful mental model.
- https://en.wikipedia.org/wiki/Leaky_abstraction
- Illusion = building abstraction by hiding essential details causing users to be misled
- Example: CI/CD pipeline
  - Essential: Testing strategy, Deployment target, Deployment mechanism (blue-green, canary, rolling)
  - Less essential: Service name, Programming language

Why so hard to create platform-as-a-product
- Take internal users for granted
  - Assumptions about abilities, what is best for them, willingness to use platform
- Treat platform as a cost centre
- Make the platform mandatory
- MonoPlatform: One platform rules all use cases, offerings per features
- Focus too much on infra, no technical product owner

Communicate biz value of platform
- How to scale DevOps to enable multiple teams to build it and run it -> Self-service managed by platform team
- Listen to stakeholders priorities and concerns -> Develop options
- Support the value story through outcome metrics (velocity, throughput) -> (employee satisfaction, ROI)
- Balance trade-offs from multiple stakeholders
- Communicate the "why" to incentivize mindset shift
- Communicate the realized value to the organization
- Nike: 3 layers of composable platforms
  - Experience platforms: tied to customer journeys (search, B2B, B2C)
  - Core platforms: supporting biz processes (inventory, pricing, logistics)
  - Foundational platforms: providing services and data to core platforms (core ERP, data foundation, biz automation)
- 3 Pillars
  - Time to value: self-service, simplify DevOps workflow, fast feedback loops
  - Resillience: improve service reliability, fault tolerance, MTTR
  - Governance: security guardrails, compliance policies, resource utilization

Simplifying platform design with reference architectures
- N/A

Why we skipped SRE and switched to platform engineering?
- Scaling SRE teams by knowledge sharing and automation

Platform as agents of enterprise improvement
- Struggles: no defined strategy, ignoring operations, lack of adoption
- Example pipeline dashboard: how far you are away from good
- Adoption requires strategy -> analyse operational cost, missing features, migration plan, no time/desire to move
- Branding is important
- Leadership needs to understand metrics, otherwise it will be misused
- Encourage adoption 
  - documentation, training, aligned with security and compliance, embed good practices
  - Partnered with early adopters, tech events, community building, ensure active executive participation

How Realtor.com created a platform culture that lasts
- Playbook
  - Maturity model assessment: Seen for the bad (no autonomy) -> Not seen (not accerelator) -> Seen for the good
  - Decision making frameworks
    - Describing what to build, proposed solution, tech recommendation, findings, tradeoffs
    - Cross-functional workshops: product strategy, tech "from-to" architecture, ways of working
  - Identity (end state and vision): Self-awareness, first team mindset, branding, execution & barriers, the importance of failure

Build golden paths for day 50, not only day 1
- https://humanitec.com/blog/what-is-a-platform-orchestrator
- Golden paths = Any procedure a user can follow with minimal cognitive load that drives stardardization
- Let every day be day 1 possible by dynamically creating app and infra configs for every release
  - Developer gives workload spec, PF has baseline configs -> combine these 2 specs to CI
- Platform is about structuring repos
  - Developer owns workload specs, Dockerfile, pipeline YAML
  - PF team owns resource definition, IaC, automation/compliance

Adobe's journey into platform
- Adobe has IDP that solves around long cycle & wait time on 3rd party system
- Fully customizable using Argo, declarative GitOps based model, advanced deployment support
- Treat internal developers like customers (focus on DX, gamified learning, go-to-market checklist, get developer feedback from survey)
- Establish baseline for success early (OKR)
  - Measure platform performance (time from 0 to hello world, DORA, adoption %, track doco usage, NPS)
- Adapt and pivot according to the solution (strategic tradeoffs, share pain points with leadership, org and team-level change)
- Without an adoption, there is no platform (prioritize features that boost mass product adoption)
- From complicated YAML file -> abstracted self-serve experience in Backstage
- Cumbersome verbose docs -> quickstart styled docs

Building internal platform in a hybrid cloud scenario
- Hybrid, multiple languages, multiple runtimes, monolith to microservices
- Journey: Siloed -> DevOps team Bottleneck -> Siloed automations
- Find the balance between user needs and complexity of central toolchain

Simplified infrastructure with Istio
- Istio gives team autonomy, security guardrails, automation with consistent API, microservice observability, generic config management, dynamic config for elastic cloud, abstractions
- Alternatives: Kubernetes Gateway API, still lacks of support for service-to-service traffic

Standardization and security, a perfect match
- Paradox of choice: too many choices cause anxiety, indecision, decision fatigue -> customers want choices, but not too much
  - Analogy: Grocery store
  - High maintenance cost for same capabilities, challenging security
  - Solution: Golden paths (buffets)
- Create one pipeline to rule them all
- Enforce programming language, code quality scan, coding standards, change ticket for every production release
- Choosing the right set of tools: who will maintain? pros-and-cons? cost and licensing?

From infra to app deployment: where does a platform start and end?
- TL;DR it depends
- Patterns
  - Tickets: Customisable for organisations, slow and prone to error
  - Cloud provider: On-demand and self-service, not customisable or approval
  - Kubernetes: Clean and consistent APIs, high cognitive loads
- Build -> Measure -> Learn
- Team topologies -> set boundaries to balance cognitive load

Is your platform ready for AI?
- AI won't replace people, but people who use API will.

How ING built a platform to reach their customers faster and more meaningfully
- Rich CI/CD pipelines, self-service via Console, Wizards, CLI to self-configure services

Architecting an optimal FinOps platform
- Problem: Was cloud intended to save costs or increase revenue?
- Inform -> Optimize -> Operate cycle
- Whose problem? Finance vs Product vs Tech
- Challenges: Data + Org + Pipelines + Operating model + Sustainability
- Identify core problems -> Value-based prioritization of capabilities -> Map to the remediation priorities -> Make it data-driven -> Democratize / Open APIs -> Composable and replaceable platform product

From cloud cost management to FinOps
- Use kubecost to gather cost and utilization
- Measure cluster size, computation cost, idle cost

The power of collaboration: Why platform engineers should engage in open source contributions
- Don't take existing infra for granted, develop generic solutions, don't cut corners
- Pros: direct contact to DEVs, ability to cover "known bugs" and flaws with doco, already had test flows
- Personal gains: public speaking, improve communication skill, confidence boost, growing career, networking
- Project impact: less in-house tailoring, prioritise features, roadmap awareness, better support from community
- Note for managers: free-time for employees for open-source projects to gain important knowledge, control roadmap, attract top talents to your team

Why centralize legacy authn at the ingress gateway
- Choosing off-the-shelf solution: Add new or refactor? Deprecation? Backward compatible? How is it easy to migrate (move in one go, active sync)?
- Identifying and categorising
  - Does each auth type represent the same kind of identity? How is auth configured (router, middleware, framework, DB, config file)? Multiple auth types in monolith vs different types per-service?
  - Solution: choose auth types based on host, path, or headers
  - Solution: try every auth type until you determine which one is being used
- What information send to downstream?
  - Send identity data through Ingress gateway by adding headers from auth service response to the request sent downstream
  - Find the way to define common format to represent different types of identity (user vs company)
- How to handle authorization?
  - Broad authorization -> use combination of request and identity info to perform top-level authorization at ingress gateway
  - Delegates granular authorization (check ACLs) -> too complicated to authorize, let downstream decide
- Stand-alone auth next to gateway
  - Envoy, NGINX, Gloo, Kong, Traefik, Tyk, AWS API Gateway Lambda authorizer
- Ensure auth service is highly available to ensure availability

Get FinOps right without destroying your agility
- Focus has been on reliability, performance, security
- Cost is a new requirement
- Visualize -> Predict & Forecast -> Optimize

Backstage does not an internal platform make!
- Enemies of platform progress: learning curves, updates, security, stakeholders, skill gap, cognitive load
- Backstage reality: learn how to deploy (Postgres, Redis), secure, update, customise (react, JS, YAML), MORE COGNITIVE LOAD
- Backstage is powerful, but if not careful then abstraction is leaked (having far too much knowledge on how Terraform should run, public cloud, security hole)
- Be careful of pulling too many platform responsibilities to Backstage else development cost increases
- Create platform abstraction connecting to Backstage, control sync to Backstage
- https://github.com/syntasso/kratix

Tech doco: How can I write them better and why should I care?
- If you can't automate it, document it.
- System logical design, on-call runbooks, code readme, onboarding docs, Slack, project planning
- "My code is self-documented" - cannot cover reasoning, intention
- Avoid single-point-of-failure/bottleneck: YOU
- Why set certificates here? Why is the module complex? Why chose doing X instead of following clean code practices like DRY & KISS?
- Know your audience: 
  - Have user flow in mind
  - Internal: things you worked on, things that bugged you, things that aren't clear
  - External: what is it about? quickstart, quirks, things to consider when using this, example
  - Docs in knowledge base vs code
- Content guidelines
  - Table of contents
  - Highlights: bold, use color to represent
  - Word and sentences: short words, more sentences
  - Simple English
  - Markdown
  - Store in the same code repo
- Provides readers with info and send them back to their tasks ASAP.

DevEx is not DevOps: Investing in developer enablement to reduce barriers to continuous delivery
- DevEx enables DevOps (flow)
- DevOps = set of practices and principles to push toward biz value to customers ASAP in safest way possible
- DevEx = giving developer joy by removing friction
- Onboarding: automated DEV setup, sensible default and rapid prototyping tools, buddy, self-training, release small changes in PROD in first week
- Day-to-day: CICD tooling availability, fast code to test to deploy, perf testing and tuning, observability
- Refactoring: quality guardrails, debugging tools, security/compliance checks, code coverage threshold
- Potential ROI: saving hours * hourly wage

Testing platforms
- Treat your platform as a product
- What's in-scope vs out-scope? Which level to test (API vs infra)? Which tools? When to test?
- We should define testable user stories
- Platform deploying AWS infra via Crossplane (Kubernetes-based)
- https://score.dev/
- RobotFramework KubeLibrary

When the fit for everyone is not the right fit for you
- App design pattern might not be applicable with platform design (ex. many approaches to achieve sidecar patterns)
- App code (bounded by limited scope, less constrainted by standards, change management) vs Platform code (more hollistic approach, lots of dependencies)
- Platform debugging is more difficult
  - Check logs
  - Network (latency, message loss, sync issues)
  - Resource utilisation (CPU and memory, I/O, bandwidth)
- Platform has so many choices (avoid vendor lock-in, make security a priority, choose future-proof platform, cost effectiveness)
- Leverage Goldilocks partner (avoid pressured or overcaution partners)

Platform engineering: From culture to practice
- For who?
  - CFO -> $$$
  - CPO -> time to market
  - CIO -> security checks, fixes
  - People -> Common tech stack
  - COO -> M&A (merging and acquisition)
  - CEO -> fast result, future projection
  - Architects -> Common architecture
  - Engineers -> cognitive loads
- Developer portal: Start from static docs (Docusaurus, Slate) -> Backstage -> Roadie
- Frontend: Storybook, your own create-react-app
- Configurable mircoservices/apps: JHipster, Backstage
- Next steps: Common artifacts for containers, observability, upgradability, security and quality checks
- Pick the right pilot team, make value and they will talk about us
- https://github.com/shospodarets/awesome-platform-engineering
- Work with leadership for top-down support for bottom-up enablement

DevEx: What actually drives productivity?
- Organisations research and dig down the power of high-performing team in technical, but not about the voice of DEV
- Speaker did survey for 300+ teams with 100+ orgs and found that 
  - Experience and pedigree of DEVs in the team doesn't predict productivity
  - Using latest programming languages and frameworks doesn't predict productivity
- Instead, they have highly-effective environment by not having to
  - Start the day with alerts in PROD
  - No aggregated logs across systems
  - Talk to operations and tell them that alerts are false positive
  - Wait for response from architecture, security and governance for a previous feature completed
  - Many status meetings
  - Kick off long nightly E2E test suite almost always red, managed by siloed QA team
  - Cannot find doco, instead talk to project managers on other team, resulting in blocking tickets
- Focus on 3 things, flow state, feedback loops, cognitive load
  - https://thenewstack.io/can-devex-metrics-drive-developer-productivity/

Best practices for modularizing a Terraform project
- Store state file with locking
- Use module for only repeatable config
- Dividing by solution-specific grouping (iam, storage, pubsub vs web-server-cluster, data-storage)
- Separate config, workspace, directory per environment
- Use hooks to run terraform fmt, `count` or `for_each`, have README to explain IaC

How to accelerate the adoption of your platform
- Under the needs of users
  - Hire or borrow product manager, engineer
  - Work with early adopters
  - Establish a user advisory group
  - Feedback channel in Slack
  - Conduct interview (e.g., can you show us how to add 1 line of code and release it to PROD?)
  - Capture adoption and usage analytics
- Provide a great user experience
  - Apply UX and design techniques
  - Run frequent survey
  - Capture NPS
  - Streamline feature request and reserve capacity
  - Run customer love sprints
- Documentation and onboarding
  - Hire or borrow tech writer
  - Level 0, level 1, level 2 doco
  - Experiment with doco: videos
  - Run bootcamps and engineering onboarding sessions
  - Provide self-paced training materials
- Provide reliable and user-friendly support
  - Dedicated support channels
  - Provide white glove support
  - Clarity on response time and availability
  - Tune doco and FAQs based on feedback
- Flex out your internal marketing muscle
  - Identity: name and logo
  - Swag!
  - Marketing site
  - Publicise case studies of adoption and usage
  - Promote new features within your product
- Create your own dedicated modernization squad (enablement team)
  - Pitch with future savings
  - Embedding as operating model
  - Optimize via value stream mapping

Lesson learned when taming Kubernetes for on-demand environments
- Protecting env from single point of failure
  - Always limit Ingress controller watches by selectors and namespaces
  - Use a dedicated controller per env
  - Distribute the load of DNS query lookups,
    - Nodelocal DNSCache
    - Cluster propotional autoscaler
    - Always use FQDN to reduce numbers of failed queries
- Unlocking fast provisioning time
  - IP warm pool
- Cutting costs without compromise
  - Handling spot interruptions by using AWS Node Termination Handler

You built an IDP, now what?
- You and your IDP need boundaries
  - Clearly define abstration from your assessment and understanding of engineering capabilities
    - Once we know that boundary is starting to be wrong, renegotiate them with leadership
- Organisations are hard
  - People, process, tools -> Highest to lowest value -> Hardest to easiest to change
  - Great engineer: 
    - Curiousity and never-ending desire to learn
    - Willingness to try new things and fail and try again
    - A relentless drive to understand and seek depth of knowledge
    - Tech skills?
    - They need great managers and structure. Otherwise, have a small org or else no scale to drive change
    - https://charity.wtf/
- What cultural practices uplift IDP?
  - It depends on startup? 100-year-old enterprise? manufacturer?
  - Codebase having deep investment in testing, automation, clean
  - Fully owned by DEVs with little to no dependencies
  - Have SLOs defined, refined and aligned
- How to measure success
  - 4K metrics
  - Mean time to PR review, test fail rate, code coverage (risky to use because it's easy to game)