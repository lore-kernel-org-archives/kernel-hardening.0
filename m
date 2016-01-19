Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160115013655.5f0ae253@pc1>
References: <58374.1452813069@turing-police.cc.vt.edu>
	<20160115013655.5f0ae253@pc1>
Date: Tue, 19 Jan 2016 09:23:32 -0800
Message-ID: <CAGXu5jLQQfuinhxu8RPFgCRNzGoby261RtQJE6zK5fvqbPX0jA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] For whoever's looking at memory santizing..
To: Casey Schaufler <casey.schaufler@intel.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 14, 2016 at 4:36 PM, Hanno B=C3=B6ck <hanno@hboeck.de> wrote:
> On Thu, 14 Jan 2016 18:11:09 -0500
> Valdis Kletnieks <Valdis.Kletnieks@vt.edu> wrote:
>
>> If you need a real-life example of why we should be doing it
>> consistently:
>>
>> http://venturebeat.com/2016/01/13/nvidia-blames-apple-for-bug-that-expos=
es-porn-browsing-in-chromes-incognito-mode/
>
> This article seems to be only about OS X.
>
> I hope it's no secret that this is a problem on Linux as well:
> https://hsmr.cc/palinopsia/
>
> And from all I'm aware it's unfixed.

I'm curious if this is fixable from the DRM layer, or if it's strictly
driver-specific. Casey, could you bounce this toward some of the Intel
graphics folks? While Intel isn't called out, I'm curious if there is
still something that could be done in the general case...

-Kees

--=20
Kees Cook
Chrome OS & Brillo Security
