Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: jwboyer@gmail.com
In-Reply-To: <20160126172014.GB13715@ubuntumail>
References: <CALCETrWYRvqhyCwx5RX6L3TEYCfW0j6ThFUc+ASL7BpxgO5dEQ@mail.gmail.com>
	<CAGXu5j+mx+6BOKb42yfyKnL7VTCUBNC0Nk9aCOd0D5tSD6DbCg@mail.gmail.com>
	<CALCETrXNZhJdjbxYH8x3wr3EyQVJzp2fhNyXwzgmuiKzoKO24A@mail.gmail.com>
	<CAGXu5jJ6fQ5E17jKoC3kFZ0RgbcNLuzW6zdunaXV+jiQPSo+Lg@mail.gmail.com>
	<87bn89sbc2.fsf@x220.int.ebiederm.org>
	<CAGXu5jLwwCw9wZA8QYNVrZ2+kHJn7G3sXQZchvqFMYj3bN=DpQ@mail.gmail.com>
	<87zivtj5tv.fsf@x220.int.ebiederm.org>
	<CA+5PVA5Q0_sv5MsETa9u79MLOcYbsf-vdeEe3gdxgJ8f1KAbdQ@mail.gmail.com>
	<56A786DA.90204@gmail.com>
	<CA+5PVA5pUu_jr70ntvBhzSdXo52ypUueofdnoRdRh+ehCR9j4g@mail.gmail.com>
	<20160126172014.GB13715@ubuntumail>
Date: Tue, 26 Jan 2016 14:56:09 -0500
Message-ID: <CA+5PVA6gX=u0gn_9=4+-2Y12_aWX2VsZfzu8FEw+Wv3e+Cv9gQ@mail.gmail.com>
From: Josh Boyer <jwboyer@fedoraproject.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: [PATCH 0/2] sysctl: allow CLONE_NEWUSER to
 be disabled
To: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: kernel-hardening@lists.openwall.com, "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Richard Weinberger <richard@nod.at>, =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>, Dmitry Vyukov <dvyukov@google.com>, David Howells <dhowells@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>, Kostya Serebryany <kcc@google.com>, Alexander Potapenko <glider@google.com>, Eric Dumazet <edumazet@google.com>, Sasha Levin <sasha.levin@oracle.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 26, 2016 at 12:20 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
> Quoting Josh Boyer (jwboyer@fedoraproject.org):
>> On Tue, Jan 26, 2016 at 9:46 AM, Austin S. Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>> > On 2016-01-26 09:38, Josh Boyer wrote:
>> >>
>> >> On Mon, Jan 25, 2016 at 11:57 PM, Eric W. Biederman
>> >> <ebiederm@xmission.com> wrote:
>> >>>
>> >>> Kees Cook <keescook@chromium.org> writes:
>> >>>
>> >>>> On Mon, Jan 25, 2016 at 11:33 AM, Eric W. Biederman
>> >>>> <ebiederm@xmission.com> wrote:
>> >>>>>
>> >>>>> Kees Cook <keescook@chromium.org> writes:
>> >>>>>>
>> >>>>>>
>> >>>>>> Well, I don't know about less weird, but it would leave a unneeded
>> >>>>>> hole in the permission checks.
>> >>>>>
>> >>>>>
>> >>>>> To be clear the current patch has my:
>> >>>>>
>> >>>>> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> >>>>>
>> >>>>> The code is buggy, and poorly thought through.  Your lack of interest
>> >>>>> in
>> >>>>> fixing the bugs in your patch is distressing.
>> >>>>
>> >>>>
>> >>>> I'm not sure where you see me having a "lack of interest". The
>> >>>> existing cap-checking sysctls have a corner-case bug, which is
>> >>>> orthogonal to this change.
>> >>>
>> >>>
>> >>> That certainly doesn't sound like you have any plans to change anything
>> >>> there.
>> >>>
>> >>>>> So broken code, not willing to fix.  No. We are not merging this
>> >>>>> sysctl.
>> >>>>
>> >>>>
>> >>>> I think you're jumping to conclusions. :)
>> >>>
>> >>>
>> >>> I think I am the maintainer.
>> >>>
>> >>> What you are proposing is very much something that is only of interst to
>> >>> people who are not using user namespaces.  It is fatally flawed as
>> >>> a way to avoid new attack surfaces for people who don't care as the
>> >>> sysctl leaves user namespaces enabled by default.  It is fatally flawed
>> >>> as remediation to recommend to people to change if a new user namespace
>> >>> related but is discovered.  Any running process that happens to be
>> >>> created while user namespace creation was enabled will continue to
>> >>> exist.  Effectively a reboot will be required as part of a mitigation.
>> >>> Many sysadmins will get that wrong.
>> >>>
>> >>> I can't possibly see your sysctl as proposed achieving it's goals.  A
>> >>> person has to be entirely too aware of subtlety and nuance to use it
>> >>> effectively.
>> >>
>> >>
>> >> What you're saying is true for the "oh crap" case of a new userns
>> >> related CVE being found.  However, there is the case where sysadmins
>> >> know for a fact that a set of machines should not allow user
>> >> namespaces to be enabled.  Currently they have 2 choices, 1) use their
>> >> distro kernel as-is, which may not meet their goal of having userns
>> >> disabled, or 2) rebuild their kernel to disable it, which may
>> >> invalidate any support contracts they have.
>> >>
>> >> I tend to agree with you on the lack of value around runtime
>> >> mitigation, but allowing an admin to toggle this as a blatant on/off
>> >> switch on reboot does have value.
>> >>
>> >>>> This feature is already implemented by two distros, and likely wanted
>> >>>> by others. We cannot ignore that. The sysctl default doesn't change
>> >>>> the existing behavior, so this doesn't get in your way at all. Can you
>> >>>> please respond to my earlier email where I rebutted each of your
>> >>>> arguments against it? Just saying "no" and putting words in my mouth
>> >>>> isn't very productive.
>> >>>
>> >>>
>> >>> Calling people who make mistakes insane is not a rebuttal.  In security
>> >>> usability matters, and your sysctl has low usability.
>> >>>
>> >>> Further you seem to have missed something crucial in your understanding.
>> >>> As was explained earlier the sysctl was added to ubuntu to allow early
>> >>> adopters to experiment not as a long term way of managing user
>> >>> namespaces.
>> >>>
>> >>>
>> >>> What sounds like a generally useful feature that would cover your use
>> >>> case and many others is a per user limit on the number of user
>> >>> namespaces users may create.
>> >>
>> >>
>> >> Where that number may be zero?  I don't see how that is really any
>> >> better than a sysctl.  Could you elaborate?
>> >
>> > It's a better option because it would allow better configurability. Take for
>> > example a single user desktop system with some network daemons.  On such a
>> > system, the actual login used for the graphical environment by the user
>> > should be allowed at least a few user namespaces, because some software
>> > depends on them for security (Chrome for example, as well as some distro's
>> > build systems), but system users should be limited to at most one if they
>> > need it, and ideally zero, so that remote exploits couldn't give access to a
>> > user namespace.
>> >
>> > Conversely, on a server system, it's not unreasonable to completely disable
>> > user namespaces for almost everything, except for giving one to services
>> > that use them properly for sand-boxing.
>>
>> OK, so better granularity.  Fine.
>>
>> > I will state though that I only feel this is a better solution given that
>> > two criteria are met:
>> > 1. You can set 0 as the limit.
>> > 2. You can configure this without needing some special software (this in
>> > particular means that seccomp is not an option).
>>
>> I'd have to add 3. You can set a global default for all users that can
>> be overridden on a per user basis.
>>
>> Otherwise you play whack-a-mole with every new user or daemon that
>> adds its own uid.
>
> Given that you want per-user, does a per-uid rlimit, which could be -1
> (unlimited) by default, inherited for all uids mapped into a namespace
> owned by the uid, and which can be set (only reduced) by pam on login,
> make sense?

To clarify, I don't actively want per-user.  Eric suggested it and I'm
thinking through it from a theoretical perspective.  I'd likely be
fine with a big ban-hammer that sysadmins can set, but that doesn't
mean I'm opposed to something more flexible if it makes sense.

I'm not sure if rlimit makes sense in the way you describe it.  I
don't care about uids within an existing user namespace really.  That
is icing on the cake.  I was looking for something that would disallow
uids to create user namespaces to begin with (so inheritance wouldn't
matter).  If rlimit is that mechanism, then I guess.  Seems like an
odd fit though, particularly if you tie it to pam.

> I'm still not actually seeing the value of this apart from another knob
> to prevent kernel memory abuse.  But at least it does kill two birds
> with one stone (also satisfying people who want it turned off altogether).
> Is there a third use case for limiting number of user namespaces per uid?

Not that I can think of.

josh
