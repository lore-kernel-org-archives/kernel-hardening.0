MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180327160342.e2bc9a15afda5823c8daf4fb@linux-foundation.org>
References: <20180327213609.GA2964@beast> <20180327160342.e2bc9a15afda5823c8daf4fb@linux-foundation.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Mar 2018 17:30:47 -0700
Message-ID: <CAGXu5j+an4OwLMCqGMqCN=dh1GH-_PQTDGFL_WhpbOSNXgYynA@mail.gmail.com>
Subject: Re: [PATCH] task_struct: Only use anon struct under randstruct plugin
Content-Type: text/plain; charset="UTF-8"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 27, 2018 at 4:03 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 27 Mar 2018 14:36:09 -0700 Kees Cook <keescook@chromium.org> wrote:
>> Reported-by: Peter Zijlstra <peterz@infradead.org>
>> Fixes: 29e48ce87f1e ("task_struct: Allow randomized")
>> Cc: stable@vger.kernel.org
>
> Why cc:stable?

Since the padding existed in all configs, it's kind of an ugly wart
and should likely be fixed up for 4.14 and 4.15 -stable.

> So the mysterious 40 byte bloat is still present in this case?

Given how insane[1] task_struct can end up under randstruct, these 40
bytes aren't too bad. I've added fixing this to the randstruct to-do
list, but I don't view it as high priority.

-Kees
[1] https://git.kernel.org/linus/ffa47aa678cfaa9b88e8a26cfb115b4768325121

-- 
Kees Cook
Pixel Security
