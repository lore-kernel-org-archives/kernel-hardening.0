Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <4F065704.4020306@redhat.com>
Date: Thu, 05 Jan 2012 21:05:56 -0500
From: Rik van Riel <riel@redhat.com>
MIME-Version: 1.0
References: <20120104201800.GA2587@www.outflux.net> <20120105143008.GA31728@elliptictech.com> <CAGXu5jLYhxOK8u-H8mhTvHBzvkRi8d-=zTeginjukDMEFri-0Q@mail.gmail.com> <20120105200810.GA3826@elliptictech.com> <CAGXu5jKe_qpQ9yG4f0J_94WNKYy_qdDNdVW4v74ZivwO4Xy0Rg@mail.gmail.com>
In-Reply-To: <CAGXu5jKe_qpQ9yG4f0J_94WNKYy_qdDNdVW4v74ZivwO4Xy0Rg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2012.1] fs: symlink restrictions on sticky directories
To: Kees Cook <keescook@chromium.org>
Cc: Nick Bowler <nbowler@elliptictech.com>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Federica Teodori <federica.teodori@googlemail.com>, Lucian Adrian Grijincu <lucian.grijincu@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Eric Paris <eparis@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>, Dan Rosenberg <drosenberg@vsecurity.com>, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 01/05/2012 03:55 PM, Kees Cook wrote:
> On Thu, Jan 5, 2012 at 12:08 PM, Nick Bowler<nbowler@elliptictech.com>  wrote:

>> But this is a brand new feature that changes longstanding behaviour of
>> various syscalls.  Making it default to enabled is rather mean to users
>> (since it will tend to get enabled by "oldconfig") and seems almost
>> guaranteed to cause regressions.
>
> I couldn't disagree more. There has been zero evidence of this change
> causing anything but regressions in _attacks_. :P If anything, I think
> there should be no CONFIG and no sysctl, and it should be entirely
> non-optional. But since this patch needs consensus, I have provided
> knobs to control it.

I agree with you, Kees.

The behaviour introduced by this patch should produce so
few issues, that the new behaviour should probably be on
by default.

The few people impacted can use a sysctl knob to disable
the check on their systems. I am not sure anyone will
actually be using that knob...

The config option is probably not needed. The new
behaviour is something that could just be on by default
for everyone, and disabled by the few (if any) people
who have some setup that breaks with it.

-- 
All rights reversed
