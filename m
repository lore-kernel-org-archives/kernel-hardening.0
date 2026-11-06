Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 51A7E606A329
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Nov 2026 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kjb.biglobe.ne.jp header.i=@kjb.biglobe.ne.jp header.a=rsa-sha256 header.s=default-1th84yt82rvi header.b=mFRSKzsb
Received: (qmail 27736 invoked by uid 550); 6 Nov 2026 16:41:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1026 invoked from network); 6 Nov 2026 11:15:38 -0000
Message-ID: <ca90b945049ac3c27f3e1d9b8181137feb892436.camel@kjb.biglobe.ne.jp>
Subject: [RFC idea] Kernel API Firewall (kaf): subsystem-level attack
 surface reduction for the post-AI-CVE era
From: Nakashima Seiichi <s-nakashima@kjb.biglobe.ne.jp>
To: kernel-hardening@lists.openwall.com
Cc: keescook@kernel.org, mic@digikod.net, paul@paul-moore.com, Nakashima
 Seiichi Kurume <s-nakashima@kjb.biglobe.ne.jp>
Date: Fri, 06 Nov 2026 20:15:26 +0900
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Biglobe-Sender: s-nakashima@kjb.biglobe.ne.jp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kjb.biglobe.ne.jp; s=default-1th84yt82rvi; t=1793963727;
 bh=5xGvnS3qYoZJgYEDpY16gLidTUYEXBKpuMQSBedWw3g=;
 h=Subject:From:To:Cc:Date;
 b=mFRSKzsbu+1On4ICNy+JlVCBtMhfFh4nfvMqs419w/p3Qw8HEr3b9+pgOMKKbfEfPjCmlL0M
 424f96hYqXUT9KBQa3ewACWJ4eKow5lKwQ+lsM/i3bdEIn+xuK6QScoZ90BmDROtH2i+D+ipT+
 8YPsQA7Ezd2HSvbN34y0nGxQLo9vcRoDBnNBEfrHAtgiMeWq6Q18+KO9BMv1l2PA+kTFMLAcxu
 Y+fMDG1LfmznE1zz4n4cPwa1aptIocBNXyvOkF2GfMXknI0vGCZnUrk0u1V/I84P8czgArIU0a
 KPTDAiGTMxNI7glYJODkJuZMnAaBGbfJ4VMRshDk89WWV5wQ==
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

This is an idea I've been thinking about as a Linux user=C2=A0
who has seen the CVE flood firsthand.=C2=A0
I don't have the kernel development skills to implement this,
so I'm posting it here for feedback=C2=A0from people who do.

(This RFC was drafted with the help of Sakana AI's Namazu assistant.)

1. The problem

The CVE flood is real:

- 2023: ~300 kernel CVEs/year
- 2024: 4,355 CVEs (kernel became a CNA)
- 2025: 5,681 CVEs
- 2026 (YTD): 8,285 and climbing

AI-assisted vulnerability discovery is now generating valid kernel bugs
at scale (OpenAI's pipeline, Anthropic's Claude Code, Google's Project
Big Sleep). The upstream security list has gone from 2-3
reports/week=C2=A0to 5-10/day.

But the real pain is at the distribution layer.=C2=A0
Ubuntu 24.04's GA kernel (6.8) hit upstream EOL in May 2024,
yet backports for cloud and generickernels take 30-90 days.
CVE-2026-98432 (CVSS 9.8) was "work in progress"
for 3+ weeks on Ubuntu while Debian 13 patched next-day.

Users are left with three bad choices:
a) Wait indefinitely for distro patches
b) Switch to mainline and risk boot failures=C2=A0
   (NVMe/VirtIO driver changes between 7.0 and 7.3 caused=C2=A0
    multiple boot failures on various systems)
c) Apply network-level mitigations that don't address the kernel bug

2. The idea: Kernel API Firewall (kaf)

Instead of whack-a-mole with individual CVEs, restrict the *classes* of
kernel APIs that unprivileged processes can invoke.

Key insight: many kernel CVEs require specific subsystems to be
reachable.
If we can restrict access to dangerous kernel APIs at runtime, we can
mitigate entire vulnerability classes without waiting for patches.

3. What kaf would look like

Not syscall-level filtering (seccomp already does that). Subsystem-
level
semantic restrictions:

- bpf: disallow BPF_PROG_LOAD for unprivileged users entirely
- module: disallow init_module/finit_module after early boot
- kexec: always forbidden for non-root, even with CAP_SYS_BOOT
- ptrace: restrict to same UID or explicit allowlist
- userfaultfd: disable by default (historical exploitation vector)
- perf_event_open: restrict to specific events, disable hardware PMC
- io_uring: restrict ring size, disable specific opcodes
- namespace: restrict unshare of specific namespaces

These are semantic restrictions on kernel subsystems that multiple
syscalls may touch -- not individual syscall filters.

4. Proposed API (sketch)

Profiles would be kernel-defined and reviewed:

  KAF_PROFILE_CONTAINER  -- restrict bpf, module, kexec, ptrace
  KAF_PROFILE_WEBSERVER  -- restrict unnecessary network APIs
  KAF_PROFILE_DATABASE   -- restrict ptrace, process_vm_*, userfaultfd
  KAF_PROFILE_MINIMAL    -- maximum restriction

Applied per-process or per-cgroup:

  kaf_apply(KAF_PROFILE_CONTAINER, 0);

5. Why not just seccomp?

seccomp-bpf is excellent for syscall filtering but cannot express:

- "allow bpf() but only for socket filters, not cgroup skb programs"
- "allow perf_event_open() but not for hardware PMCs"
- "allow io_uring but limit ring size and disable these opcodes"

kaf would complement seccomp by operating at a higher semantic level.

6. Why this matters now

The "joint responsibility gap" between distro vendors (Canonical) and
hardware/cloud providers means nobody owns kernel validation for many
deployment scenarios. Faster backporting alone cannot solve a
structural
problem where:

- upstream patches within 24-48 hours
- distributions take 30-90 days for some kernel variants
- users are exposed the entire time

A built-in attack surface reduction mechanism would give users a
"defense in depth" layer that works *while waiting for patches*.

7. Related work and how kaf differs

Existing mechanisms that overlap partially:

- seccomp-bpf: syscall-level filtering (complementary, not a
replacement)
- Landlock: filesystem/network access control (complementary)
- Yama: ptrace_scope sysctl (overlaps with one kaf feature)
- io_uring per-task restrictions (Jens Axboe, 2026): io_uring only
- lsm_config_self_policy() (Maxime Belair, Canonical 2025):
  LSM self-policy configuration syscalls (conceptually related)
- Academic work:
  - Kurmus et al. 2014: "Quantifiable Run-time Kernel Attack Surface
Reduction"
  - Narayanan et al. 2019 (USENIX ATC): "LXDs: Towards Isolation of
Kernel Subsystems"
  - Yang et al. 2024: "Optimus: association-based dynamic syscall
filtering"
  - Findlay et al. 2020: "bpfbox: Simple Precise Process Confinement
with eBPF"

None of the above provide:
- subsystem-level semantic restrictions (e.g., "allow bpf() but only
  for socket filters")
- kernel-defined profiles that distributions can ship as safe defaults
- a unified mechanism covering bpf, module, kexec, ptrace, userfaultfd,
  perf, io_uring, and namespace restrictions

kaf differs by proposing all of the above as a single, upstream
kernel mechanism.

8. What I can offer

I am not a kernel developer. I cannot write kernel code.=C2=A0
What I can offeris limited to:

- This idea itself
- Real-world operational data on which CVE classes would have been
  mitigated (based on my experience as a Linux user)
- Testing on Ubuntu LTS systems (I am willing to test any prototype
  and provide detailed feedback)
- Documentation and user-facing tooling (I can write docs and scripts)
- Feedback on profile design from a non-developer user perspective

If someone with kernel development experience thinks this is worth
pursuing, I am willing to participate in testing and provide feedback.
I cannot contribute code, but I can help validate whether the design
actually solves real-world problems.

9. Open questions (where I need help)

- Is this the right abstraction level, or should we extend seccomp-bpf
  with higher-level filters instead?
- Should this be a new LSM, a seccomp extension, or part of Landlock?
- What granularity makes sense: syscall, subsystem, or capability-
based?
- Can eBPF be used to make profiles dynamically loadable and
verifiable?
- How do we avoid creating another "user tests for us" situation?

Thanks for reading.

