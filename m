MIME-Version: 1.0
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
 <20190208142642.GJ32511@hirez.programming.kicks-ass.net> <2236FBA76BA1254E88B949DDB74E612BA4BB96C5@IRSMSX102.ger.corp.intel.com>
 <CALCETrXA8PBtu6B5z5gjJV4X_pe16f4DE7T5o5AspgMckBRWKA@mail.gmail.com>
 <2236FBA76BA1254E88B949DDB74E612BA4BBA73C@IRSMSX102.ger.corp.intel.com>
 <EBF96DB2-B25D-437B-A067-F187E031BC3E@amacapital.net> <5E269FBC3009974381A340959F3135C95C8F78E5@hasmsx108.ger.corp.intel.com>
 <CAGXu5jJSWf=CAij3_dxA9+n6+fWtt1MOT3dWD07vdkhrfC8bpQ@mail.gmail.com> <5E269FBC3009974381A340959F3135C95C8FE7E1@hasmsx108.ger.corp.intel.com>
In-Reply-To: <5E269FBC3009974381A340959F3135C95C8FE7E1@hasmsx108.ger.corp.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Feb 2019 09:23:43 -0800
Message-ID: <CAGXu5jJoODVOd8Bt+eMRPGvm=ZZNBHVmGE8LBsgMk6K=1Dv-cQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Content-Type: text/plain; charset="UTF-8"
To: "Perla, Enrico" <enrico.perla@intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, "Reshetova, Elena" <elena.reshetova@intel.com>, Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 1:35 AM Perla, Enrico <enrico.perla@intel.com> wrote:
> > It does seem that using a flaw to attack one's own registers is rather
> > pointless. Maybe we'll eat our words, but for now, I'd agree.
> >
>
> You don't attack your own registers, you use them to load controlled data to the kernel and emulate structures or similar at any stage of an exploit, bypassing SMAP and co.

Given all the rewriting of the syscall entry code over the last few
years, perhaps I'm missing something. My understanding was that at
syscall entry we do effectively this:

- save pt_regs
- clear all registers not needed for a syscall
- run syscall
- restore pt_regs (excepting syscall return value)

I didn't think pt_regs got used during the syscall? In looking more
closely, I see some current_pt_regs() in some paths, but again: what's
the attack you're thinking of that isn't directly overlapped with
existing control over registers at entry or via ptrace?

-- 
Kees Cook
