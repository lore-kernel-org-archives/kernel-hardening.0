Return-Path: <SRS0=1dnL=IQ=lists.openwall.com=kernel-hardening-return-20982-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E779DC433DB
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Mar 2021 20:30:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id AC4A564F2B
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Mar 2021 20:30:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC4A564F2B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20982-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32135 invoked by uid 550); 18 Mar 2021 20:29:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32100 invoked from network); 18 Mar 2021 20:29:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ho87J6eBnrzvMhlROePhrL98b3pIWd3frnZLw7ws+CA=;
        b=AY4CrRfsaehVRuiYeyzHv6B3MRuRU8KFPXhTzw97dlwolVaQu5T/IttrBM5sB4BmD8
         Vh0ZdytEUMgVNdf7MMjJVMXu6bZNJ3Jc3vlMWQn77GzsEUJCC21Px6NVQ3JWLO8bO/gr
         oHVtbLGxlVyWE6DyqCyhUFEAI8r9Q4/C+UwKE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ho87J6eBnrzvMhlROePhrL98b3pIWd3frnZLw7ws+CA=;
        b=LUv2ccQz/j46y+N02v1QaFKIeg2gtJpQa4QvCO5+WjHJAsG0fS4qDThiFMMBbCpkB3
         u4/8DjAgAyFhwEksMqPJw3bysCHNg0fckV3xiwFphoPWHigVLDf5AEIG6VgjWXUqtkwu
         Gyi5UePNqJqrrHLHdzMWal+Zu8BRf0WfHB/m5Q5WIuWR2A7AqDTq8Tl1v9fTO+vnZxRu
         Xr3tTQvERq56p6tV4b3raQPdn4WwrvkwcpUeI6WIc0Uim2ys5Ckcugui1gitxD2/K1mv
         rYBeRz7qBQ1U5DQPNT2EC41gfFO3YEa9POclwndK5zXXc5FbpqdrhginyNQd/UjMujwI
         FRGA==
X-Gm-Message-State: AOAM532CXlenlotR+4efJ30xEF49NxwFkgry0DWohYSlrDE+dW/Ta1Yw
	nJqepqYMnSnkuxagZnWPFAZRzQ==
X-Google-Smtp-Source: ABdhPJyNbXshl2UGjwPHxer+RbDZ8VzpD4vyjWQO7waN8/B6RK8CvEKmqGmSThQuSGIgEGJB5Kcf1Q==
X-Received: by 2002:a17:902:9786:b029:e6:508a:7b8c with SMTP id q6-20020a1709029786b02900e6508a7b8cmr11267036plp.44.1616099379489;
        Thu, 18 Mar 2021 13:29:39 -0700 (PDT)
Date: Thu, 18 Mar 2021 13:29:37 -0700
From: Kees Cook <keescook@chromium.org>
To: Joao Moreira <joao@overdrivepizza.com>
Cc: x86-64-abi@googlegroups.com, kernel-hardening@lists.openwall.com,
	samitolvanen@google.com, hjl.tools@gmail.com,
	linux-hardening@vger.kernel.org
Subject: Re: Fine-grained Forward CFI on top of Intel CET / IBT
Message-ID: <202103181230.2CA57FA5@keescook>
References: <0537dc00-db0e-265b-9371-783c55717e74@overdrivepizza.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0537dc00-db0e-265b-9371-783c55717e74@overdrivepizza.com>

On Wed, Feb 10, 2021 at 09:51:29PM -0800, Joao Moreira wrote:
> Hi,

Hi Joao!

Sorry for the delay in replying to this -- I wanted to make sure I could
give it my proper attention. :)

> Below is a design proposal on how to support toolchain-enabled fine-grained
> CFI on top of Intel CET. While all the proposed details are open for
> discussion, some are explicitly in need of investigation and feedback. A
> prototype implementation using LLVM and GLIBC's GRTE branch is also linked

I had to look this one up: GRTE is a port of glibc that builds with
Clang, yes?

> at the end of the document. Any feedback and comments on this are very much
> appreciated.
> 
> * Introduction
> 
> This proposal leverages the use of Intel's Control-Flow Enforcement
> Technology (CET) feature in a way to enable a Fine-Grained Indirect-Branch
> Tracking policy. As implemented in hardware, CET introduces new endbranch
> (endbr) instructions that should be properly placed in the addresses
> targeted by indirect branches as a way to make them valid. This approach is
> deemed "Coarse-grained" because under the policy enforced every endbr
> instruction is considered a valid target for every indirect branch.
> Fine-grained policies are more restrictive than that, in the sense that they
> enforce a given indirect branch to only target a subset of all possible
> indirect branch destinations. The most common fine-grained policy used for
> the control-flow enforcement is requiring that, in an indirect call, the
> prototype of the targeted function matches the prototype of the function
> pointer used to call it.

Well described! :)

> The above-described prototype-based approach is already used by different
> tools, including Clang, through the parameter -fsanitize=cfi. This
> implementation uses jump tables to enforce the prototype-based policy what,
> although not harmful from the control-flow granularity perspective, can
> introduce meaningful overheads. The hereby presented approach, FineIBT,
> takes advantage of the CET endbranch instructions to enforce additional
> prototype verifications after indirect control-transfers to functions. This
> implementation materializes the concept briefly introduced in the work by
> Shanbhogue et al. [1], where the authors suggest that a software layer
> should augment the hardware capabilities in providing a finer granularity on
> top of CET. A quick evaluation through microbenchmarks described ahead shown
> that when compared to runtimes of binaries with no CFI instrumentation, the
> Clang CFI introduced high overheads ranging from 5% to 52.8%, while FineIBT
> remained between 1% and 6.8%. Experimental tests executed on SPEC CPU 2017
> Benchmark (nc) shown that, in the worst case, FineIBT performed with only
> 3.3% additional overhead when compared to non-instrumented binaries.

That's a pretty significant difference!

> * Design and Implementation:
> 
> FineIBT consists of adding special instrumentation to the generated binary
> to enforce the verification of hashes on function prologues whenever these
> are indirectly called. These hashes are computed over function's and
> function pointer's prototypes during compilation time and are always
> referenced as instruction immediate operands, relying then on W^X properties
> to prevent corruption. For enabling the verification, the hash respective to
> a function pointer is set into a CPU register before the indirect call.
> Since indirect calls must target endbr instructions, the function prologue
> is then augmented with an endbr, similarly as in the coarse-grained
> approach, followed by the hash check respective to the function. Given that
> the endbr instruction is an anchor point through which the execution flow
> must pass when the function is reached indirectly, the checks cannot be
> bypassed. This specific instrumentation can be seen below -- in this
> example, the function <foo> sets 0xdeadbeef to the register R11, and then
> the function <bar> checks it before executing. If attackers manage to
> control the pointer within RAX, they won't be able to redirect control-flow
> in a way to enable the execution of functions with a different prototype
> other than <bar>'s, since the hash comparison will fail and the control-flow
> will reach the hlt instruction.
> 
> <foo>:
> ...
> movl 0xdeadbeef, R11d
> call *RAX
> ...
> 
> <bar>:
> endbr
> xor 0xdeadbeef, R11d
> jz entry
> hlt
> entry:
> ...
> 
> To reduce the possibility of reuse attacks where an attacker takes advantage
> of residual contents of R11 and then exploits an indirect call not preceded
> by a hash set operation, the proposed instrumentation makes use of a xor
> operation instead of a regular cmp instruction. Under this scenario, the
> content of R11 is always erased after each check, while a precise match will
> also result in R11 contents being zeroed and, thus, raising the flag needed
> for the following jz instruction to take the right execution path. The
> register R11 was picked since it is considered a scratch register in the
> X86-64 ABI, which prevents the need for saving and restoring it across
> called functions.

You mention this later on, but I'll mention it here: I like that this
solves a design issue I have with RAP in that it had to _read_ executable
memory, and that would preclude using execute-only memory (which, back
when CFI designs were being compared, looked to be relatively close on
the horizon for arm64, though it has receded a bit). And this clearing
of R11 is a nice way to avoid exposure.

You discuss this more later, and I'll add more notes there, but I
remain nervous about the fact that this approach uses dynamic checking
(i.e. against a register) instead of depending on hard-coded immediate
value checks: e.g. hard-coded table offset check (i.e. Clang CFI) or
hard-coded hash check before indirect calls (i.e. RAP). This means the
entry hash must remain secret to retain the protection -- which is not
great for distro kernels.

> The above-described instrumentation causes the hash to always be checked
> whenever the function is reached, irrespectively to the given control-flow
> being direct or indirect. Since direct flows don't need to be validated and
> given that these unnecessary hash checks will also require hashes to be set
> before direct calls take place, direct calls have their targeted addresses
> incremented by an offset equivalent to the length of the prologue
> instrumentation, in a way to skip the hash check snippet and prevent
> undesirable overheads for useless operations.

Doesn't this mean that a target that is reach both via direct and
indirect calls will end up with two endbr instructions? Wouldn't that
render these targets as being effectively unprotected? (as in another
indirect call site that got overridden would set R11, call the
attacker-controlled saved pointer, only to reach the unchecked endbr?

> The described instrumentation works regardless of linking-time
> optimizations. Yet, it requires all objects composing a linked binary to be
> FineIBT-enabled. As described, FineIBT is auto-sufficient for statically
> linked binaries and is likely suitable for use-cases such as the Linux
> Kernel.

Right -- this is fine, the kernel expects to have the same toolchain for
all objects.

> * Dynamic Shared Objects Compatibility and GLIBC support
> 
> Current GLIBC support for CET-enabled binaries allows DSOs with and without
> the CET capabilities to be mixed, on the cost of the policy enforcement
> being disabled in the presence of feature-lacking binaries. FineIBT support
> must follow similar guidelines, allowing FineIBT-enabled DSOs to be mixed
> with other regular DSOs without harming the core functionalities of the
> resulting process. For such, the implementation should generate binaries
> with a FineIBT flag bit in the x86 features ELF note. FineIBT, as
> implemented in the prototype, uses the bit 0x10 since bits 0x1 and 0x2 are
> already taken for IBT and SHSTK CET features, and 0x4 and 0x8 are taken for
> LAM features. This way, whenever the linker is generating a FineIBT-enabled
> DSO, it should flag the binary as such.

This seems reasonable -- it's nice to have such bits available for
things like this.

> When loading a new DSO into the process's memory space (either at load time
> or runtime), the loader should check and confirm that all loaded DSOs are
> FineIBT-enabled through checking the FineIBT flag bit, then setting a
> process' specific flag that reflects the state of the enforcement. This way,
> just like in the regular CET support, when the loader identifies a binary
> without the FineIBT flag bit set, it unsets the process' specific bit for
> the feature, disabling the enforcement of the policy. During runtime loading
> (dlopen), if the process is enforcing FineIBT, the success of loading a
> non-FineIBT DSO depends on the loading policy being permissive. If this is
> the case, it will lead to the FineIBT enforcement being disabled.
> 
> Since FineIBT relies on IBT, its enablement depends on IBT being enforced on
> the process. If IBT is disabled, either at load time or during runtime,
> FineIBT should also be disabled.
> 
> Given the presence of the FineIBT bit in the process in an adjacent position
> to the other x86 feature bits, the hash checking instrumentation should then
> be extended to the following snippet which, after a failure in the hash
> check, asserts if FineIBT is being enforced before halting the application.
> 
> <bar>:
> endbr
> xor 0xdeadbeef, R11d
> jz entry
> testb 0x10, FS:0x48
> jz entry
> hlt
> int3
> nopw
> entry:
> ...
> 
> The resulting instrumentation can be encoded in 25 bytes, which are then
> followed with int3 and nopw instructions to achieve a 32-byte alignment.
> 
> At this point, deciding which check should be done first is open for debate,
> since having the hash check first is optimal for a case where FineIBT is
> being enforced, but more costly for processes running with FineIBT is
> disabled.

I have fewer opinions about userspace implementations, but given the
design, this idea seems reasonable. It looks like a lot of cycles, but
it's actually not: xor is extremely fast as in jz.

> ** PLT
> 
> In an execution environment where libraries are present, the access to
> functions that are in a different DSO will happen through the Procedure
> Linkage Table (PLT). To support FineIBT, a special PLT entry is used as
> shown below.
> 
> <foo@PLT>:
> 1:
> endbr
> cmp 0xdeadbeef, R11d
> je 3f
> testb 0x10, FS:0x48
> hlt
> int3
> int3
> ...
> 2:
> mov 0xdeadbeef, R11d
> 3:
> jmpq foo@GOT
> int3
> ...
> 
> The proposed PLT entry has a total of 64 bytes and is composed of three main
> pieces, respectively labeled as 1:, 2: and 3:. The first one is the piece of
> the PLT entry reached when the external function is called indirectly.
> First, it anchors the execution with an endbr instruction, then it checks
> the hash and if it is a match, it jumps to the label 3:, otherwise following
> to the FineIBT bit check and eventual execution of the hlt instruction,
> which breaks the invalid flow. The second piece is positioned exactly 32
> bytes after the PLT entry start and is reached through direct calls, which
> have their targets incremented with an offset, as explained in the first
> section of this document. This piece will set the hash in R11d, as an
> indirect branch is about to take place ahead and the to-be-reached function
> will likely do a hash check in its prologue. The third piece, which is
> reached either through the branch in the first piece or through sequential
> execution from the second piece will then jump into the function respective
> to the PLT entry.
> 
> The standard lazy binding done in ELF binaries can be harmful to the
> proposed scheme because, on the occasion of a target not being already
> resolved, the dynamic linker will be invoked and this will lead to control
> flows which may destroy the hash previously set in R11. Given that this hash
> should never be stored in writable memory due to security reasons, the
> design does not consider saving it on the stack for later restore, instead
> it relies on eager binding, which is also widely supported by most standard
> toolchains (it can be set through -Wl,-z,now in lld). Because eager binding
> is in place, the need for resolving dynamically linked symbols no longer
> exists. In face of that, the second PLT used in IBT binaries (as described
> in the X86-64 ABI) is not needed for FineIBT binaries.
> 
> Given that 2: does not have an endbranch instruction and, then, is only
> supposed to be accessed through direct branches, the respective hash set
> operations shouldn't be exploitable.
> 
> Additionally, the use of eager binding enables .GOT.PLT entries to be
> read-only, which prevents the following indirect-call from being abused and
> opens a window for optimization. In this scenario, the instruction "no-track
> prefix" can be used to allow a jump over the target's hash check
> instrumentation, preventing needless instructions from being executed.
> Optimizations in the PLT scheme weren't extensively evaluated and are still
> open for investigation.
> 
> To emit the PLT entry correctly, the linker needs to be informed about the
> hash values respective to the functions being reached through the entry.
> Since a linker handles binaries, prototype information is not available at
> the moment of linking. To overcome this, the compiler was augmented with the
> capability of emitting a special section named .ibt.fine.plt in the
> generated object. This section brings a table with the hashes of the
> external symbols which might get a PLT entry at the moment of linking,
> making it possible for the linker to retrieve the information needed to emit
> the PLT table. This section does not need to be included in the final linked
> object and is discarded after being used by the linker.
> 
> For functions that should not perform hash checks due to compatibility
> issues (such as functions indirectly called from assembly code or those
> called from pointers with opaque prototypes), the proposed implementation
> brings the attribute "CoarseCfCheck" which leads the compiler into
> generating the respective function without the hash checks but with the
> endbr instruction, plus an instruction that zeroes R11 (to prevent reuse
> attacks), plus padding nops (to ensure the 32 bytes alignment).

I'll let other respond about the PLT design. My only comment is that I
don't think it's entirely unreasonable drop the need to support
mixed-support environments, but this is likely due to me spending too
much time doing Chrome OS image builds where the entire "distro" is
rebuilt from scratch for each image. ;) Though I've long been a
proponent of having distros completely rebuild all their packages for
each release to gain compiler hardening benefits across a given archive,
but that only happens in very narrow cases still.

But, for wide adoption, yes, mixed environments is important, especially
given that this (currently) depends on Clang, and most general purpose
distros build with a mix of GCC and Clang.

> 
> * Security Considerations:
> 
> The most obvious attack vector regarding the proposed implementation is an
> attempt to control both R11 and a function pointer in the moment of an
> indirect call. In general, assuming that an attacker cannot diverge
> control-flow arbitrarily because of the coarse-grained CET primitives and
> that the proposed instrumentation overwrites the contents of R11 with a new
> hash right before the indirect call takes place, the window of opportunity
> for such attacks is very small (but maybe existent when interfacing with
> hand-written assembly code). Either way, to squeeze it even further, the
> compiler can remove R11 from the bank of available registers, only using it
> for holding the hashes. The expectancy is that by having none or fewer
> references to R11 in the binary (except for the hash sets and checks)
> attackers won't be able to control it.

That is a good point about R11 availability. Have you examined kernel
images for unintended gadgets? It seems like it'd be rare to find an arbitrary R11 load
followed by an indirect call together, but stranger gadgets show up, and
before the BPF JIT obfuscation happened, it was possible for attackers
(with sufficient access) to construct a series of immediates that would
contain the needed gadgets. (And not all systems run with BPF JIT
hardening enabled.)

> Notice that using a fixed R11 is not a requirement for the whole scheme to
> work, but a hardening feature.

Right -- it seems like the gadgets would be more likely than a
legitimate reuse window, but it'd be nice to actually have some
measurements.

> * Hash Computation:
> 
> Up to this point, the proper way of computing the prototype hashes was not
> evaluated, and this topic is still open.

I think anything with sufficient bit diffusion is fine. And in a more
advanced version of this, like the at-boot relocation updates and
alternatives code rewrites, it should be possible to update the hashes
so the values were per-boot permuted.

> * Future Improvements:
> 
> Right now, three key details remain explicitly in need for attention: (i)
> how to optimize the PLT to prevent unnecessary overheads, (ii) in which
> order should the hash and FineIBT flag bit be checked, and (iii) the best
> way to compute the prototype hashes. Of course that all other topics and
> ideas are open for discussion and improvement.

For the kernel, i) and ii) don't come into play. For iii), I imagine a
truncated sha256 of the prototype sufficient? (Though it should check
for collisions, just so nothing is a surprise.)

Also the kernel, DSO handling is pretty different. The kernel is
effectively its own linker, and it wires up relocations and symbols
in modules. The very nice feature about FineIBT, like RAP, is that the
resulting hashes are universal: they match in DSOs and in the kernel.
Right now with Clang CFI, there is some overhead with DSOs needing to
perform dynamic checks (i.e. calling __check_cfi()) for jump tables that
aren't shared by the object (i.e. the kernel needs to do dynamic checks
for indirect calls to module functions and modules need to do dynamic
checks for indirect calls to kernel functions).

Saving on that overhead would be quite nice.

> * Evaluation:
> 
> To evaluate the performance of FineIBT we performed two sets of tests.
> First, we implemented a micro-benchmark with three different applications:
> (i) a bubble-sort implementation in which the swap operation was invoked
> indirectly; (ii) a Fibonacci sequence calculator in which the recursion is
> made through indirect calls; and (iii) a dummy loop which calls an empty
> function indirectly. These three applications were selected as the indirect
> calls represent a significant part of their computation, and they were
> compiled under the following four different setups: (i) NO CFI: regular
> binary compilation, with no special flags; (ii) CLANG CFI: binaries compiled
> with the default Clang CFI, which enforces a jump-table-based policy
> (through -flto -fsanitize=cfi -fsanitize-cfi-cross-dso -fvisibility=default
> -fno-sanitize-cfi-canonical-jump-tables); (iii) COARSE CET: binaries
> generated with IBT as supported by Clang only (through
> -fcf-protection=full); and (iv) FINE CET: binaries generated with FineIBT,
> as proposed above, with R11 reserved. All applications are single-threaded
> and each was run 10 times. The numbers compared and shown are the average of
> the runtime values observed.
> 
> Due to difficulties in compiling GLIBC with the CLANG CFI instrumentation,
> we replaced the library with MUSL for these experiments. MUSL 1.2.0 was used
> with some small changes [2] to add very basic support for CET plus some
> modifications to make it compatible with FineIBT.
> 
> The tests were run on a machine equipped with an 11th Gen Intel(R) Core(TM)
> i5-1145G7 & 2.60GHz 8 Core CPU with 16G of RAM. The operating system for the
> tests was a CET-enabled Linux Fedora 33 (Workstation Edition). CET was
> verified to be active through the execution of an application that violates
> the enforced policy. All applications were dynamically linked to MUSL, which
> was also compiled under the same control-flow enforcement policy as the
> application itself (i.e.: NO CFI, COARSE CET, FINE CET, or CLANG CFI). As a
> replacement for libgcc, the LLVM runtime library compiled with the
> coarse-grained IBT policy was used for the NO CFI, CLANG, and COARSE CET
> setups, and with FineIBT policy for FINE CET.
> 
> The numbers observed for these tests can be seen below. The baseline for the
> overhead comparison in parenthesis is the setup without CFI (NO CFI). The
> times presented are in msecs and were collected through perf for 10 runs of
> each application. The parameters for the applications were a 50000 entries
> randomly-generated array for bubbl (the same array was used on each run and
> setup), 44 for the Fibonacci computation, and 10^10 calls for the dummy
> application.
> 
>       |   NO CFI  |     CLANG CFI     |    COARSE CET     | FINE CET     |
> bubbl |  5729.11  |  6014.67  (4.98%) |  5713.85 (-0.27%) | 5837.13 (1.02%)
> |
> fibon |  4539.09  |  5514.07 (21.48%) |  4508.75 (-0.67%) | 4846.83 (6.78%)
> |
> dummy | 15296.34  | 23367.13 (52.76%) | 14687.78 (-3.98%) | 15455.24 (1.04%)
> |
> 
> Willing to evaluate the effects of this instrumentation on a heavier
> workload, we did an experimental test running four applications from SPEC
> CPU 2017 Benchmark (nc). Given the use of opaque pointers in the
> applications and that no source code changes are allowed in the benchmark,
> we modified FineIBT to use the same tag for all different prototypes,
> emulating the actual performance overheads while not enforcing a real
> fine-grained policy. We also did not run the CLANG CFI setup. This time, the
> SPEC CPU 2017 applications were linked to a GLIBC compiled accordingly to
> the respective setup. The GLIBC support for FineIBT was implemented on top
> of a GRTE branch, which is known for being compatible with Clang.
> 
> The numbers observed for these tests can be seen below as collected and
> presented by the SPEC CPU 2017 framework, with runtimes presented in
> Seconds. A total of 10 runs were executed for each application, and the best
> fitting result was selected by SPEC. The baseline for the comparison in
> parenthesis is, once again, the setup without CFI (NO CFI).
> 
>                 |  NO CFI  |    COARSE CET    |     FINE CET    |
> 600.perlbench_s |  248.83  |  247.67 (-0.47%) |  257.14 (3.34%) |
> 602.gcc_s       |  365.47  |  369.03 ( 0.97%) |  368.75 (0.90%) |
> 605.mcf_s       |  576.80  |  570.63 (-1.07%) |  579.86 (0.53%) |
> 625.x264_s      |  152.63  |  152.63 ( 0.00%) |  154.21 (1.04%) |
> 
> * Related implementations
> 
> The work by Martin Abadi [3] is assumed to be the first academic paper
> published on Control-Flow Integrity. Despite that, ideas that strongly mold
> the current design and goals of the CFI state-of-the-art were previously
> published in the document pax-future.txt [4]. The core idea behind a
> fine-grained forward-edge CFI scheme on top of CET was originally surfaced
> by Shanbhogue et al. [1].
> 
> From a functional perspective, when compared to the existing fine-grained
> CFI policy supported by Clang [5], both schemes provide the same level of
> granularity, but FineIBT does not depend on jump tables, preventing the
> overheads that can be introduced by these.
> 
> Although wired differently, FineIBT is not the first CFI mechanism to use
> registers to carry hashes for prototype checking. Microsoft's xFG [6] uses a
> similar resource but anchors the control-flow execution with tags embedded
> into the binary. Other implementations that also use tags embedded into the
> binary, but don't depend on registers, are PaX RAP [7] and kCFI [8] (both
> focused on the kernel context).
> 
> Up to this point, we did not compare FineIBT's performance with any other
> CFI implementation besides Clang's.

Have you done FineIBT builds of the kernel? I'm curious how much work is
needed to instrument assembly. This was one of the awkward problems that
needed work in Clang CFI (and needs some more, honestly).

> When compared to schemes that use binary-embedded tags, FineIBT doesn't
> depend on reading tags that are mixed with code, which makes it compatible
> with approaches such as execute-only memory [9]. As is, FineIBT also
> provides some degree of compatibility to dynamically adapt and interact with
> non-FineIBT DSOs without requiring any binary changes, even though this
> comes at the price of disabling the enforcement.
> 
> * Source-code:
> 
> Prototype implementations of FineIBT are available in:
> 
> FineIBT capable compiler:
> - https://github.com/intel/fineibt_llvm/
> 
> FineIBT capable GLIBC (a fork from GRTE):
> - https://github.com/intel/fineibt_glibc/
> 
> Some building scripts and a test application:
> - https://github.com/intel/fineibt_testing/
> 
> The easiest way to build everything (if your environment has all the needed
> tools):
> 
> git clone https://github.com/intel/fineibt_testing/
> cd fineibt_testing
> git clone https://github.com/intel/fineibt_llvm/
> git clone https://github.com/intel/fineibt_glibc/
> ./build-infra.sh # and go enjoy a good cup of coffee for a few minutes...
> ./build-examples.sh
> cd examples/build
> export LD_LIBRARY_PATH=./ # have fun :)
> 
> You may want to edit the building scripts to adapt details, such as the
> number of cores or to test different configuration setups. Also, notice
> that, as is in the prototype, fineibt_llvm is emitting the same tag
> regardless of the prototypes.

I love that this is published for people to play with! If anyone has
time to try this on the kernel, I'd love to hear about it.

> * Acknowledgments:
> 
> The author would like to thank Vedvyas Shanbhogue, Michael LeMay, Hongjiu Lu
> (Intel), and Prof. Vasilis Kemerlis (Brown University) for meaningful
> contributions and insightful discussions during the development of this
> research.
> 
> * References:
> 
> 1 - Vedvyas Shanbhogue, Deepak Gupta, and Ravi Sahita. 2019. Security
> Analysis of Processor Instruction Set Architecture for Enforcing
> Control-Flow Integrity. In Proceedings of the 8th International Workshop on
> Hardware and Architectural Support for Security and Privacy (HASP ’19).
> Association for Computing Machinery, New York, NY, USA, Article 8, 1–11.
> DOI:https://doi.org/10.1145/3337167.3337175
> 
> 2 - Joao Moreira. Add CET IBT Support to MUSL. 2020.
> https://www.openwall.com/lists/musl/2020/10/19/3
> 
> 3 - Martín Abadi, Mihai Budiu, Úlfar Erlingsson, and Jay Ligatti. 2005.
> Control-flow integrity. In Proceedings of the 12th ACM conference on
> Computer and communications security (CCS ’05). Association for Computing
> Machinery, New York, NY, USA, 340–353.
> DOI:https://doi.org/10.1145/1102120.1102165
> 
> 4 - PaX Team. 2003. pax-future.txt.
> https://pax.grsecurity.net/docs/pax-future.txt
> 
> 5 - Clang 12 Documentation. Control Flow Integrity.
> https://clang.llvm.org/docs/ControlFlowIntegrity.html
> 
> 6 - David "dwizzzle" Weston. Bluehat Shanghai 2019. Advanced Windows
> Security. https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE37dMC
> 
> 7 - PaX Team. 2015. RAP: RIP ROP.
> https://pax.grsecurity.net/docs/PaXTeam-H2HC15-RAP-RIP-ROP.pdf.
> 
> 8 - Joao Moreira, Sandro Rigo, Michalis Polychronakis, and Vasileios P.
> Kemerlis. 2017. Drop the ROP: Fine-Grained Control-Flow Integrity for the
> Linux Kernel. BLACK HAT ASIA 2017, Singapore.
> https://github.com/kcfi/docs/blob/master/kCFI_whitepaper.pdf
> 
> 9 - Rick Edgecombe. 2019. XOM for KVM guest userspace.
> https://lore.kernel.org/kvm/20191003212400.31130/

Thanks for the references; these all make good reading for anyone
interested in this area.

What are your plans for next steps here?

Thanks for all this work and the extensive write-up; I'm quite excited
to see more. :)

-Kees

-- 
Kees Cook
