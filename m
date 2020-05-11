Return-Path: <SRS0=VWLm=6Z=lists.openwall.com=kernel-hardening-return-18749-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B61CC47255
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 May 2020 16:12:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7AB6F2070B
	for <kernel-hardening@archiver.kernel.org>; Mon, 11 May 2020 16:12:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="VIc4g3sr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AB6F2070B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18749-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30372 invoked by uid 550); 11 May 2020 16:12:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30337 invoked from network); 11 May 2020 16:12:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r0IepoHEyFNdPVH93WTe2QwBRZ1xWj61FhlXgV/R33k=;
        b=VIc4g3sr/pD4IhYLaLqoDbX2W2HXcwhF3UFDPxSFCMSaC0aS//RD/+sBzAtGt2GmZw
         1TXVwmavxflyajJViYjNqs4AgU6/6Vpzh7y3jzYOOBjV2pH14y0MVXhUEUIbeE1ZKoVe
         7+WC+JvU9irmbBrRlnjNcP0tazCyXCQXrBD8s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r0IepoHEyFNdPVH93WTe2QwBRZ1xWj61FhlXgV/R33k=;
        b=G54p9okjQFeoAkjn8r7X2oiXnDBR+8w4/fjDklKycAKr+g0Ew4Wl++c2D/0B0TBmZ9
         dcW2mwFtTLCm3bbXcOB+NNUzC76WoYpVgXyE+oR0Y1HZepCpTPmTcwpoQWmKUb928548
         D16nx/proRuM+Ki+0IbJ+Bu+m6082nQQiOOwNhNlBG5upAYQHCM/i+ymxJNn8jatBmMM
         mkYLQgCHbdoC6DaOHrzf53dDv/w6+k8H23GhZ3tlF8NfBx8NHVTH5cRjMUqB0QqCgm58
         SgMWcx5RWjAnK+5u4lbk8aoiDdd3z4wrYr4t9Mo7ojxnRi83Ukg6q0EbyNh4tMyhhhrW
         oprg==
X-Gm-Message-State: AGi0PubJbFXlLxLi06Zmsra3+C/8OZMk1xUylSJXC5kjiJVevuA4mobi
	mntAgGJZgM0cCRWSUDKmd1Uk2Q==
X-Google-Smtp-Source: APiQypIvCX8268qu7dtl5U8mp2MbAbc0S3yeM/uvPiMgHdQrK7eXMs4da3ZWj7hgSe5canx230O1Yw==
X-Received: by 2002:a17:90a:37ea:: with SMTP id v97mr24688442pjb.206.1589213533222;
        Mon, 11 May 2020 09:12:13 -0700 (PDT)
Date: Mon, 11 May 2020 09:12:10 -0700
From: Kees Cook <keescook@chromium.org>
To: wzt wzt <wzt.wzt@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: Open source a new kernel harden project
Message-ID: <202005110748.DF82DDD6@keescook>
References: <CAEQi4beJgmNfZ0NsWSHCok9-5H_qLze_sFJ_G=1j8CBz9qi2rQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEQi4beJgmNfZ0NsWSHCok9-5H_qLze_sFJ_G=1j8CBz9qi2rQ@mail.gmail.com>

On Sun, May 10, 2020 at 10:16:25AM +0800, wzt wzt wrote:
>     This is a new kernel harden project called hksp(huawei kernel self
> protection),  hope some of the mitigation ideas may help you, thanks.
>     patch: https://github.com/cloudsec/hksp

Hi,

Thanks for letting people know about this! I took a quick look through
the patch and I think there are some interesting bits in there. As Greg
mentioned, it would probably be worth splitting these changes out into
separate patches with full commit logs, documentation, etc. Then it'll
be easier to follow the patch submission process[1]. And, similarly,
please send individual patches inline so people can comment on them
directly.

As you've mentioned, this code is still in early stages, but I have
two general observations that might help direct further work:

- Some features are x86-only. What do you think about extending
  those features to other architectures?

- Many of the features are notification-only, in that once a bad
  situation is detected, it will only perform a printk() and do no
  mitigation. It would be best to add situation-specific mitigations
  (though note that the kernel avoids using BUG()[2]).

I have some other notes below...

[1] https://www.kernel.org/doc/html/latest/process/submitting-patches.html
[2] https://www.kernel.org/doc/html/latest/process/deprecated.html#bug-and-bug-on

> =============================
> Huawei kernel self protection
> =============================
> 
> Cred guard
> ----------
> - random cred's magic.

I think this would be easy to upstream. Perhaps note that this is a
per-boot random value now. And please don't printk the value[3]:
https://github.com/cloudsec/hksp/blob/master/hksp.patch#L986
- you could just redefine CRED_MAGIC to be the global instead of
  changing the code that uses CRED_MAGIC.
- the global credit magic should likely not live in init_cred, since
  that takes up space in every task, and gets copied all over the place.
  I think a single global variable would be better.

>   most kernel exploit try to find some offsets in struct cred,
>   but it depends on CONFIG_DEBUG_CREDENTIALS, then need to compute
>   the right offset by that kernel config, so mostly the exploit code
>   is something like that:
>   if (tmp0 == 0x43736564 || tmp0 == 0x44656144)
>         i += 4;

In this feature's description, please include a note that it changes the
effort needed by an attacker to needing an additional memory content
exposure to mount such a cred attack now. (i.e. they need to read a
valid cred magic to copy during a cred write attack.)

> - detect shellcode like:
>   commit_creds(prepare_kernel_cred(0));
>   the common kernel code is never write like that.

Is this meant to refer to this code?
https://github.com/cloudsec/hksp/blob/master/hksp.patch#L1000
This only appears to check that prepare_kernel_cred() was called from
kernel space? Given SMEP and KPTI (which has emulated SMEP), is this
check useful on x86?

> Namespace Guard
> ---------------
> This feature detects pid namespace escape via kernel exploits.
> The current public method to bypass namespace is hijack init_nsproxy
> to current process:
>   switch_task_namespaces_p(current, init_nsproxy_p);
>   commit_creds(prepare_kernel_cred(0));

This is check_pid_ns()? This appears to only get checked on process
death? What's your plan for this check?
https://github.com/cloudsec/hksp/blob/master/hksp.patch#L1140

> Rop stack pivot
> --------------
> - user process stack can't be is mmap area.
> - check kernel stack range at each system call ret.
>   the rsp pointer can point below __PAGE_OFFSET.

This is check_stack_pivot()? Same question about only being checked on
process death. Also, why are certain uid ranges excluded from this
check?
https://github.com/cloudsec/hksp/blob/master/hksp.patch#L1043
Also, I think this check needs a lot more specialization because lots of
multithreaded application intentionally put their stacks into the mmap
range. Perhaps a per-process flag that indicated the process's
expectation about its thread stacks?

There is a lot of history here in attempts to track userspace stacks.
You can see it in commits like these that tried to track it and how they
had to be reverted:
https://git.kernel.org/linus/b76437579d13
https://git.kernel.org/linus/65376df58217
https://git.kernel.org/linus/b18cb64ead40

Having something that better attempted to track what a process has done
might be more sensible? (i.e. if it has never called clone(), maybe it
can have a strict stack check, otherwise, something else?)

> 
> Slub harden
> -----------
> - redzone/poison randomization.

This is interesting -- are production systems using redzoning?
Regardless, it seems like a reasonable change to provide. Though,
again, please don't print the value. ;)
https://github.com/cloudsec/hksp/blob/master/hksp.patch#L1611

> - double free enhance.
>   old slub can only detect continuous double free bugs.
>   kfree(obj1)
>   kfree(obj1)
> 
>   hksp can detect no continuous double/multi free bugs.
>   kfree(obj1)
>   kfree(obj2)
>   kfree(obj1)
> 
>   or
> 
>   kfree(obj1)
>   kfree(obj2)
>   kfree(obj3)
>   kfree(obj1)

Is this the code?
https://github.com/cloudsec/hksp/blob/master/hksp.patch#L1377
(Please don't use panic() -- a better attempt to mitigate is needed)

This check appears to be pretty expensive -- it's walking all objects
looking for a duplicate?

> - clear the next object address information when using kmalloc function.

Is this the code?
https://github.com/cloudsec/hksp/blob/master/hksp.patch#L1589

What's the benefit of this change? It looks pretty inexpensive; could it
be done by default?

> Proc info leak
> --------------
> Protect important file with no read access for non root user.
> set /proc/{modules,keys,key-users},
> /proc/sys/kernel/{panic,panic_on_oops,dmesg_restrict,kptr_restrict,keys},
> /proc/sys/vm/{mmap_min_addr} as 0640.

These seem like general changes that could be broken out. I don't see
why there would be much objection to making these less discoverable.
(Though I would point out that most attackers are going to assume all
these features, etc, are enabled.)

> Aslr hardended
> --------------
> User stack aslr enhanced.
> Old user process's stack is between 0-1G on 64bit.
> the actually random range is 0-2^24.
> we introduce STACK_RND_BITS to control the range dynamically.
> 
> echo "24" > /proc/sys/vm/stack_rnd_bits
> 
> we also randomize the space between elf_info and environ.
> And randomize the space between stack and elf_info.

This needs some pretty extensive checking and validation that there will
be no memory range collisions. Past changes to ASLR ranges have caused
hard-to-find on-execve() crashes with some unlucky randomization, etc.
But otherwise, yeah, I think it'd be really nice to have this be dynamic
as was done with the mmap ASLR.

> Ptrace hardened
> ---------------
> Disallow attach to non child process.
> This can prevent process memory inject via ptrace.

Hmm, this looks like duplication of the existing Yama LSM controls?
What's different?

> Sm*p hardened
> -------------
> Check smap&smep when return from kernel space via a syscall,
> this can detect some kernel exploit code to bypass smap & smep
> feature via rop attack technology.

I don't think this works correctly: you're checking the shadow, not the
real CR4. This seems like it somewhat complements the existing pinning?
https://git.kernel.org/linus/873d50d58f67ef15d2777b5e7f7a5268bb1fbae2
I like the idea of doing this kind of sanity checking at process exit,
though. It may be quite expensive, though (reading CR4 is slow).

> Raw socket enhance
> ------------------
> Enhance raw socket for ipv4 protocol.
> - TCP data cannot be sent over raw sockets.
>   echo 1 > /proc/sys/net/ipv4/raw_tcp_disabled
> - UDP datagrams with an invalid source address cannot be sent
>   over raw sockets. The IP source address for any outgoing UDP
>   datagram must exist on a network interface or the datagram is
>   dropped. This change was made to limit the ability of malicious
>   code to create distributed denial-of-service attacks and limits
>   the ability to send spoofed packets (TCP/IP packets with a forged
>   source IP address).
>   echo 1 > /proc/sys/net/ipv4/raw_udp_verify
> - A call to the bind function with a raw socket for the IPPROTO_TCP
>   protocol is not allowed.
>   echo 1 > /proc/sys/net/ipv4/raw_bind_disabled

These all seem pretty reasonable, though I suspect there will be a lot
of push-back under the expectation that there are already controls in
place to avoid these kinds of things (e.g. access to raw sockets is
already restricted). Regardless, I would break these up into individual
patches with justifications and rationales.

> Kernel self guard
> -----------------
> Ksguard is an anti rootkit tool on kernel level.
> Currently it can detect 4 types of kernel rootkits,
> These are the most popluar rootkits type on unix world.
> 
> - keyboard notifer rootkits.
> - netfilter hooks rootkits.
> - tty sniffer rootkits and other DKOM(direct kernel object modify) rootkits.
> - system call table hijack rootkits.

These kinds of checks are extremely hard to justify in upstream. Any
system where standard kernel interfaces are being used to subvert the
kernel are basically impossible to defend against. If something is
loading malicious kernel modules, there's virtually no way to defend
the kernel. A better solution is signed kernel modules, etc.

> Install:
> /sbin/insmod /lib/modules/5.6.7/kernel/security/ksguard/ksguard.ko
> 
> Feature:
> Detect keyboard notifer rootkits:
> echo "1" > /proc/ksguard/state
> 
> Detect netfilter hooks rootkits:
> echo "2" > /proc/ksguard/state
> 
> Detect tty sniffer rootkits:
> echo "3" > /proc/ksguard/state
> 
> Detect syscall table pointer:
> echo "4" > /proc/ksguard/state

If there is a rationale that isn't solved with kernel module signing,
this will need to be spelled out clearly. (Similarly, if this is a
post-exploitation forensics tool, again, the attacker can just change
how modules are loaded, etc.)

> Arbitrary code guard
> --------------------
> we extended the libc personality() to support:
> - mmap can't memory with PROT_WRITE|PROT_EXEC.
> - mprtect can't change PROT_WRITE to PROT_EXEC.

How does this compare to SARA?
https://lore.kernel.org/kernel-hardening/1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com/

I do like the idea of a simple W^X protection in userspace, almost like
the PR_SET_NO_NEW_PRIVS flag that will allow a process to declare that
it is not a JIT, etc.

> Code integrity guard
> --------------------
> To support certificate for user process execve.
> it can prevent some internet explorer to load
> third party so librarys.

This seems like it could be implemented with the IMA LSM?

> Hide symbol
> -----------
> Hide symbols from /proc/kallsyms.

Can you describe how this complements kptr_restrict and the %p hashing?
This removes a symbol entirely from the list, but I'm curious what
specific benefit that provides above the other mentioned features?

Which symbols would you suggest get added to this list? (Should there be
a starting baseline block list?)


I look forward to further versions; thanks again for sending this!

-- 
Kees Cook
