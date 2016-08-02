Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160802203037.GC6879@twins.programming.kicks-ass.net>
References: <1469630746-32279-1-git-send-email-jeffv@google.com>
 <20160802095243.GD6862@twins.programming.kicks-ass.net> <CAGXu5j+q4qWFspRCPEd5-MM05Sh_r6VYSQhP7gcAuRMygeZwjg@mail.gmail.com>
 <20160802203037.GC6879@twins.programming.kicks-ass.net>
From: Jeffrey Vander Stoep <jeffv@google.com>
Date: Tue, 2 Aug 2016 14:16:42 -0700
Message-ID: <CABXk95Ao-+rb9hXqCGxFyyCBoH7VraBFUJUSX0Hjv4XWYYk1Jg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 1/2] security, perf: allow further
 restriction of perf_event_open
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <kernel-hardening.lists.openwall.com>

Far from trying to kill perf, we want (and require) perf to be
available to developers on Android. All that this patch enables us to
do is gate it behind developer settings - just like we do with other
developer targeted features.

(apologies for the dup, bounced due to non-plaintext)

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
>
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
>
> The moment you frame it like: perf or sekjurity, and even default to
> no-perf-because-sekjurity, a whole bunch of corporate IT departments
> will not enable this, even for their developers.
>
> Have you never had to 'root' your work machine to get work done? I have.
> Luckily this was pre-secure-boot times so it was trivial since I had
> physical access to the machine. But it still sucked I had to fight IT
> over mostly 'trivial' crap.
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
>
> I see 0 up-sides of this approach and, as per the above, a whole bunch
> of very serious downsides.
>
> A global (esp. default inhibited) knob is too coarse and limiting.
>
>
