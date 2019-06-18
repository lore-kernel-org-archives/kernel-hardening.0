Date: Tue, 18 Jun 2019 00:23:11 -0700
From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 1/3] lkdtm: Check for SMEP clearing protections
Message-ID: <201906180019.EEA60F3@keescook>
References: <20190618045503.39105-1-keescook@chromium.org>
 <20190618045503.39105-2-keescook@chromium.org>
 <580611da-fd97-e82e-b604-581f105416ee@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <580611da-fd97-e82e-b604-581f105416ee@rasmusvillemoes.dk>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 18, 2019 at 09:10:13AM +0200, Rasmus Villemoes wrote:
> On 18/06/2019 06.55, Kees Cook wrote:
> 
> > +#else
> > +	pr_err("FAIL: this test is x86_64-only\n");
> > +#endif
> > +}
> 
> Why expose it at all on all other architectures? If you wrap the
> CRASHTYPE() in an #ifdef, you can also guard the whole lkdtm_UNSET_SMEP
> definition (the declaration in lkdtm.h can stay, possibly with a comment
> saying /* x86-64 only */).

My preference for LKDTM is for all the tests to be visible regardless
of architecture so that the testing "environment" doesn't have to change
depending on architecture. I've found it easier to deal with when I ran
test harnesses on Chrome OS where I had cross-architectural scripts.
Doing a side-by-side with a PASS and an XFAIL was more sensible to
compare than a PASS and a missing test.

-- 
Kees Cook
