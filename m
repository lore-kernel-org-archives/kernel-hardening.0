Date: Tue, 27 Mar 2018 18:34:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] task_struct: Only use anon struct under randstruct
 plugin
Message-Id: <20180327183419.8610a85f4ef90c68e157c5a9@linux-foundation.org>
In-Reply-To: <CAGXu5j+an4OwLMCqGMqCN=dh1GH-_PQTDGFL_WhpbOSNXgYynA@mail.gmail.com>
References: <20180327213609.GA2964@beast>
	<20180327160342.e2bc9a15afda5823c8daf4fb@linux-foundation.org>
	<CAGXu5j+an4OwLMCqGMqCN=dh1GH-_PQTDGFL_WhpbOSNXgYynA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 27 Mar 2018 17:30:47 -0700 Kees Cook <keescook@chromium.org> wrote:

> On Tue, Mar 27, 2018 at 4:03 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Tue, 27 Mar 2018 14:36:09 -0700 Kees Cook <keescook@chromium.org> wrote:
> >> Reported-by: Peter Zijlstra <peterz@infradead.org>
> >> Fixes: 29e48ce87f1e ("task_struct: Allow randomized")
> >> Cc: stable@vger.kernel.org
> >
> > Why cc:stable?
> 
> Since the padding existed in all configs, it's kind of an ugly wart
> and should likely be fixed up for 4.14 and 4.15 -stable.

That didn't tell us much :(
Documentation/process/stable-kernel-rules.rst doesn't mention "ugly
wart".

I think what you're hearing here is that this patch needs a better
changelog, please.  Not an uncommon failing, sigh.  A better
explanation of the origins of this padding and a better explanation of
the reasons for backporting the fix.
