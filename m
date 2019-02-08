Date: Fri, 8 Feb 2019 16:15:02 +0100
From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH] x86/entry/64: randomize kernel stack offset upon
 system call
Message-ID: <20190208151502.GC32494@hirez.programming.kicks-ass.net>
References: <1549628149-11881-1-git-send-email-elena.reshetova@intel.com>
 <1549628149-11881-2-git-send-email-elena.reshetova@intel.com>
 <20190208130544.GI32511@hirez.programming.kicks-ass.net>
 <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612BA4BB7580@IRSMSX102.ger.corp.intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "luto@kernel.org" <luto@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "keescook@chromium.org" <keescook@chromium.org>, "tytso@mit.edu" <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 08, 2019 at 01:20:09PM +0000, Reshetova, Elena wrote:
> > On Fri, Feb 08, 2019 at 02:15:49PM +0200, Elena Reshetova wrote:

> I can measure the impact with rdtsc(), I think it is *very* small. 
> Btw, what should be the good measurement test?
> I am not that happy with just looping on fopen-fclose, too
> much noise. 

IIRC amluto had a nice micro-bench for 'pure' syscall overhead
somewhere.

Something like getpid/gettid in a loop should work fairly well, that's a
really light syscall to make.
