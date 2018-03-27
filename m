Date: Tue, 27 Mar 2018 16:03:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] task_struct: Only use anon struct under randstruct
 plugin
Message-Id: <20180327160342.e2bc9a15afda5823c8daf4fb@linux-foundation.org>
In-Reply-To: <20180327213609.GA2964@beast>
References: <20180327213609.GA2964@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 27 Mar 2018 14:36:09 -0700 Kees Cook <keescook@chromium.org> wrote:

> The original intent for always adding the anonymous struct in task_struct
> was to make sure we had compiler coverage. However, this caused
> pathological padding of 40 bytes at the start of task_struct.

Why?  What caused this padding?  It happens in all configs?

> Instead,
> move the anonymous struct to being only used when struct layout
> randomization is enabled.

So the mysterious 40 byte bloat is still present in this case?

> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Fixes: 29e48ce87f1e ("task_struct: Allow randomized")
> Cc: stable@vger.kernel.org

Why cc:stable?
