Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20120524150057.86c14b35.akpm@linux-foundation.org>
References: <20120522173942.GJ11775@ZenIV.linux.org.uk>
	<1337875681-20717-1-git-send-email-wad@chromium.org>
	<20120524150057.86c14b35.akpm@linux-foundation.org>
Date: Thu, 24 May 2012 20:55:09 -0500
Message-ID: <CABqD9hY5-vwsr4gWQJ=GgjdDrFxn8_MCvYXCDk5pyRgLuaPwTA@mail.gmail.com>
From: Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [RFC PATCH 0/3] move the secure_computing call
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mcgrathr@google.com, hpa@zytor.com, indan@nul.nu, netdev@parisplace.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, rdunlap@xenotime.net, tglx@linutronix.de, luto@mit.edu, serge.hallyn@canonical.com, pmoore@redhat.com, corbet@lwn.net, markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org, viro@zeniv.linux.org.uk, jmorris@namei.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 24, 2012 at 5:00 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 24 May 2012 11:07:58 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> This is an RFC based on the comments from Al Viro and Eric Paris
>> regarding ptrace()rs being able to change the system call the kernel
>> sees after the seccomp enforcement has occurred (for mode 1 or 2).
>
> Perhaps you could repeat those comments in this changelog.

Oops :)  Here's the context -- https://lkml.org/lkml/2012/5/21/326

I doubt there's need for a repost though.

>> With this series applied, a (p)tracer of a process with seccomp enabled
>> will be unable to change the tracee's system call number after the
>> secure computing check has been performed.
>>
>> The x86 change is tested, as is the seccomp.c change. =A0For other arche=
s,
>> it is not (RFC :). =A0Given that there are other inconsistencies in this
>> code across architectures, I'm not sure if it makes sense to attempt to
>> fix them all at once or to roll through as I attempt to add seccomp
>> filter support.
>>
>> As is, the biggest benefit of this change is just setting consistent
>> expectations in what the ptrace/seccomp interactions should be. =A0The
>> current ability for ptrace to "bypass" secure computing (by remapping
>> allowed system calls) is not necessarily a problem, but it is not
>> necessarily intuitive behavior.
>>
>
> Because my take on the above reasoning is "why did you bother writing
> these patches"!

Just to be thorough -- I wanted to make sure the discussion was framed
against actual code just in case I was missing something.  Otherwise,
I'd be happy to see these patches disappear into the annals of the
wayback machine.

thanks!
