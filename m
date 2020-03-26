Return-Path: <SRS0=annt=5L=lists.openwall.com=kernel-hardening-return-18235-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA2DCC43331
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 17:19:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EBE3920737
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Mar 2020 17:19:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="bOPaTx6G"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBE3920737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18235-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25723 invoked by uid 550); 26 Mar 2020 17:19:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25682 invoked from network); 26 Mar 2020 17:19:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FuNH3TvottBd6Vom+HjZUn38bx12HjWSuxT5PFFp2NM=;
        b=bOPaTx6GdaN/kw3TDtNtl7YJvpKCdLmNpmXwiUaOV/H2Dyt1eisLQis+PnTqW9A+cy
         EpkaDdfA5uo4DCk1ebTh4faj0FTdvUrGM01MpAbv2nSbK+gGglpLa6jzzOF6TUBcNS18
         J+EdB85pXrJ9G1gjVsQGSBY1SA1XxTOvVWnGc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FuNH3TvottBd6Vom+HjZUn38bx12HjWSuxT5PFFp2NM=;
        b=dCXkD2BPBdAaa4GzpJ7NScR9q6evi6Bsxs6I0sexo4ucD9veKeqJuPGI5L/gWnfVe/
         GFgzuhOJUVfIEB6RBJe6BVaIgtxPT6a/O/NdZ4+G6HWIwrIL3sN+uBsC/JJv5KDnrXfP
         T4bEyzIqL2lm5SyuYNUrvr9x7qGRg6xKN9gTb4Ak4BBW7X/0wKH7WwXRRiVWTsVXsCld
         HlpTzbd8/cea0ED1nMYyXimEGqFs0VigXL6vC0owqYKTi8daCiXe9JKiZ90BpIk92zsn
         0/btdqEE9p0Nn8qBSIPd1rzVijtMSkxCJ2+pg3TeEWZWBWZmsgNTxm657MpdHJPygU5b
         JF7w==
X-Gm-Message-State: ANhLgQ2/PN+YrVuDW0BVtSX2LGQfF0qP6r++pOTKnSk0OGxE9JM8l7aP
	gVLiMQiG8xD2Rq/cBPPDOFGjrg==
X-Google-Smtp-Source: ADFU+vuKz5FLrd/n++22UcE/kf4ftn3gYQmH2FDL1/qqMttDY074nJOuzLStkZh5VaZoPZM9xVSjkg==
X-Received: by 2002:a17:90a:3783:: with SMTP id v3mr1135572pjb.31.1585243134014;
        Thu, 26 Mar 2020 10:18:54 -0700 (PDT)
Date: Thu, 26 Mar 2020 10:18:51 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	the arch/x86 maintainers <x86@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linux-MM <linux-mm@kvack.org>,
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Optionally randomize kernel stack offset each
 syscall
Message-ID: <202003260932.510967DD@keescook>
References: <20200324203231.64324-1-keescook@chromium.org>
 <CAG48ez3yYkMdxEEW6sJzBC5BZSbzEZKnpWzco32p-TJx7y_srg@mail.gmail.com>
 <202003241604.7269C810B@keescook>
 <BL0PR11MB3281D8D615FA521401B8E320E7CE0@BL0PR11MB3281.namprd11.prod.outlook.com>
 <202003251322.180F2536E@keescook>
 <CAG48ez1RfvayCpNVkVQrdNbb6tNv1Wc=337Q7kZu80PrbMOP_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1RfvayCpNVkVQrdNbb6tNv1Wc=337Q7kZu80PrbMOP_A@mail.gmail.com>

On Thu, Mar 26, 2020 at 12:20:19AM +0100, Jann Horn wrote:
> On Wed, Mar 25, 2020 at 9:27 PM Kees Cook <keescook@chromium.org> wrote:
> > On Wed, Mar 25, 2020 at 12:15:12PM +0000, Reshetova, Elena wrote:
> > > > > Also, are you sure that it isn't possible to make the syscall that
> > > > > leaked its stack pointer never return to userspace (via ptrace or
> > > > > SIGSTOP or something like that), and therefore never realign its
> > > > > stack, while keeping some controlled data present on the syscall's
> > > > > stack?
> > >
> > > How would you reliably detect that a stack pointer has been leaked
> > > to userspace while it has been in a syscall? Does not seem to be a trivial
> > > task to me.
> >
> > Well, my expectation is that folks using this defense are also using
> > panic_on_warn sysctl, etc, so attackers don't get a chance to actually
> > _use_ register values spilled to dmesg.
> 
> Uh... I thought that thing was exclusively for stuff like syzkaller,
> because nuking the entire system because of a WARN is far too
> excessive? WARNs should be safe to add almost anywhere in the kernel,
> so that developers can put their assumptions about system behavior
> into code without having to worry about bringing down the entire
> system if that assumption turns out to have been false in some
> harmless edgecase.

So, I'm caught in a tight spot between Linus's deprecation of BUG()[1],
and the desire for high-sensitivity security-oriented system builders
to have a "completely stop running that kernel thread" option. Linus's
entirely reasonable observation that BUG() destabilizes the kernel more
often than it doesn't means there isn't actually a safe "stop that kernel
thread" option, especially since many mitigations that detect badness span
a spectrum of "stops the badness before it happens" (e.g. NX memory) to
"I see badness has already happened" (e.g. stack protector). As a result,
the only way to provide a way for the security-prioritized users is to
downgrade corruptions to DoSes via panic(). I wish there was a magic
way to have a perfect kernel state unwinder to get us the BUG() we
wanted it to be, but given the kernel's complexity, it doesn't exist
(and is unlikely to be worth developing). Right now, we either get
"WARN() and keep going as best we can" or we get "WARN() and panic".

And with regard to "WARNs should be safe to add", yes, that's generally
true, but the goal is to not make them reachable from userspace because
of this need to be able to "upgrade" them to panic(). I have tried to
document[1] this:

  Note that the WARN()-family should only be used for "expected to
  be unreachable" situations. If you want to warn about "reachable
  but undesirable" situations, please use the pr_warn()-family of
  functions. System owners may have set the *panic_on_warn* sysctl,
  to make sure their systems do not continue running in the face of
  "unreachable" conditions. (For example, see commits like `this one
  <https://git.kernel.org/linus/d4689846881d160a4d12a514e991a740bcb5d65a>`_.)

[1] https://lore.kernel.org/lkml/202003141524.59C619B51A@keescook/

> Also, there are other places that dump register state. In particular
> the soft lockup detection, which you can IIRC easily trip even
> accidentally if you play around with stuff like FUSE filesystems, or
> if a disk becomes unresponsive. Sure, *theoretically* you can also set
> the "panic on soft lockup" flag, but that seems like a really terrible
> idea to me.

I understand your general objection to non-deterministic defenses,
as there will always be ways to weaken them, but I don't think that's
reason enough to not have them. I prefer to look at mitigations as a
spectrum, and to recognize that some are more effective with certain
system configurations. They become tools to choose from when building
defense in depth.

> As far as I can tell, the only clean way to fix this is to tell
> distros that give non-root users access to dmesg (Ubuntu in
> particular) that they have to stop doing that. E.g. Debian seems to
> get by just fine with root-restricted dmesg.

Totally agreed about that. Ubuntu may be hard to convince as one of
their design principles has been to make the first user able to use the
system completely with as little interruption as possible. (e.g. pop-up
confirmation dialogs are strongly discouraged, etc.)

So, for this series, I think the benefit-to-complexity value is high.
It's a simple solution even if it's not perfect (most things can't be
given the existing kernel design trade-offs).

-Kees

-- 
Kees Cook
