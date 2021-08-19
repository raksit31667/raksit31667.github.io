---
layout: post
title:  "สรุปสิ่งที่ได้เรียนรู้จาก workshop Software Architecture ปี 2019"
date:   2021-08-19
tags: [architecture]
---

## Architect
รูป 3 วงกลม

6 roles
- Investigator: สืบสวนสอบสวนเพื่อเข้าใจปัญหาก่อนที่จะเสนอแนวทางการแก้
- Butcher: สับแบ่งปัญหาออกเป็นปัญหาย่อยๆ
- Tactician: วางแผนในภาพใหญ่ๆ และมอบหมายหน้าที่ให้คนอื่นๆ
- Judge: เข้าใจและตัดสินใจจากข้อดี-ข้อเสียที่มี (trade-offs) เช่นการตัดสินใจด้วย CAP theorem
- Instructor: เพิ่มพูนความรู้ด้าน architecture ให้กับคนอื่นๆ
- Entepreneur: จัดการความเสี่ยงและหนี้ทางเทคนิค (technical debt) ให้อยู่ในจุดที่สมดุล

## Architecture vs Software architecture

> "Architecture represents the **significant design decisions** that shape a system where **significant** is measured by **cost of change**." - Grady Booch

> "Software Architecture is a set of **significant design decisions** about how the software is **organised** to promote desired **quality attributes** and other properties." - Michael Keeling

## Design thinking
HART
1. Design for Humans

> Process should serve people, not people serve process

แค่ทำตามๆ process กันไปโดยที่ไม่เข้าใจว่ามัน design ไว้เพื่ออะไร

Concrete umbrella
Scramble drawing
Ivory tower

- Fill people's needs?
- Easily understand?
- Collaborative process?

2. Preserve Ambiguity

> Delay decisions to the last responsible moment

3 Options with past and future, Option C will no longer be viable beyond this time

They might have an assumption but eventually up to a certain point, delay in decision starts to have cost because they start getting blocked

Why delay
- Change: in Agile we minimize cost of change, manage uncertainty
- Information: ตัดสินใจตอนนี้หรือทีหลัง Build or Buy?
- Pragmatism
- Budget

Convey's Law: the structure of architecture is going to reflect the structure of organisation

3. All Design is Redesign

> Reuse correctly & timely

จาก เจอ legacy -> เขียนใหม่ดีกว่า เป็น migrate monolith ออกมาทีละส่วน
ทำ report อันเดียว -> build from scratch
ทำ report เพิ่มซ้ำๆ -> สร้าง reporting engine

เรียนรู้จาก GCP, Azure, AWS

4. Make Design Tangible

C4 diagram
Context map
Architecture decision record

## Design mindset

Understand
- Business goals and quality attributes
- Trade-off slider
- CFR requirements gathering

Explore
- Patterns, tech, and solutions
- It promotes business goals and quality attributes
- Event storming
- Round robin design

Make
- Prototypes and models
- concretely realize Patterns, tech, and solutions
- Demonstrate business goals and quality attributes
- ADR, spike, sequence diagram

Evaluate
- Code review, architecture briefing

## Decision making

### RACI
R esponsible -> who perform -> developer
A ccountable -> who make decision -> architect
C onsulted -> who has info -> architect
I nformed -> who needs update

Architect
- Quality attributes, risk, inertia -> architectual guardrail (manual fitness functions) or sensible defaults (FAQ)

## Time investment
Development time + architecte and risk reduction time + rework time (fixing defects, rewrites, mistakes)

Graph
- The more think on architecting, the less time to rework
- The bigger codebase, more time to think architecting
- If you think too less or too much, project time grows
- There are sweet spots between architecturing and reductime time

Cost of change
- Sunk cost of analysis effort -> analyse wrong thing, need to spend time analysing other thing
- Sunk cost of existing work -> do some work, throw it away

Wrench in the works
- Incomplete information (We didn't know)
- Incorrect assumptions (We thought we knew)
- Changing environments (What we knew is obsolete)

Questions
- Can you start small?
- Can you split it to small parts?
- Can you spend more time to do analysis?
- Can you delay decision making?

## Software organisation

## Architectural patterns