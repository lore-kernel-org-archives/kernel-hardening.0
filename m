Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151210000005.GA99337@davidb.org>
References: <20151209172101.GA70633@davidb.org>
	<CAGXu5jLPidHzHwmn5kzK0iSCAehABgtiEzMWgyBvw8iQ-pt=8g@mail.gmail.com>
	<20151210000005.GA99337@davidb.org>
Date: Wed, 9 Dec 2015 16:14:20 -0800
Message-ID: <CAGXu5jLLXK3N6pbZOie5uj276x=dtc_tuTz312rnhF8yrmxHYQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Self Introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Dec 9, 2015 at 4:00 PM, David Brown <david.brown@linaro.org> wrote:
> On Wed, Dec 09, 2015 at 02:19:24PM -0800, Kees Cook wrote:
>>
>> On Wed, Dec 9, 2015 at 9:21 AM, David Brown <david.brown@linaro.org>
>> wrote:
>>>
>>> Per "Get Involved" on the Kernel Self Protection Project wiki, I'm
>>> introducing myself.
>>>
>>> I have recently joined Linaro on the Security Working Group.  As such,
>>> I expect to seen be getting involved with the various kernel hardening
>>> and related projects.
>>
>>
>> Welcome to the mailing list. :)
>>
>> What sorts of things are you interested in working on?
>
>
> A while back, I'd gone through each of the features in grsecurity and
> PAX.  There were a number that seemed good from a security point of
> view, but difficult in terms of culture within the kernel.  I've just
> started up going through these again, as well as reading the kernel
> hardening wiki, and I should soon have a better idea of what would be
> good to work on.  My scope is broad enough that I want to get a good
> idea of where others want to go as well, as well as what brings good
> benefit.

Great! It might be valuable to read through this mailing lists's
threads over the last month. We discuss a few of the features and some
work has been started.

> I suspect part of the challenge is going to be clearly describing the
> various features along with specific examples of already-discovered
> exploits that the feature would have mitigated.

Yes indeed. :) That's why I've arranged the wiki the way I did:
classes and methods first, with potential solutions listed under them.
We want to start with problem descriptions and work from actual
exploits when possible.

This is why the recent x86 VDSO attack was very timely: it
demonstrates cleanly why we want __ro_after_init (n=C3=A9e __read_only) in
upstream. (As well as the constification plugin.)

> Most recently, I backported ARM PAN support to the Linaro stable
> kernels (3.18 and 4.1).

Excellent! Yes, I did a port to Brillo's v4.1 tree as well. It's very
nice to have a UDEREF-like feature on arm. It's too bad this doesn't
exist for Intel yet, but I'm hoping they'll step up.

For 3.18, is this the right place to be looking?
https://git.linaro.org/gitweb?p=3Dkernel/linux-linaro-stable.git;a=3Dshortl=
og;h=3Drefs/heads/linux-linaro-lsk-v3.18

I'd love to see CONFIG_CPU_SW_DOMAIN_PAN into the AOSP 3.18 android kernel =
too.

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
