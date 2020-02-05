Return-Path: <SRS0=0Y1A=3Z=lists.openwall.com=kernel-hardening-return-17670-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C7DC352A1
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:40:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 729CF214AF
	for <kernel-hardening@archiver.kernel.org>; Wed,  5 Feb 2020 22:40:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 729CF214AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17670-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9266 invoked by uid 550); 5 Feb 2020 22:39:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9246 invoked from network); 5 Feb 2020 22:39:47 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225092431"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	arjan@linux.intel.com,
	keescook@chromium.org
Cc: rick.p.edgecombe@intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH 00/11] Finer grained kernel address space randomization
Date: Wed,  5 Feb 2020 14:39:39 -0800
Message-Id: <20200205223950.1212394-1-kristen@linux.intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello! This is an RFC for a proof of concept I've been working on to
improve KASLR by making it finer grained. I hope you will take a look at this
and give me some feedback on the general concept as well as the early
implementation. At this point in time, the code is functional, although
there is lots of room for optimization and improvement. This patchset applies
to 5.5.0-rc7

The TL;DR summary is: This patch set rearranges your kernel code at load time 
on a per-function level granularity, with only around a second added to
boot time.

Background
----------
KASLR was merged into the kernel with the objective of increasing the
difficulty of code reuse attacks. Code reuse attacks reused existing code
snippets to get around existing memory protections. They exploit software bugs
which expose addresses of useful code snippets to control the flow of
execution for their own nefarious purposes. KASLR moves the entire kernel
code text as a unit at boot time in order to make addresses less predictable.
The order of the code within the segment is unchanged - only the base address
is shifted. There are a few shortcomings to this algorithm.

1. Low Entropy - there are only so many locations the kernel can fit in. This
   means an attacker could guess without too much trouble.
2. Knowledge of a single address can reveal the offset of the base address,
   exposing all other locations for a published/known kernel image.
3. Info leaks abound.

Finer grained ASLR has been proposed as a way to make ASLR more resistant
to info leaks. It is not a new concept at all, and there are many variations
possible.

Proposed Improvement
--------------------
This patch set proposes adding function reordering on top of the existing
KASLR base address randomization. The over-arching objective is incremental
improvement over what we already have, as well as something that can be
merged and deployed with as little disruption to our existing kernel/ecosystem
as possible. It is designed to work with the existing solution, although it
can be used independently (not sure why you would do that though...). The
implementation is really pretty simple, and there are 2 main area where
changes occur:

* Build time

GCC has an option to place functions into individual .text sections. We can
use this option to implement function reordering at load time. The final
compiled vmlinux retains all the section headers, which can be used to help
us find the address ranges of each function. Using this information and
an expanded table of relocation addresses, we can shuffle the individual
text sections immediately after decompression. You are probably asking
yourself how this could possibly work given the number of tables of
addresses that exist inside the kernel today for features such as exception
handling and kprobes. Most of these tables generate relocations and
require a simple update, and some tables that have assumptions about order
require sorting after the update. In order to modify these tables, we
preserve a few key symbols from the objcopy symbol stripping process for use
after shuffling the text segments.

Some highlights from the build time changes to look for:

The top level kernel Makefile was modified to add the gcc flag if it
is supported. For this RFC, I am applying this flag to everything it is
possible to randomize. Future work could turn off this flags for selected
files or even entire subsystems, although obviously at the cost of security.

The relocs tool is updated to add relative relocations. This information
previously wasn't included because it wasn't necessary when moving the
entire .text segment as a unit. 

A new file was created to contain a list of symbols that objcopy should
keep. We use those symbols at load time as described below.

* Load time

The boot kernel was modified to parse the vmlinux elf file after
decompression to check for our interesting symbols that we kept, and to
look for any .text.* sections to randomize. We then shuffle the sections
and update any tables that need to be updated or resorted. The existing
code which updated relocation addresses was modified to account for not
just a fixed delta from the load address, but the offset that the function
section was moved to. This requires inspection of each address to see if
it was impacted by a randomization. We use a bsearch to make this less
horrible on performce.

In this patch we utilize a pseudo-random number generator in order to allow
for known seeds to be used to create repeatable images across multiple
boots. This is purely for debugging - obviously not recommended for use
in production. This pseudo-random number generator code is very much just
an experiment and not ready for merging yet. We also block access to 
/proc/kallsyms for any non-privileged user so that we don't give away our new
layout.

Does this improve security though?
----------------------------------
The objective of this patch set is to improve a technology that is already
merged into the kernel (KASLR). Obviously, this code is not a one stop
shopping place for blocking code reuse attacks, but should instead be
considered as one of several tools that can be used. In particular, this
code is meant to make KASLR more effective in the presence of info leaks.
A key point to note is that we are basically accepting that there are
many and various ways to leak address today and in the future, and rather
than assume that we can stop them all, we should find a method which makes
individual info leaks less important. Many people claim that standard KASLR
is good enough protection if the attacker does not have access to the host
machine, but for example, CVE-2019-0688 demonstrated that addresses can
be obtained even with remote attacks. So if you define a threat model in which
the kernel has W^X (executable memory is not writable), and ideally XOM
(execute only memory, neither readable nor writable), and does have info leaks,
this patch will make derandomizing the kernel considerably harder. How much
harder will depend on how much entropy we add to the existing entropy of
standard KASLR. There are some variables that determine this. Firstly and most
obviously, the number of functions you randomize matters. This implementation
keeps the existing .text section for code that cannot be randomized - for
example, because it was assembly code, or we opted out of randomization for
performance reasons. The less sections to randomize, the less entropy. In
addition, due to alignment (16 bytes for x86_64), the number of bits in a
address that the attacker needs to guess is reduced, as the lower bits are
identical. For future work, we could explore randomizing the starting
position of the function and padding with INT3s if we wanted to make the
lower bits unique. Having a XOM solution for the kernel such as the one
for VM guests on X86 platforms that is currently under discussion makes
finer grained randomization more effective against JIT-ROP and other
variations.

Other solutions
---------------
CFI is another method of mitigating code reuse attacks. CFI attempts to
prevent control flow from being diverted to gadgets (snippets of code
anywhere in the text section) by restricting calls to validated
function entry points.

* Forward Edge CFI
Common forward edge CFI implementations will check the function signature to
make sure that control flow matches the expected function signature. This
reduced the number of calls that will pass a forward edge CFI check to those
that match the original function's signature. Unfortunately, the kernel has
many functions with the same signature, so forward CFI in and of itself still
allows an attacker to potentially change to a different valid function with
the same signature.

In theory, finer grained randomization can be combined with CFI to make this
even harder, so CFI and finer grained KASLR do not need to be
competing solutions. For a kernel with both forward edge CFI and function
level randomization, an attacker would have to call to a function which not
only matched the function signature, but they would also need to take the
extra step to find the address of the new function they want to call.

In practice, I have not tested this combination, as I used standard kernel
build tools (gcc, not clang) and CFI was not an option.

* Backward edge CFI
Backward edge CFI is not available for X86 at all today, so in the case of
modifying a return address, there is no CFI based solution for today's
X86 hardware running upstream Linux.

Performance Impact
------------------
There are two areas where function reordering can impact performance: boot
time latency, and run time performance.

* Boot time latency
This implementation of finer grained KASLR impacts the boot time of the kernel
in several places. It requires additional parsing of the kernel ELF file to
obtain the section headers of the sections to be randomized. It calls the
random number generator for each section to be randomized to determine that
section's new memory location. It copies the decompressed kernel into a new
area of memory to avoid corruption when laying out the newly randomized
sections. It increases the number of relocations the kernel has to perform at
boot time vs. standard KASLR, and it also requires a lookup on each address
that needs to be relocated to see if it was in a randomized section and needs
to be adjusted by a new offset.

Booting a test VM on a modern, well appointed system showed an increase in
latency of approximately 1 second.

* Run time
The performance impact at run-time of function reordering varies by workload.
Using kcbench, a kernel compilation benchmark, the performance of a kernel
build with finer grained KASLR was about 1% slower than a kernel with standard
KASLR. Analysis with perf showed a slightly higher percentage of 
L1-icache-load-misses. Other workloads were examined as well, with varied
results. Some workloads performed significantly worse under FGKASLR, while
others stayed the same or were mysteriously better. In general, it will
depend on the code flow whether or not finer grained KASLR will impact
your workload, and how the underlying code was designed. Future work could
identify hot areas that may not be randomized and either leave them in the
.text section or group them together into a single section that may be
randomized. If grouping things together helps, one other thing to consider
is that if we could identify text blobs that should be grouped together
to benefit a particular code flow, it could be interesting to explore
whether this security feature could be also be used as a performance
feature if you are interested in optimizing your kernel layout for a
particular workload at boot time. Optimizing function layout for a particular
workload has been researched and proven effective - for more information
read the Facebook paper "Optimizing Function Placement for Large-Scale
Data-Center Applications" (see references section below).

Image Size
----------
Adding additional section headers as a result of compiling with
-ffunction-sections will increase the size of the vmlinux ELF file. In
addition, the vmlinux.bin file generated in arch/x86/boot/compressed by
objcopy grows significantly with the current POC implementation. This is
because the boot heap size must be dramatically increased to support shuffling
the sections and re-sorting kallsyms. With a sample kernel compilation using a
stock Fedora config, bzImage grew about 7.5X when CONFIG_FG_KASLR was enabled.
This is because the boot heap area is included in the image itself.

It is possible to mitigate this issue by moving the boot heap out of .bss.
Kees Cook has a prototype of this working, and it is included in this
patchset. 

Building
--------
To enable fine grained KASLR in the prototype code, you need to have the
following config options set (including all the ones you would use to build
normal KASLR)

CONFIG_FG_KASLR=y

Modules
-------
The same technique can be applied to modules very easily. This patchset
demonstrates how you can randomize modules at load time by shuffling
the sections prior to moving them into memory. The module code has
some TODOs left in it and has been tested less than the kernel code.

References
----------
There are a lot of academic papers which explore finer grained ASLR and
CFI. This paper in particular contributed the most to my implementation design
as well as my overall understanding of the problem space:

Selfrando: Securing the Tor Browser against De-anonymization Exploits,
M. Conti, S. Crane, T. Frassetto, et al.

For more information on how function layout impacts performance, see:

Optimizing Function Placement for Large-Scale Data-Center Applications,
G. Ottoni, B. Maher

Kees Cook (3):
  x86/boot: Allow a "silent" kaslr random byte fetch
  x86/boot/KASLR: Introduce PRNG for faster shuffling
  x86/boot: Move "boot heap" out of .bss

Kristen Carlson Accardi (8):
  modpost: Support >64K sections
  x86: tools/relocs: Support >64K section headers
  x86: Makefile: Add build and config option for CONFIG_FG_KASLR
  x86: make sure _etext includes function sections
  x86/tools: Adding relative relocs for randomized functions
  x86: Add support for finer grained KASLR
  kallsyms: hide layout and expose seed
  module: Reorder functions

 Makefile                                 |   4 +
 arch/x86/Kconfig                         |  13 +
 arch/x86/boot/compressed/Makefile        |   8 +-
 arch/x86/boot/compressed/fgkaslr.c       | 751 +++++++++++++++++++++++
 arch/x86/boot/compressed/head_32.S       |   5 +-
 arch/x86/boot/compressed/head_64.S       |   7 +-
 arch/x86/boot/compressed/kaslr.c         |   6 +-
 arch/x86/boot/compressed/misc.c          | 109 +++-
 arch/x86/boot/compressed/misc.h          |  26 +
 arch/x86/boot/compressed/vmlinux.lds.S   |   1 +
 arch/x86/boot/compressed/vmlinux.symbols |  15 +
 arch/x86/include/asm/boot.h              |  15 +-
 arch/x86/include/asm/kaslr.h             |   4 +-
 arch/x86/kernel/vmlinux.lds.S            |  18 +-
 arch/x86/lib/kaslr.c                     |  83 ++-
 arch/x86/mm/init.c                       |   2 +-
 arch/x86/mm/kaslr.c                      |   2 +-
 arch/x86/tools/relocs.c                  | 143 ++++-
 arch/x86/tools/relocs.h                  |   4 +-
 arch/x86/tools/relocs_common.c           |  15 +-
 include/asm-generic/vmlinux.lds.h        |   2 +-
 kernel/kallsyms.c                        |  30 +-
 kernel/module.c                          |  85 +++
 scripts/kallsyms.c                       |  14 +-
 scripts/link-vmlinux.sh                  |   4 +
 scripts/mod/modpost.c                    |  16 +-
 26 files changed, 1312 insertions(+), 70 deletions(-)
 create mode 100644 arch/x86/boot/compressed/fgkaslr.c
 create mode 100644 arch/x86/boot/compressed/vmlinux.symbols

-- 
2.24.1

