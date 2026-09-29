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


---

# is formal verification worth the effort?

We have **LLM**s. They read the whole spec in seconds, for cents, and they get better every day.

So if clankers can hunt gaps in the English directly, **why write the spec a second time (and maintain it), in a language none of us can read (e.g.: TLA+)?**

Moreover, formal verification only ever checks **small setups**. The checker walks every state, but only for sizes fixed up front (e.g.: 2 channels and 3 jobs). Anything too big, the number of states explodes and verification becomes infeasible.

<!--
State the counter-argument at full strength before answering it. This is the objection most of the room is already thinking, and Edil may raise the opposite one. No verdict here; the next slide is the table, and the room decides.
-->

---

<!-- _class: dense -->

# arguments **for** vs **against** formal verification

| | **FV** | **no FV** |
|---|---|---|
| **for** | <ul><li>"no gap" becomes a fact (under small setup sizes)</li><li>a durable artefact, re-checked on every spec change (assuming the model is also updated)</li><li>writing the model surfaces ambiguity before any checking runs</li></ul> | <ul><li>KISS</li><li>comfort zone</li><li>easy to manage engineering efforts</li></ul> |
| **against** | <ul><li>a second artefact that can drift from the English (extra maintenance burden)</li><li>none of us can write or review FV languages today</li><li>exhaustive only for small setups (e.g. 2 channels, 3 jobs); larger ones explode the state space</li><li>competes for the scarce resource: human hours</li></ul> | <ul><li>LLM = a stochastic reader, not a deterministic evaluator</li><li>"found no gap" ≠ "no gaps exist"</li><li>LLMs only "imagine" states, like humans</li><li>LLMs are prone to "hallucinations"</li><li> a closed gap can silently reopen and nobody is warned</li></ul> |

<!--
Keep it neutral on the slide; the room decides. Points to have ready if asked. The two are not substitutes: an LLM is a reader, in the same world as us on the Penrose picture; a model checker is an evaluator. LLMs lower the cost of the model path: they can draft TLA+ from the English, explain a counterexample trace in plain words, and flag where the English and the model disagree. The drift problem cuts both ways: an LLM review has no artefact to drift from, which is exactly why nothing accrues. The validate problem is identical on both paths: neither a reader nor a checker knows what we meant. Bounded checking is the honest ceiling. The checker walks every reachable state, but only for a finite instance: you pin the counts (channels, jobs in flight, queue depth) before running, and the state space multiplies with each extra actor or value, so runs go from seconds to never. "No gap found" therefore means "no gap up to those sizes"; a gap needing four jobs during a prev-hash change is outside a three-job walk. Why it is accepted anyway: the small-scope hypothesis, most protocol bugs come from interleavings of a few actors, not from large counts, and AWS found bugs at 3 to 5 nodes that years of testing at scale had missed. Confidence grows by raising the counts until nothing new appears. Unbounded claims need proofs (TLAPS), far costlier, not where Sv2 should start. Cost is the real argument against: the bottleneck is human hours, and the model path spends them up front.
-->

---

# formal verification **open questions**

- how much closer to completeness would FV really get us?
- how much effort to translate the entire spec?
- how much effort to translate parts of the spec (e.g.: subprotocols in isolation)?
- how much effort to maintain the model (in face of spec changes)?
- which language to use? TLA+? Quint? P? something else?

I'm not in a rush to answer these questions.

For now, they remain open for us to explore over the next months.
