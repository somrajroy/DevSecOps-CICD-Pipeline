# Automating reliable Cloud Infra & App Deployments by CI/CD Pipelines
This repository demonstrates how to automate end-to-end cloud infrastructure, application deployments & database changes using CI/CD pipelines. It integrates `tfLint`, `tfsec`, and native `GitHub Actions` to enforce quality gates and secure, reliable IaC delivery. [It also introduces Database DevOps for automating schema and data changes](https://www.liquibase.com/resources/guides/database-devops) as part of the pipeline.
# Introduction
[In modern DevSecOps/DevOps, automating infrastructure and application delivery](https://www.redhat.com/en/topics/devops/what-is-devsecops) demands integrated quality and security checks within CI/CD pipelines. Tools like TFLint, tfsec, and SonarCloud enable automated linting, static analysis, and vulnerability scanning for Terraform and application code. <br/>
  * `TFLint` enforces Terraform best practices and catches configuration issues early.<br/>
  * `tfsec` scans for security misconfigurations in infrastructure code.<br/>
  * `SonarCloud` analyzes application code for bugs, vulnerabilities, and code smells.<br/>
  *  This automation enforces standards, reduces risk, and shifts quality left—catching issues early in the development cycle. <br/>
  * This blog demonstrates how to implement `TFLint` and `tfsec` in a GitHub Actions pipeline and demostrates how the setup can be extended to `SonarCloud` for broader application analysis. <br/>
# Linting and Static code analysis
`Linting and static code analysis` are crucial for all software projects, including IaC, as they identify issues early and prevents costly failures. A `linter` is a tool that analyzes source code for syntax errors, style violations, anti-patterns, and non-compliance with coding standards. In IaC, tools like TFLint serve this role by checking Terraform configurations for best practices, such as proper variable usage or missing documentation as defined in the `.tflint.hcl` configiguration file.<br/>
`Linting` is the process of applying a linter to enforce these standards/code hygiene. `Static code analysis` is broader, detecting deeper issues like bugs, security vulnerabilities, logical errors and performance problems without execution; `linting` is a subset of `static code analysis`.<br/><br/> When integrated into DevOps pipelines as automated quality gates (as demostrated in `deploy.yml` in this repository), these tools ensures that only compliant code reaches production - enhancing quality, reducing technical debt and risk, and improving long-term maintainability through consistent checks for both infrastructure and applications.
# Terraform tflint
[TFLint is an open-source Terraform-specific linter](https://github.com/terraform-linters/tflint) that enforces best practices, catches common mistakes, and ensures consistency, going beyond what `terraform validate` can catch. While it primarily performs linting — enforcing best practices, focusing on syntax, style, and policy violations — it also supports lightweight static code analysis by detecting deprecated usage patterns, unused declarations, and misconfigurations. <br/>
### Rules Enforced by tflint and how They improve Code Quality
TFLint enhances Terraform code quality by enforcing rules like flagging unused declarations ([terraform_unused_declarations](https://github.com/terraform-linters/tflint-ruleset-terraform/blob/main/docs/rules/terraform_unused_declarations.md)) to eliminate dead code, requiring descriptions for variables and outputs (`terraform_documented_variables`, `terraform_documented_outputs`) to improve documentation, and mandating explicit variable types (`terraform_typed_variables`) to reduce ambiguity. Rules are defined in the `.tflint.hcl` configuration file, which can be customized to align with each team’s standards. The version shared in this repository provides a solid starting point and can be extended with additional or custom rulesets to further strengthen code quality enforcement.
### Enhancing .tflint.hcl Configuration
`TFLint supports` a wide range of built-in and [plugin-based rules](https://github.com/terraform-linters/tflint/blob/master/docs/user-guide/plugins.md), allowing customization for different providers, coding styles, and project requirements. For example, rules like `terraform_naming_convention` or `terraform_required_providers` can improve code consistency and compliance. By exploring TFLint’s built-in rules and plugins, teams can tailor configurations to their project’s needs. <br/><br/>
The [built-in rules cover core Terraform language](https://github.com/terraform-linters/tflint-ruleset-terraform) best practices such as required Terraform version, deprecated syntax, unused declarations, and variable typing. They come pre-installed with TFLint, so there is no need to install them separately. For provider-specific rules (e.g., AWS, Azure, GCP), TFLint uses plugins that is enabled in `.tflint.hcl` configuration file. For example, there are over [700 AWS rules available](https://github.com/terraform-linters/tflint-ruleset-aws), and similar extensive rule sets exist for other providers like [MS Azure](https://github.com/terraform-linters/tflint-ruleset-azurerm) and [Google Cloud](https://github.com/terraform-linters/tflint-ruleset-google/blob/master/README.md). <br/>
Custom rules using the `TFLint plugin` framework allows for enforcing team-specific standards, detecting advanced anti-patterns, and aligning code with organizational policies. <br/>
To enable a plugin, edit the `.tflint.hcl` file and add the version and source. For example, to add AWS and Azure plugins before code has to be added : <br/>

![image](https://github.com/user-attachments/assets/672b269b-4b83-4f38-85f8-1b36cabae88e)
 <br/><br/>

![image](https://github.com/user-attachments/assets/9458635e-cc37-44d1-8591-566fe1511945)


### Configuring TFLint in DevOps pipelines (refer .tflint.hcl & deploy.yml files in repo as an example)
Integrating TFLint into DevOps pipelines is streamlined with a `.tflint.hcl` configuration file in repository, ensuring automatic compliance checks for every code change. Pipeline steps for initialization (`tflint --init`) and execution (`tflint -f compact`), coupled with a failure mechanism (`exit 1` on errors), automate validation and enforce high IaC deployment standards.
# Security Scanning with tfsec
`tfsec` is an [open-source static code analysis security scanner designed specifically for Terraform code](https://github.com/aquasecurity/tfsec), analyzing infrastructure-as-code configurations to detect potential security risks, insecure resource configurations & misconfigurations before deployment. The tool detects  common cloud security misconfigurations and high-risk infrastructure patterns that could expose systems to compromise. It supports compliance with AWS/Azure/GCP best practices and includes hundreds of built-in checks mapped to industry standards such as CIS Benchmarks and PCI-DSS. By running these checks automatically, `tfsec` helps ensure that Terraform configurations remain compliant with security and regulatory requirements for Cloud environments. It analyzes the code without executing it, making it effective for early detection of misconfigurations. <br/>
By integrating tfsec into DevOps pipelines, security checks can be automated to run early and consistently with every code change. This `shift-left approach` ensures security is embedded from the start. When legitimate exceptions exist, teams can suppress findings using the `#tfsec:ignore:<rule>` directive (as demonstrated in the S3 bucket example), maintaining scan accuracy while allowing necessary deviations. Overall, `tfsec` helps teams maintain compliance with AWS/Azure/GCP security best practices while minimizing manual review efforts. Like `tflint`, `TFSec` enables shift-left security by identifying risks during development rather than post-deployment, when fixes become more costly and disruptive. The scanner enforces alignment with AWS/Azure well-architected framework principles by default, validating configurations against hundreds of cloud provider-specific security benchmarks for comprehensive protection. <br/><br/>
Unlike `TFLint`, which lints for style and correctness, `tfsec` focuses on security-specific analysis, complementing `TFLint` to deliver robust IaC quality and safety. Together, `tflint` and `tfsec` provide a layered approach to improve both code quality and security posture in Terraform-based infrastructure. <br/><br/>
`Maintenance Note`: tfsec is no longer actively maintained, with its [features merged into Trivy](https://www.youtube.com/watch?v=GGWinWTHqCY), but it remains widely used for Terraform scanning. <br/>
# Extending Analysis with SonarCloud for Non-Terraform Code
SonarCloud extends automated quality and security coverage beyond IaC by analyzing application code and scripts for bugs, vulnerabilities, and code smells, complementing TFLint and tfsec’s focus on IaC. This provides a holistic view of code quality across the entire technology stack, enabling teams to maintain consistent standards from infrastructure to application code. The unified approach future-proofs DevOps pipelines by establishing common quality metrics and automated gates that ensure both infrastructure and application code meet organizational standards, ultimately creating a more maintainable and secure software ecosystem. A suggested integration strategy involves adding SonarCloud analysis steps alongside TFLint and TFSec in the pipeline workflow. <br/>
This approach future-proofs DevOps pipelines, ensuring that as codebase and team grows, consistent quality and compliance are maintained across all code types. For best results, import DevOps repositories into SonarCloud, configure automatic analysis, and use customizable quality gates to align with your organization’s standards.<br/>
# Quality Gates : Failing CI/CD pipelines on Errors
This GitHub Actions workflow implements a series of quality gates that ensure infrastructure code meets specific standards before deployment. <br/> In CI/CD pipelines, quality gates act as automated checkpoints that enforce specific criteria before allowing code to progress through the pipeline. These gates ensure that only high-quality, secure, and compliant code is deployed to production environments. These checkpoints act as pass/fail barriers integrated into the pipeline, ensuring only high-quality, secure, and compliant changes reach production.These standards may include code quality metrics, security compliance, formatting rules, or policy checks. <br/>

#### How Quality Gates Work in this Workflow : From Code to Secure deployment

A high-level view of the CI/CD pipeline: This simplified diagram illustrates the fundamental principle of the automated DevOps pipeline : Code undergoes rigorous checks through "Quality Gates" before it is approved for "Deployment. <br/>
<img width="900" height="251" alt="image" src="https://github.com/user-attachments/assets/55b556c9-50e3-45ab-829b-af158f7add5d" /> <br/><br/>

The diagram below illustrates the series of automated quality gates applied to every code change in the Terraform CI/CD pipeline (GitHub Actions workflow `deploy.yml` file). <br/>
<img width="1833" height="427" alt="image" src="https://github.com/user-attachments/assets/e4060fe0-8be1-4481-90aa-83499990d385" /><br/><br/>

Quality gates are strategically integrated using tools like `TFLint` and `tfsec` to enforce the following. Each gate performs a specific validation and they are fully automated—triggered on every push or pull request to `main` branch. If any gate fails, the pipeline stops immediately, and feedback is provided to the developer, enabling early resolution (Shift Left principle). The gates are mapped to the actual stages of the CI/CD pipeline (`terraform fmt`, `validate`, `tflint`, `tfsec`, `plan`, and `apply`). <br/>
  * `Format Check`: Validates code style and structure using terraform fmt and tflint.<br/>
  * `Linting Gate (TFLint)`:Ensures Terraform code is syntactically correct, well-documented, and follows best practices. If issues are found, the pipeline fails via `exit 1`.<br/>
  * `Security Gate (tfsec)`: Scans for misconfigurations and vulnerabilities using `tfsec`.<br/>
  * `Syntax Gate (terraform validate)` : Ensures the Terraform code is valid and error-free before plan and apply stages (syntactic correctness). <br/>
  * `Plan Review`: Generates and inspects the Terraform execution plan. <br/>
  * `Deployment`: The final gate corresponds to `terraform apply`, contingent on all prior gates passing.<br/>
  * `Automation-First` : All quality checks are fully integrated and automatically triggered, requiring no manual execution to validate infrastructure standards. <br/>
  * `Security-First, Shift-Left & Quality`: Issues are detected early in the development lifecycle — during development or pull request (PR) stages — rather than after deployment in production.`Shift-Left` means moving testing, security, and quality checks earlier in the software development lifecycle (SDLC), i.e., “to the left” on the timeline.<br/>
  * `Fail-Fast Mechanism` : The pipeline is configured to `exit with code 1` on failure of linting (`tflint`) or security scanning (`tfsec`), ensuring only compliant code progresses through the pipeline.<br/>
<br/>

# GitHub Actions CI/CD Workflow: deploy.yml
The pipeline defines two logically separate jobs:
 * `terraform`: Handles linting, scanning, planning, and applying infrastructure changes. Triggered on every push or pull request to the `main` branch, this job runs a full quality-gated pipeline, ensuring deployments are carefully controlled.It proceeds only if all checks pass (fail-fast on errors) & plans and applies Terraform changes automatically. <br/>
 <img width="407" height="616" alt="image" src="https://github.com/user-attachments/assets/7d255790-b46d-4aa2-a676-1d806a4f1a86" /> <br/>

 * `destroy` job – teardown on Demand : Provides a controlled way to tear down the deployed infrastructure, but only runs manually (requires explicit invocation for safety (`workflow_dispatch`)). This protects against accidental destruction while giving admins/clients the ability to cleanly remove resources when needed. Automating destruction ensures that temporary environments, sandbox deployments, and test resources can be torn down safely without manual mistakes, keeping cloud costs under control. <br/>
 <img width="316" height="575" alt="image" src="https://github.com/user-attachments/assets/c56cd06c-0484-42cd-89eb-6f803c4d2b6a" /> <br/>

 * The pipeline follows an `automation-first` & `security-first` approach with multiple quality gates, ensuring infrastructure code meets high standards before deployment. Complete implementation details in the `deploy.yml` file in the GitHub repository. This implementation aligns with industry best practices for CI/CD pipelines, where automation is fundamental to maintaining consistent quality and security standards. <br/>
 * `Automated Quality and Security`: Continuous checks for code quality (TFLint) and security vulnerabilities (TFSec) directly within the pipeline. <br/>
# Expanding into Database DevOps: Integrating database changes into CI/CD pipelines
`Database DevOps` refers to the practice of applying `DevOps principles` to database development and management — streamlining the development, deployment, and lifecycle of database changes alongside application and infrastructure code. I recently worked on such a project and found it extremely valuable for customers. We managed RDBMS DML/DDL changes through CI/CD pipelines, applying them consistently and automatically to a cloud-managed RDBMS service. Below are benefits & everyone should adopt Database DevOps.
  * `Automated Deployments` – Database scripts are deployed automatically without manual intervention.<br/>
  * `Developer Independence` – Application teams can self-serve DB changes without waiting for Cloud Infrastructure teams.<br/>
  * `Minimized Operational Overhead` : Reduce operational toil & DBA dependency through infrastructure-as-code practices and CI/CD-enabled self-service database change management. We were able to save 30+% labour costs.<br/>
  * `Faster Releases` – Speeds up application delivery by integrating DB changes directly into the CI/CD pipeline.<br/>
  * `Enhanced Consistency`: Ensure the exact same database state across all environments (Dev, QA, Prod) with repeatable deployments.<br/>
  * `Database DevOps` eliminates bottlenecks, reduces manual errors, and aligns database workflows with modern `DevOps automation practices`. It’s a beneficial recommended for every DevOps practitioner to explore it. While tools like `Flyway` and `Liquibase` offer powerful capabilities, we were able to achieve many key aspects of `Database DevOps` effectively by using normal GitHub CI/CD workflows alone. This reduces complexity and learning overhead while still delivering robust automation. <br/>
# Appendix
Below are some additional resources and references for further learning: <br/>
1. [What is TFLint and How to Lint Your Terraform Code](https://spacelift.io/blog/what-is-tflint)<br/>
2. [TFLint, covering installation, configuration, usage](https://www.devopsschool.com/blog/terraform-tutorials-tflint-covering-installation-configuration-usage/)<br/>
3. [Enhancing Terraform Deployments with TFLint in GitHub Actions](https://dev.to/techielass/integrating-tflint-into-your-workflow-iea)<br/>
4. [TFLint rules : terraform_unused_declarations](https://github.com/terraform-linters/tflint-ruleset-terraform/blob/main/docs/rules/terraform_unused_declarations.md)<br/>
5. [TFLint AWS Complete ruleset](https://github.com/terraform-linters/tflint-ruleset-aws/blob/master/docs/rules/README.md)<br/>
6. [TFLint with Jenkins](https://awstip.com/tflint-with-jenkins-858957b87c7e)<br/>
7. [What is tfsec? How to Install, Config, Ignore Checks](https://spacelift.io/blog/what-is-tfsec) <br/>
8. [A Deep Dive Into Terraform Static Code Analysis Tools: Features and Comparisons](https://devdosvid.blog/2024/04/16/a-deep-dive-into-terraform-static-code-analysis-tools-features-and-comparisons/)<br/>
9. [Terraform Tutorials: TFSec for Security Scanning](https://www.devopsschool.com/blog/terraform-tutorials-tfsec-for-security-scanning/)<br/>
10. [Secure your Terraform CI/CD Pipelines with tfsec](https://www.youtube.com/watch?v=yq-10oIkkpg&t=583s)<br/>
11. [Scanning Terraform Configuration with Trivy](https://www.youtube.com/watch?v=yf8JC-aNIV8&list=PLZOToVAK85Mptw7_ik3ZJzds68FJfVeDP&index=4)<br/>
12. [Automate the Automation with Terraform: GitHub Edition](https://www.youtube.com/watch?v=SL--5ixnI_M&list=PLsOrrjBMkLaSTbANljH7HnhwevEV3IKXM&index=10)<br/>
13. [Trivy Terraform Scanning](https://www.youtube.com/watch?v=BWp5JLXkbBc)<br/>
14. [Using tfsec to Scan Your Terraform Code - by Hashicorp](https://www.youtube.com/watch?v=ZvqqkTzddrg)<br/>
15. [Secure your Terraform CI/CD Pipelines with tfsec](https://www.youtube.com/watch?v=yq-10oIkkpg&t=159s)<br/>
16. [GitHub Actions Tutorial: Advanced Concepts You Should Know (Part 1)](https://www.youtube.com/watch?v=E2RRxcq_08E)<br/>
17. [GitHub Actions Tutorial: Advanced Concepts You Should Know (Part 2)](https://www.youtube.com/watch?v=TKj0KyX8m8o)<br/>

