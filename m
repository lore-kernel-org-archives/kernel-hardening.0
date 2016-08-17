Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160817201736.GB361@codeaurora.org>
References: <1471393229-27182-1-git-send-email-keescook@chromium.org> <20160817201736.GB361@codeaurora.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 17 Aug 2016 14:11:28 -0700
Message-ID: <CAGXu5jKEkn5Z2L1UjweSeAxA9RuYL0cdNrRo1J1KCQxD3WG5ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 0/5] bug: Provide toggle for BUG on data corruption
To: Stephen Boyd <sboyd@codeaurora.org>, Syed Rameez Mustafa <rameezmustafa@codeaurora.org>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Laura Abbott <labbott@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Daniel Micay <danielmicay@gmail.com>, Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Michael Ellerman <mpe@ellerman.id.au>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Josef Bacik <jbacik@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Tejun Heo <tj@kernel.org>, Nikolay Aleksandrov <nikolay@cumulusnetworks.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 17, 2016 at 1:17 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 08/16, Kees Cook wrote:
>> This adds a CONFIG to trigger BUG()s when the kernel encounters
>> unexpected data structure integrity as currently detected with
>> CONFIG_DEBUG_LIST.
>>
>> Specifically list operations have been a target for widening flaws to gain
>> "write anywhere" primitives for attackers, so this also consolidates the
>> debug checking to avoid code and check duplication (e.g. RCU list debug
>> was missing a check that got added to regular list debug). It also stops
>> manipulations when corruption is detected, since worsening the corruption
>> makes no sense. (Really, everyone should build with CONFIG_DEBUG_LIST
>> since the checks are so inexpensive.)
>>
>> This is mostly a refactoring of similar code from PaX and Grsecurity,
>> along with MSM kernel changes by Stephen Boyd.
>
> Which commit in the MSM kernel from me? I wonder if perhaps
> you're thinking of a patch from Syed Rameez Mustafa like commit
> 1c014f321e6d67f47 in the msm-3.4 kernel.

Ooof. I can't read. Yes, you were the committer, not the author! Whoops!

https://android.googlesource.com/kernel/msm/+/7b49b86d3aa3d0c6400454a346bad1bbdf0cc78f%5E%21/#F0

I will adjust the changelog. Thanks!

-Kees

-- 
Kees Cook
Nexus Security
