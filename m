Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160414203444.GC3856@amd>
References: <20160412221659.GA18102@www.outflux.net>
	<20160414200102.GB3856@amd>
	<CAGXu5jKNKV2RaPCw+m3R-e7irmmP0eRBBq9RKY0mcH5A1Nsx6g@mail.gmail.com>
	<20160414203444.GC3856@amd>
Date: Thu, 14 Apr 2016 15:42:48 -0700
Message-ID: <CAGXu5j+cTYF_OGG=u4BKU5X3f6TF0FdAcES9e_8S0ajMyjhn6Q@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2] kaslr: allow kASLR to be default over Hibernation
To: Pavel Machek <pavel@denx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Ingo Molnar <mingo@kernel.org>, James Morse <james.morse@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, Yves-Alexis Perez <corsac@debian.org>, Emrah Demir <ed@abdsec.com>, Jonathan Corbet <corbet@lwn.net>, "x86@kernel.org" <x86@kernel.org>, Len Brown <len.brown@intel.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 14, 2016 at 1:34 PM, Pavel Machek <pavel@denx.de> wrote:
> On Thu 2016-04-14 13:14:07, Kees Cook wrote:
>> On Thu, Apr 14, 2016 at 1:01 PM, Pavel Machek <pavel@denx.de> wrote:
>> > Hi!
>> >
>> >> Since kASLR and Hibernation can not currently coexist at runtime
>> >> on x86, the default behavior was to disable kASLR by default when
>> >> CONFIG_HIBERNATION was present (to retain original behavior).
>> >>
>> >> The behavior of kASLR on arm64 (and soon MIPS) is to be enabled by
>> >> default when selected at build time. Since arm64 Hibernation does not
>> >> conflict with kASLR, this fixes the hibernation argument parsing to be
>> >> x86-specific. Additionally, since end users want to be able to select
>> >> kASLR on x86 by default at build time, create CONFIG_RANDOMIZE_BASE_ON
>> >> that is present only on x86.
>> >>
>> >> Signed-off-by: Kees Cook <keescook@chromium.org>
>> >
>> > I believe this is bad idea. arm64 shows that kaslr and hibernation can
>> > coexist, and hibernation is still useful when your battery runs out.
>>
>> What? I'm confused -- this patch leaves the x86 behavior as-is by
>> default but allows hibernation to work with arm64. (For example, right
>> now, if you boot arm64 with "kaslr" kernel argument, hibernation will
>> get needlessly disabled.)
>
> So it is very different from the PATCH v1, still it shares the
> subject?

It was similar, but not the same:

v1: Prefer kASLR over Hibernation
v2: kaslr: allow kASLR to be default over Hibernation

I'm happy to call it whatever you like, though! :)

> This is the part I don't like:
>
>> >> Since kASLR and Hibernation can not currently coexist at runtime
>> >> on x86, the default behavior was to disable kASLR by default when
>> >> CONFIG_HIBERNATION was present (to retain original behavior).
>
> Now I notice that it is quite unclear if it actually changes
> anything...

Okay, right. So, there are a few problems that this patch is solving,
and maybe it needs to be broken up into separate patches, but it
didn't seem like it to me at the time. Specifically:

1) The x86 hibernation and KASLR code don't play well together currently.

"1" was worked around so that both could be built in, but only one
would be active at a time. This lead to:

2) The general hibernation code contains kernel arguments that should
only affect x86.

And we have the desire by folks to have KASLR enabled by default on
x86, giving us:

3) There is no build-time way on x86 to switch the preference of KASLR
vs hibernation.

I think "2" should be solved for this release, since arm64 KASLR is
landing, and mistakenly booting an arm64 system with "kaslr" on the
command line will needlessly disable hibernation.

3 and 2 are a result of 1, and IIUC, you're saying you want to solve 1
to make everything else go away? My only concern with that idea is
that I don't (yet) have the knowledge of x86 hibernation internals to
fix this, and it'll take a while to get to having KASLR on by default
if we have to wait on me to fix hibernation. (I'm not saying I
won't/can't, it's just that it'll take me time to come up to speed on
it.)

That do you think?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
