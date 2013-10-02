Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <524BAF92.1090705@zytor.com>
References: <1380656245-29975-1-git-send-email-keescook@chromium.org>
	<20131002050714.GA27982@gmail.com>
	<fcdac020-6b9a-4d36-b424-290597669cb0@email.android.com>
	<20131002052531.GA31122@gmail.com>
	<524BAF92.1090705@zytor.com>
Date: Tue, 1 Oct 2013 22:36:31 -0700
Message-ID: <CAGXu5j+5wR1MDQ_KOLhQCDgAaM=nRC=aiD66Ji7wJqGf9nHVaQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v6 0/7] Kernel base address randomization
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Aaron Durbin <adurbin@google.com>, Eric Northup <digitaleric@google.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@google.com>, Mathias Krause <minipli@googlemail.com>, Zhang Yanfei <zhangyanfei@cn.fujitsu.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Arnaldo Carvalho de Melo <acme@infradead.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Thomas Gleixner <tglx@linutronix.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 1, 2013 at 10:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/01/2013 10:25 PM, Ingo Molnar wrote:
>>
>> I mean, for example in an oops message we print data in words: the RIP,
>> other registers and stack contents. If any of these values lies within the
>> randomization range then we could de-randomize it.
>>
>> So instead of exposing randomized values, we could expose de-randomized
>> values.
>>
>> ( This isn't fool-proof: if some data value happens to lie within the
>>   random range spuriously then we'll incorrectly transform it. In the
>>   context of oops messages this should not be a big practical problem
>>   though. )
>>
>
> I don't agree that this isn't a big practical problem.  I often find it
> necessary to pick out "things that look like pointers".  Overall,
> derandomization would make it possible to get really confused when you
> have things like half a pointer overwritten.

I think reflecting the reality of the system is the correct way to go.
Attempting to do the derandomization on the live system seems
extremely fragile. It's much cleaner to have a "true" view of the
running system and work from there. I don't want to have to wonder if
my kernel is lying to me about where things are in memory any more
than it already does. :)

-Kees

-- 
Kees Cook
Chrome OS Security
