MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+rthh_JNuXHmVBE8vz-CxQZwJsW=NR8DUfGq5aMHj42VFkpog@mail.gmail.com>
References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
 <1493683745.2530.2.camel@redhat.com> <CA+rthh_JNuXHmVBE8vz-CxQZwJsW=NR8DUfGq5aMHj42VFkpog@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 2 May 2017 15:57:08 -0700
Message-ID: <CAGXu5jLRCfEv=Ozt5LHzLHkvttyh_aFXYW8-s4tSF2CNNMg-xw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Mathias Krause <minipli@googlemail.com>
Cc: Rik van Riel <riel@redhat.com>, =?UTF-8?Q?Daniel_Cegie=C5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, May 2, 2017 at 2:16 PM, Mathias Krause <minipli@googlemail.com> wrote:
> On 2 May 2017 at 02:09, Rik van Riel <riel@redhat.com> wrote:
>> while the KSPP code will end up
>> enhancing the security of over a billion Android
>> devices.
>
> Or making them more easily to DoS because features like VMAP_STACK and
> HARDENED_USERCOPY will likely fail hard when hitting a vendor's diver
> code base. Probably making them disable the problematic config
> options. Even upstream still has to fix related fallout.

A vendor who would disable HARDENED_USERCOPY would never have
integrated grsecurity, so that's a totally false equivalency.

I don't disagree that VMAP_STACK might have been implemented in a way
to better catch driver mistakes, but the condition was deemed rare
enough that it got implemented the way it did. You may object to the
difference in engineering practices, but pragmatism comes in many
flavors. And no one else developed vmap stacks for upstream, so I'd
rather have it than not.

>> Those Android devices are more likely to require
>> hardening, too, since they do not receive security
>> updates as quickly as the systems maintained by
>> grsecurity users.
>
> Why couldn't those devices benefit from grsecurity as well? Couldn't
> google or Samsung just integrate grsecurity into their Android
> kernels? They're far away from vanilla Linux anyway, so why not add
> just another patch to provide some matured security code base to
> protect those billion of Android devices? I'd guess, if a big player

The very fact that you're asking this question means you don't
understand how vendors deal with the kernel. With a small engineering
team, you can't afford to have changes from upstream you can't
support, so you leave as much of the kernel at stock upstream as
possible so you can get help from upstream when you need it. Now,
ironically, these same vendors don't realize that the moment their
kernel ages a few years, they're on the hook for supporting the ENTIRE
kernel again, since upstream has left that kernel in the dust.

Those organizations can't justify the resources needed to support an
out-of-tree kernel as their starting point. Chrome OS was probably one
of the most paranoid OS designs in a commercially available product
and we still couldn't get agreement to use grsecurity. (Though I would
point out support isn't the only issue: another is the risk of the
fork disappearing. *cough*)

> like google would sponsor / pay grsecurity to provide a patch for the
> relevant Android kernels, all sides would be happy: grsecurity for
> getting wider adoption, Android users for having secured systems.

And yet this never happened, and so the only way to get the defenses
to the general public was the upstream them. Which is something
grsecurity refused to do, even when offered money to do it.

>> Integrating hardening into the upstream kernel is
>> a good thing for security, not a bad thing.
>
> I never said it's a bad thing. Indeed I'm all for making vanilla Linux
> more secure. Just how KSPP tries to do it is IMHO wrong. Ripping hunks
> out of grsecurity and trying to integrate them into vanilla Linux
> without understanding all the interdependencies or even the features
> themselves, how would that provide security? By chance, maybe. But not
> intentional, as that requires having thought of every corner case and
> boundary condition.

So what's the solution? Give up? No. Want upstream to be some how
better at porting or developing defenses? Okay, help us. "Do it
better" isn't a particularly useful suggestion.

Besides, the defenses aren't opaque, even if they're virtually
undocumented. They can be extracted, studied, ported, and landed. For
the defenses that we're interested in that came from grsecurity, this
doesn't seem like a bad approach. If you have expertise in some of the
areas that are being upstreamed, speak up and contribute. Want
something to be upstreamed to your liking? Please do it.

-Kees

-- 
Kees Cook
Pixel Security
