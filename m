Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <alpine.LFD.2.02.1203230043470.2542@ionos>
References: <20120319231253.GA20893@www.outflux.net>
	<20120320133141.GC2918@peqn>
	<alpine.LFD.2.02.1203201758220.2542@ionos>
	<CAGXu5jKVx41+NSEWsw0YF74z5_heSQ6GOmkuDi1DXNPcO4sjTQ@mail.gmail.com>
	<20120320172300.GA8888@gmail.com>
	<alpine.LFD.2.02.1203230043470.2542@ionos>
Date: Wed, 28 Mar 2012 11:33:15 -0700
Message-ID: <CAGXu5jKRGmfhS48gpuur7P1cbnoBPdnNe3qPbok52TKQD8Sy9w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH] futex: do not leak robust list to unprivileged process
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, LKML <linux-kernel@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>, David Howells <dhowells@redhat.com>, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 22, 2012 at 4:46 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Tue, 20 Mar 2012, Ingo Molnar wrote:
>> * Kees Cook <keescook@chromium.org> wrote:
>> > On Tue, Mar 20, 2012 at 10:02 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> > > I really wonder why we have this syscall at all.
>> >
>> > The documentation I found yesterday while looking at this was:
>> > http://linux.die.net/man/2/get_robust_list
>> >
>> > Which says "The system call is only available for debugging
>> > purposes and is not needed for normal operations. Both system
>> > calls are not available to application programs as functions;
>> > they can be called using the syscall(3) function."
>> >
>> > Dropping the syscall entirely would certainly make it secure.
>> > ;)
>>
>> The thinking was API completeness. In general it's possible for
>> a sufficiently privileged task to figure out all the state of a
>> task. We can query timers, fds - the robust list is such a
>> resource as well. The information leakage was obviously not
>> intended.
>
> So I think it's safe to take Kees' patch as is. On top of that we
> should add a WARN_ONCE when the syscall is invoked and schedule the
> sucker for removal.

Can someone claim the first patch? It looks like not everyone agrees
about removal, but I'd like to see at least the first one get in. :)

-Kees

-- 
Kees Cook
ChromeOS Security
