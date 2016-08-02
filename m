Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160802203037.GC6879@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net> <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 2 Aug 2016 13:51:47 -0700
Message-ID: <CAGXu5jJ+b4mWQ+RwPLo26di1qUwKT344GoN6xwzA1fw5Ke=ydA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jeff Vander Stoep <jeffv@google.com>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 2, 2016 at 1:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Aug 02, 2016 at 12:04:34PM -0700, Kees Cook wrote:
>
>> Now, obviously, these API have huge value, otherwise they wouldn't
>> exist in the first place, and they wouldn't be built into end-user
>> kernels if they were universally undesirable. But that's not the
>> situation: the APIs are needed, but they lack the appropriate knobs to
>> control their availability.
>
> So far so good, but I take exception with the suggestion that the
> proposed knob is appropriate.
>
>> And this isn't just about Android: regular
>> distro kernels (like Debian, who also uses this patch) tend to build
>> in everything so people can use whatever they want. But for admins
>> that want to reduce their systems' attack surface, there needs to be
>> ways to disable things like this.
>
> And here I think you're overestimating the knowledge of most admins.

Well, I suspect that's why both Android and Debian default this to off
right now. :) But, regardless, I think it's weird to block admins who
DO understand about attack surface from being able to limit it.

>> > So the problem I have with this is that it will completely inhibit
>> > development of things like JITs that self-profile to re-compile
>> > frequently used code.
>>
>> This is a good example of a use-case where this knob would be turned
>> down. But for many many other use-cases, when presented with a
>> pre-built kernel, there isn't a way to remove the attack surface.
>
> No, quite the opposite. Having this knob will completely inhibit
> development of such applications. Worse it will probably render perf
> dead for quite a large body of developers.

I hear what you're saying, but I think there's a few problems: the
proposed self-profiling JIT doesn't exist (so it's pointless to
discuss), and the number of developers that don't have access to their
own system is impossibly tiny when compared to the hundreds of
millions of end-users for whom perf is not needed.

> The moment you frame it like: perf or sekjurity, and even default to
> no-perf-because-sekjurity, a whole bunch of corporate IT departments
> will not enable this, even for their developers.

It's not "vs security", it's a risk analysis of attack surface. The
vast majority of people running Linux do not use perf (right now).
I've never suggested it be default disabled: I'm wanting to upstream
the sysctl setting that is already in use on distros where the distro
kernel teams have deemed this is needed knob for their end-users. All
of the objections you're talking about assume that the knob doesn't
exist, but it does already. It's just not in upstream. :)

> Have you never had to 'root' your work machine to get work done? I have.
> Luckily this was pre-secure-boot times so it was trivial since I had
> physical access to the machine. But it still sucked I had to fight IT
> over mostly 'trivial' crap.

Yeah, I've had to do similar. Frankly most people use VMs or non-corp
hardware for doing development work, so I don't think this is a useful
comparison.

>
>> > I would much rather have an LSM hook where the security stuff can do
>> > more fine grained control of things. Allowing some apps perf usage while
>> > denying others.
>>
>> I'm not against an LSM, but I think it's needless complexity when
>> there is already a knob for this but it just doesn't go "high" enough.
>> :)
>
> So what will you to the moment the Google Dalvik guys come to you and
> say: "Hey, we want to do active profiling to do better on-line code
> generation?".

That hasn't happened yet. When it does, we can revisit this. But right
now, today, there is a need for this knob.

> I see 0 up-sides of this approach and, as per the above, a whole bunch
> of very serious downsides.
>
> A global (esp. default inhibited) knob is too coarse and limiting.

I haven't suggested it be default inhibit in the upstream Kconfig. And
having this knob already with the 0, 1, and 2 settings seems
incomplete to me without this highest level of restriction that 3
would provide. That seems rather arbitrary to me. :)

Let me take this another way instead. What would be a better way to
provide a mechanism for system owners to disable perf without an LSM?
(Since far fewer folks run with an enforcing "big" LSM: I'm seeking as
wide a coverage as possible.)

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
