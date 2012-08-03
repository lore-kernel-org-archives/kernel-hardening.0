Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120803110247.GB11952@moon>
References: <alpine.LFD.2.02.1203231926000.2542@ionos>
	<20120323190855.GA27213@www.outflux.net>
	<CAFLxGvzPVPyXPwjay4a01q1vx4K4Ht56bHjzswYrr1wvB_1dYw@mail.gmail.com>
	<87pq7935w2.fsf@xmission.com>
	<CAFLxGvz0reQS=zfWeTz4a4xZVFeeu80VnP-efy7zCiPZVWzH-g@mail.gmail.com>
	<20120803110247.GB11952@moon>
Date: Fri, 3 Aug 2012 13:19:24 +0200
Message-ID: <CAFLxGvw4j-pyinjywxaL2gQ-Akp9grDysNv7dfOJkaQ3EyDKLw@mail.gmail.com>
From: richard -rw- weinberger <richard.weinberger@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2] futex: mark get_robust_list as deprecated
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Darren Hart <dvhart@linux.intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>, "Serge E. Hallyn" <serge.hallyn@canonical.com>, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Aug 3, 2012 at 1:02 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
>> >> I'm using this system call in an application and noticed that's marked
>> >> as deprecated now.
>> >> My application collects all kind of information from crashing programs.
>> >> It's installed in /proc/sys/kernel/core_pattern.
>> >>
>> >> If program X is crashing it executes get_robust_list(X) to get the
>> >> address of the robust list
>> >> and reads the list from /proc/X/mem.
>> >>
>> >> Is there another way to get the robust list from another program (by it's pid)?
>> >
>> > The folks doing checkpoint/restart claim to not need this, so there
>> > might be a way either that or they just haven't hit this problem yet.
>> >
>> > What you are doing sounds like a reasonable use of get_robust_list to me.
>> >
>>
>> CRIU folks, how do you deal with futex robust lists?
>
> Well, I believe we were over-optimistic in claiming that we don't need this
> syscall (to be fair I think we simply yet not faced the problem Eric points).
> So we need some way to fetch this address and set it back. If get_robust_list
> get deprecated maybe we could print it out in /proc/pid/stat or something?

Kees, you said get_robust_list() can be used to bypass ASLR.
How? What makes it worse than /proc/pid/maps?

If the robust list address itself is bad, removing get_robust_list()
and putting the
information into /proc is useless.

-- 
Thanks,
//richard
