Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160802095243.GD6862@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com> <20160802095243.GD6862@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 2 Aug 2016 12:04:34 -0700
Message-ID: <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2016 at 2:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jul 27, 2016 at 07:45:46AM -0700, Jeff Vander Stoep wrote:
>> When kernel.perf_event_paranoid is set to 3 (or greater), disallow
>> all access to performance events by users without CAP_SYS_ADMIN.
>>
>> This new level of restriction is intended to reduce the attack
>> surface of the kernel. Perf is a valuable tool for developers but
>> is generally unnecessary and unused on production systems. Perf may
>> open up an attack vector to vulnerable device-specific drivers as
>> recently demonstrated in CVE-2016-0805, CVE-2016-0819,
>> CVE-2016-0843, CVE-2016-3768, and CVE-2016-3843.
>
> We have bugs we fix them, we don't kill complete infrastructure because
> of them.

I understand that point of view, but it isn't what things look like
for the average end-user of Linux. The lifetime on bugs is very long,
even in upstream (see both Jon Corbet and my talks about this: an
average of 5 years from introduction to fix), and gets drawn out even
further by vendors with slow (or missing) update processes. Being able
to remove attack surface is a fundamental first step of security
defense, and things like perf, user namespaces, and similar APIs,
expose a lot of attack surface when they are enabled. And the evidence
for this attack surface being a real-world risk is in the history of
security vulnerabilities (that we know about!) in these various APIs.

Now, obviously, these API have huge value, otherwise they wouldn't
exist in the first place, and they wouldn't be built into end-user
kernels if they were universally undesirable. But that's not the
situation: the APIs are needed, but they lack the appropriate knobs to
control their availability. And this isn't just about Android: regular
distro kernels (like Debian, who also uses this patch) tend to build
in everything so people can use whatever they want. But for admins
that want to reduce their systems' attack surface, there needs to be
ways to disable things like this.

>> This new level of
>> restriction allows for a safe default to be set on production systems
>> while leaving a simple means for developers to grant access [1].
>
> So the problem I have with this is that it will completely inhibit
> development of things like JITs that self-profile to re-compile
> frequently used code.

This is a good example of a use-case where this knob would be turned
down. But for many many other use-cases, when presented with a
pre-built kernel, there isn't a way to remove the attack surface.

> I would much rather have an LSM hook where the security stuff can do
> more fine grained control of things. Allowing some apps perf usage while
> denying others.

I'm not against an LSM, but I think it's needless complexity when
there is already a knob for this but it just doesn't go "high" enough.
:)

-Kees

-- 
Kees Cook
Brillo & Chrome OS Security
