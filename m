Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <578601B3.3050903@de.ibm.com>
References: <cover.1468270393.git.luto@kernel.org> <578601B3.3050903@de.ibm.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 13 Jul 2016 11:36:28 -0700
Message-ID: <CALCETrUD0R08xkpTgBgey1zMVk4kKm9ZgdXC+KpHQHqCjw9_sg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v5 00/32] virtually mapped stacks and thread_info cleanup
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390 <linux-s390@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 13, 2016 at 1:54 AM, Christian Borntraeger
<borntraeger@de.ibm.com> wrote:
> On 07/11/2016 10:53 PM, Andy Lutomirski wrote:
>> Hi all-
>>
>> Since the dawn of time, a kernel stack overflow has been a real PITA
>> to debug, has caused nondeterministic crashes some time after the
>> actual overflow, and has generally been easy to exploit for root.
>>
>> With this series, arches can enable HAVE_ARCH_VMAP_STACK.  Arches
>> that enable it (just x86 for now) get virtually mapped stacks with
>> guard pages.  This causes reliable faults when the stack overflows.
>>
>> If the arch implements it well, we get a nice OOPS on stack overflow
>> (as opposed to panicing directly or otherwise exploding badly).  On
>> x86, the OOPS is nice, has a usable call trace, and the overflowing
>> task is killed cleanly.
>>
>> This series (starting with v4) also extensively cleans up
>> thread_info.  thread_info has been partially redundant with
>> thread_struct for a long time -- both are places for arch code to
>> add additional per-task variables.  thread_struct is much cleaner:
>> it's always in task_struct, and there's nothing particularly magical
>> about it.  So this series contains a bunch of cleanups on x86 to
>> move almost everything from thread_info to thread_struct (which,
>> even by itself, deletes more code than it adds) and to remove x86's
>> dependence on thread_info's position on the stack.  Then it opts x86
>> into a new config option THREAD_INFO_IN_TASK to get rid of
>> arch-specific thread_info entirely and simply embed a defanged
>> thread_info (containing only flags) and 'int cpu' into task_struct.
>>
>> Once thread_info stops being magical, there's another benefit: we
>> can free the thread stack as soon as the task is dead (without
>> waiting for RCU) and then, if vmapped stacks are in use, cache the
>> entire stack for reuse on the same cpu.
>>
>> This seems to be an overall speedup of about 0.5-1 =C2=B5s per
>> pthread_create/join in a simple test -- a percpu cache of vmalloced
>> stacks appears to be a bit faster than a high-order stack
>> allocation, at least when the cache hits.  (I expect that workloads
>> with a low cache hit rate are likely to be dominated by other
>> effects anyway.)
>>
>> This does not address interrupt stacks.
>>
>> It's worth noting that s390 has an arch-specific gcc feature that
>> detects stack overflows by adjusting function prologues.  Arches
>> with features like that may wish to avoid using vmapped stacks to
>> minimize the performance hit.
>
> Yes, might not need this for stack overflow detection. What might
> be interesting is the thread_info/thread_struct change, if we can
> strip down thread_info.(CONFIG_THREAD_INFO_IN_TASK). Would it actually
> make sense to separate these two changes to see what performance
> impact  CONFIG_THREAD_INFO_IN_TASK has on its own?
>

They're already separated.

CONFIG_THREAD_INFO_IN_TASK should have basically no performance impact
unless there are arch-dependent (percpu?) issues involved.  It does
enable immediate thread stack deallocation, though, and it would be
straightforward to make CONFIG_THREAD_INFO_IN_TASK cache stacks even
if CONFIG_VMAP_STACK=3Dn.  That should be a moderate clone() speedup.


--=20
Andy Lutomirski
AMA Capital Management, LLC
