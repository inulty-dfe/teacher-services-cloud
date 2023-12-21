# Teacher services infra - Service onboarding form
- Service name? e.g. Calculate teacher pay
- Domains  ? e.g.
    - school-placements-production.teacherservices.cloud
    - getintoteaching.education.gov.uk
    - get-information-schools.service.gov.uk
- Service short name? e.g. ctp
- Repository? e.g. https://github.com/DFE-Digital/itt-mentor-services
- Environments? e.g. develoment, staging, production
- Review apps? Yes or No
- Cost centre/Activity code ? e.g. 10167/101304
- List of developers who will need access to Azure? Do they use a DfE laptop or BYOD? e.g
    - James Beagle - BYOD
    - Clinton Morris - DfE laptop
- GDS assessed? Yes or No
- Slack channels? e.g
    - Product: #itt-mentor-services
    - Tech: #itt-mentor-services-devs
- Timeline? When is each environment needed? What are the planned project phases?
- Github repos / Docker registry type: Open (public) by default, or indicate any requirement to make them private
- Namespaces e.g. bat-qa (test cluster), bat-staging (test cluster), bat-production (production cluster)
- Technical requirements e.g.
    - Ruby on rails webapp
    - postgres
    - redis for sidekiq
- Healthcheck page
  - by default it should be /healthcheck and return HTTP 200 when the app is up and running