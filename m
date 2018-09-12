Message-ID: <1536773686.3240.9.camel@linux.intel.com>
Subject: Re: [RFC PATCH] x86: entry: flush the cache if syscall error
From: Kristen C Accardi <kristen@linux.intel.com>
Date: Wed, 12 Sep 2018 10:34:46 -0700
In-Reply-To: <CAG48ez1=_mtYTXvE=eeA6FkEjeZQsnqRJAtzZ75nyeoZuEtmnQ@mail.gmail.com>
References: <20180910191002.350195-1-kristen@linux.intel.com>
	 <CAG48ez1=_mtYTXvE=eeA6FkEjeZQsnqRJAtzZ75nyeoZuEtmnQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Jann Horn <jannh@google.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2018-09-11 at 20:02 +0200, Jann Horn wrote:
> On Mon, Sep 10, 2018 at 9:14 PM Kristen Carlson Accardi
> <kristen@linux.intel.com> wrote:
> > This patch aims to make it harder to perform cache timing attacks
> > on data
> > left behind by system calls. If we have an error returned from a
> > syscall,
> > flush the L1 cache.
> 
> How much protection does this provide, given that it e.g. doesn't
> flush L2/L3 and doesn't prevent data leakage through hyperthreading
> and cache coherency? Is an L2/L3-based attack expected to be harder
> than an L1D-based one?

My reasoning here is that L2/L3 caches can be partitioned using
something like CAT (maybe), but L1 cannot. So IMO L1 is the case that
needs coverage. Also, while this doesn't address a specific exploit,
the idea is that attacks on data in L1D are more common, and the
performance penalty for L2/L3 flushes would be too high without a
specific exploit in mind.
 
