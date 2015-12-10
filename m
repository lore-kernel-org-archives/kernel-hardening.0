Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151210002651.GC99337@davidb.org>
References: <20151209172101.GA70633@davidb.org>
	<CAGXu5jLPidHzHwmn5kzK0iSCAehABgtiEzMWgyBvw8iQ-pt=8g@mail.gmail.com>
	<20151210000005.GA99337@davidb.org>
	<CAGXu5jLLXK3N6pbZOie5uj276x=dtc_tuTz312rnhF8yrmxHYQ@mail.gmail.com>
	<20151210002651.GC99337@davidb.org>
Date: Wed, 9 Dec 2015 16:41:04 -0800
Message-ID: <CAGXu5jJYRCZ1-frx3+pUPabm3XRFFU8T4gsCQaSc73aA4Q--3g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Self Introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 9, 2015 at 4:26 PM, David Brown <david.brown@linaro.org> wrote:
> On Wed, Dec 09, 2015 at 04:14:20PM -0800, Kees Cook wrote:
>
>> Great! It might be valuable to read through this mailing lists's
>> threads over the last month. We discuss a few of the features and some
>> work has been started.
>
>
> Reading through stuff now.  Looks like the list got quite a boost in
> November.
>
>>> I suspect part of the challenge is going to be clearly describing the
>>> various features along with specific examples of already-discovered
>>> exploits that the feature would have mitigated.
>>
>>
>> Yes indeed. :) That's why I've arranged the wiki the way I did:
>> classes and methods first, with potential solutions listed under them.
>> We want to start with problem descriptions and work from actual
>> exploits when possible.
>>
>> This is why the recent x86 VDSO attack was very timely: it
>> demonstrates cleanly why we want __ro_after_init (n=C3=A9e __read_only) =
in
>> upstream. (As well as the constification plugin.)
>
>
> Which also seems like this will be quite useful on ARM as well.  Do
> you know any efforts to do this?

I've not seen any yet. If you get it written, I can include it in my
__ro_after_init series on the next revision.

>>> Most recently, I backported ARM PAN support to the Linaro stable
>>> kernels (3.18 and 4.1).
>>
>>
>> Excellent! Yes, I did a port to Brillo's v4.1 tree as well. It's very
>> nice to have a UDEREF-like feature on arm. It's too bad this doesn't
>> exist for Intel yet, but I'm hoping they'll step up.
>>
>> For 3.18, is this the right place to be looking?
>>
>> https://git.linaro.org/gitweb?p=3Dkernel/linux-linaro-stable.git;a=3Dsho=
rtlog;h=3Drefs/heads/linux-linaro-lsk-v3.18
>
>
> It will be once it gets through testing.
> https://git.linaro.org/kernel/linux-linaro-stable.git/shortlog/refs/heads=
/v3.18/topic/PAN
> to peek before then.  There's also
> https://git.linaro.org/kernel/linux-linaro-stable.git/shortlog/refs/heads=
/v4.1/topic/PAN
> for the 4.1 tree.

Oh! I see now. You meant hardware PAN support. Yes, also good to get
in for the arm64 devices. I meant the CONFIG_CPU_SW_DOMAIN_PAN
support. I've backported that from 4.3 to 4.1 since then all arm
devices would gain PAN-like support too.

> Should I CC kernel-hardening when sending patches for the Linaro
> stable kernels?

Probably not for stable backports. I think upstream development things
probably should be, and we can certainly discuss stuff that looks like
it'd be good to backport, but I wouldn't want to bore people with
patch for old kernels. :)

>> I'd love to see CONFIG_CPU_SW_DOMAIN_PAN into the AOSP 3.18 android kern=
el
>> too.
>
> I'll put this on my list to investigate.  Sadly, it looks like there
> is a bit of a window of ARM CPUs where neither solution will work;
> Basically the pre V8.1 64-bit.

The LPAE support for PAN emulation exists in grsecurity, if someone
wanted to look at how to extract it and add it to
CONFIG_CPU_SW_DOMAIN_PAN (or similar).

> In fact, I don't have any hardware yet that supports PAN.  I've done
> all of the testing in emulation.

Heh, yeah, that's how the x86 SMAP stuff is too. ;)

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
