---
marp: true
theme: sv2
paginate: true
html: true
title: towards Sv2 spec completeness
---

<!-- _class: title -->
<!-- _paginate: false -->

<span class="sym">∀</span>
<span class="sym">∃</span>
<span class="sym">∧</span>
<span class="sym">¬</span>
<span class="sym">∨</span>
<span class="sym">□</span>
<span class="sym">⊕</span>
<span class="sym">⊙</span>

![h:140](img/sv2-logo.png)

# towards Sv2 spec **COMPLETE**ness<br>👨‍💻 🤖 📜

plebhash · SRI R&D call · 2026-10-01

---

## Penrose's 3 worlds

![h:420](https://astudentforever.wordpress.com/wp-content/uploads/2015/03/three-worlds-roger-penrose.jpg) ![h:420](https://i.ibb.co/PK1gRn9/penrose3world.jpg)

---

![bg right:42%](img/ideal-vs-draft.png)

Somewhere in the platonic realm of all possible Bitcoin mining protocols there is a **COMPLETE** Sv2 spec.

What we have today is a **DRAFT**.

Good enough to start building on.

But still **WIP**.

---

In this talk, I want to convince you that:
- finding a **COMPLETE** Sv2 spec is possible.
- arriving at a **SPEC-COMPLIANT** Reference Implementation is also possible.
- both journeys above feed back into each other.

---

Three words to define:
- **specification**
- **completeness**
- **formal verification**

---

<!-- _class: dense -->

# specification

A body of English prose, written and read by humans and AI agents. This is where the protocol first **exists**: it is drafted here, and reasoned about here.

It defines the **objects** of the protocol and the rules that bind them:

- **actors**: who takes part
- **state**: what each actor holds at any moment
- **vocabulary**: the messages, fields and identifiers they exchange
- **relations**: what must already hold before an actor may act
- **actions**: what an actor may do next, and what that changes

From these, **"what happens next?"** should follow for every situation.

A **gap** is where two readers derive different answers, and both are "compliant".

<!--
Say the Sv2 instances out loud: actors are mining device, proxy, pool, template provider, job declarator; vocabulary is SetupConnection, channel_id, job_id, the share; relations are things like "a share references a job on a channel this connection opened"; actions are SubmitShares and its accept/reject. Two implementations that never met interoperate only if they derive the same answer. A gap is not a crash, it is a fork in behaviour nobody notices until two implementations meet. Concrete Sv2 gap example here.
-->

---

# (consistent) completeness

- **Completeness**: for every reachable state and every message, the text says **what happens next**. A complete protocol spec has **no gaps**.

- **Consistency**: the text never says two **contradictory** things.

A spec that contradicts itself "says" everything, so it is trivially complete (not really what we're aiming for). The goal is **both**.

<span class="note">Note: **Gödel's incompleteness** does not apply here: a finite state machine cannot encode arithmetic, and every question about a finite structure has exactly one answer.</span>

<!--
The pair "complete and consistent" is Hilbert's program (1920s): give all of mathematics axioms that are both. Gödel (1931) showed any axioms strong enough for arithmetic can never be both. That is why completeness alone is a bad target: an inconsistent theory proves everything. A protocol escapes Gödel because its theory cannot encode arithmetic; Sv2 does arithmetic inside (targets, difficulty) but on fixed-width values, never as a theory of the naturals. On "finite": Sv2 state is bounded per connection; unbounded queues or sequences would make the state infinite in principle, which is exactly what a TLA+ model bounds before checking. Not every open choice is a gap: pool policy, timeouts, retries are freedom we chose; a gap is freedom nobody chose. Implementers will ask this.
-->

---

# completeness ≠ no freedom

Complete does not mean no freedom of implementation. A choice the text grants explicitly is a **MAY** (RFC2119), not a **gap**.

for example, *§5.3.13*:
> A server MAY aggregate acknowledgements for multiple successful share-submission messages from the same channel into a single `SubmitShares.Success` response.

<!--
Contrast with a gap: there both readers are also "compliant", but by accident, because the text was silent. Freedom we chose versus freedom nobody chose. Pool policy, timeouts, retries are the same kind of MAY.
-->

---

<!-- _class: dense -->

# formal verification

English is **interpreted**. Two careful readers can disagree, and both be right about the text (even if they're AI agents). That is what a **gap** is.

**Formalization** rewrites the spec in a notation where every symbol has exactly one meaning. The text is no longer interpreted, it is **evaluated**: same question, same answer, whoever asks.

In languages such as TLA+, the spec becomes a body of **formulae** (logical, not arithmetic) that say which state transitions the protocol allows. That body of formulae constitutes a **model**.

**Formal verification** means running a **model checker**. This process is deterministic and exhaustive, as it walks **every reachable state**:
- a state with no next step is a gap
- a broken invariant is a contradiction

<span class="note">Note: what no model checker can assert: whether the model says what we **meant**.
Model checkers verify, humans validate.</span>

<!--
Formal verification demystified: not proving code correct, but writing the protocol a second time in a notation a machine can exhaustively explore (formalization), then letting the machine explore it (verification). Lamport's point is that a TLA+ spec is a formula: initial state, and at every step one of the allowed transitions. Nothing new: AWS, Paxos, Raft were checked this way. TLC literally reports a state with no enabled action as a "deadlock", the mechanical detector for silent gaps. The English and formal texts are mirrors of the same protocol; where they disagree, one of them has a gap. The verify/validate split is the principled reason humans stay in the loop: the formula has no oracle for intent but us.
-->

---

![bg contain](img/fv-combined.png)

<!--
Formal verification in one picture. Left: the same English text, two careful readers, two different diagrams. That is interpretation, and the difference between the diagrams is a gap. Right: the same text rewritten as a formula, a block of notation with one meaning, and the formula unfolded into every state it allows, walked by a checker with no imagination involved. The two amber spots are what it reports: an arrow that leads nowhere is a state with no next step, a gap; a node whose arrows point at clashing targets is a broken invariant, a contradiction.
-->
