Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <99FC4B6EFCEFD44486C35F4C281DC6731F1E47BD@ORSMSX107.amr.corp.intel.com>
References: <CAB-iPKVnu554hZ=nSmSgrLQE+c02oGKE8As5prWHy6n0O=erCw@mail.gmail.com>
	<CAGXu5j+mTVrtDXbGtF=-nyAxnTe2YDL4PyUnJw+vfXX_ZVzwxg@mail.gmail.com>
	<1450399738.3054.10.camel@gmail.com>
	<99FC4B6EFCEFD44486C35F4C281DC6731F1E47BD@ORSMSX107.amr.corp.intel.com>
Date: Fri, 18 Dec 2015 13:11:52 -0800
Message-ID: <CAGXu5jL5CYezUCJkfkec8K=L_1qLy9gXmBLUz6YPvV9=+PAR9w@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Dec 18, 2015 at 8:54 AM, Schaufler, Casey
<casey.schaufler@intel.com> wrote:
>> -----Original Message-----
>> From: Daniel Micay [mailto:danielmicay@gmail.com]
>> Sent: Thursday, December 17, 2015 4:49 PM
>> To: kernel-hardening@lists.openwall.com
>> Subject: Re: [kernel-hardening] Introduction
>>
>> On Thu, 2015-12-17 at 16:36 -0800, Kees Cook wrote:
>> > On Thu, Dec 17, 2015 at 3:34 PM, Leibowitz, Michael
>> > <michael.leibowitz@intel.com> wrote:
>> > > I work in Intel's Open Source Technology center, along with my
>> > > colleague, Elena Reshetova.  I'm reasonably new real-life kernel
>> > > development, having previously just mucked about.  Otherwise, I'm a
>> > > long-time open source/security trouble maker.
>> >
>> > Hi! Welcome! :)
>> >
>> > > I'm Interested in working on struct randomization ala RANDSTRUCT.
>> > > Does this seem like a suitable task?
>> >
>> > I certainly wouldn't turn it down, but I would observe that it has
>> > some limited utility to users of the kernel that produce binary
>> > builds. e.g. all the given builds of Ubuntu with RANDSTRUCT would be
>> > the same (though the next released version would see a different
>> > randomization, etc). It also complicates externally built modules. I
>> > see it depends on HIDESYM, though, which in turn depends on
>> > PAX_USERCOPY, so it would be much weaker without these two finished
>> > first.
>
> I'm working on teasing the PAX_USERCOPY implementation
> out of the greater grsecurity patch. I am reminded of a time
> when I had to pull a group of small splinters from my hand.
> Both for the difficulty in finding all of them, and the pain
> involved. I hope to have something limping along by the end
> of the month, holiday cheer permitting.

Fantastic! Thanks for taking a look at it.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
