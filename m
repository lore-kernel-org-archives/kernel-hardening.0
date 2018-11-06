Date: Tue, 6 Nov 2018 13:04:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v8 0/4] KASLR feature to randomize each loadable module
Message-Id: <20181106130459.7a2669604a2c274edbe25971@linux-foundation.org>
In-Reply-To: <20181102192520.4522-1-rick.p.edgecombe@intel.com>
References: <20181102192520.4522-1-rick.p.edgecombe@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: jeyu@kernel.org, willy@infradead.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, daniel@iogearbox.net, jannh@google.com, keescook@chromium.org, kristen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri,  2 Nov 2018 12:25:16 -0700 Rick Edgecombe <rick.p.edgecombe@intel.com> wrote:

> This is V8 of the "KASLR feature to randomize each loadable module" patchset.
> The purpose is to increase the randomization and also to make the modules
> randomized in relation to each other instead of just the base, so that if one
> module leaks the location of the others can't be inferred.

I'm not seeing any info here which explains why we should add this to
Linux.

What is the end-user value?  What problems does it solve?  Are those
problems real or theoretical?  What are the exploit scenarios and how
realistic are they?  etcetera, etcetera.  How are we to decide to buy
this thing if we aren't given a glossy brochure?

> There is a small allocation performance degradation versus v7 as a
> trade off, but it is still faster on average than the existing
> algorithm until >7000 modules.

lol.  How did you test 7000 modules?  Using the selftest code?
