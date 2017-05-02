References: <CAPLrYES-1WDi0TTdWG7Ds-u1URNeiahNhE9VAE4rLHMw7oYktg@mail.gmail.com>
 <CAGXu5j+Oncz0SgEH4QYx_dhLhits9d8ixQxGwScYCGrNVfdjAQ@mail.gmail.com>
 <CA+rthh-CO287OpGun1-zYc-V632jSHRuwp=Hm0cAnbo1waJKsw@mail.gmail.com>
 <1493683745.2530.2.camel@redhat.com>
 <CA+rthh_JNuXHmVBE8vz-CxQZwJsW=NR8DUfGq5aMHj42VFkpog@mail.gmail.com>
From: Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <5bef6727-5c3d-eb63-bd99-2c45b6092e34@schaufler-ca.com>
Date: Tue, 2 May 2017 14:50:02 -0700
MIME-Version: 1.0
In-Reply-To: <CA+rthh_JNuXHmVBE8vz-CxQZwJsW=NR8DUfGq5aMHj42VFkpog@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] It looks like there will be no more public
 versions of PaX and Grsec.
To: Mathias Krause <minipli@googlemail.com>, Rik van Riel <riel@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, =?UTF-8?Q?Daniel_Cegie=c5=82ka?= <daniel.cegielka@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 5/2/2017 2:16 PM, Mathias Krause wrote:
> On 2 May 2017 at 02:09, Rik van Riel <riel@redhat.com> wrote:
>> On Tue, 2017-05-02 at 00:01 +0200, Mathias Krause wrote:
>>
>>> I think the intention of the KSPP is good -- making vanilla Linux
>>> more
>>> secure. But the way it does its work harms overall Linux security. It
>>> does hurt mine, that's for sure!
>> Yeah, no.
> Well, yes, it does! Losing access to the grsecurity patch makes the
> systems I do care about much less secure.

Then pay for support.

>> The grsecurity people produced patches
>> that were used on maybe a few tens of thousands
>> of systems,
> Where did you pull that number from? Out of thin air, I guess. I know,
> for sure, there are many more installations.

What number are you suggesting, and where did you get it?

>> while the KSPP code will end up
>> enhancing the security of over a billion Android
>> devices.
> Or making them more easily to DoS because features like VMAP_STACK and
> HARDENED_USERCOPY will likely fail hard when hitting a vendor's diver
> code base. Probably making them disable the problematic config
> options. Even upstream still has to fix related fallout.

So you're saying that didn't happen when vendors tried to
apply grsecurity patches?

>> Those Android devices are more likely to require
>> hardening, too, since they do not receive security
>> updates as quickly as the systems maintained by
>> grsecurity users.
> Why couldn't those devices benefit from grsecurity as well? Couldn't
> google or Samsung just integrate grsecurity into their Android
> kernels? They're far away from vanilla Linux anyway, so why not add
> just another patch to provide some matured security code base to
> protect those billion of Android devices? I'd guess, if a big player
> like google would sponsor / pay grsecurity to provide a patch for the
> relevant Android kernels, all sides would be happy: grsecurity for
> getting wider adoption, Android users for having secured systems.

What makes you think that the "big players" didn't carefully
consider using grsecurity? And calling grsecurity "just another
patch" is like the Black Knight referring to his missing limbs
as "flesh wounds". Grsecurity isn't a thing. It's a jumble of
collections of tweaks and clever checks. Without some amount of
breaking out the implementations into discrete features there's
no way anyone doing long term upstream community maintenance
was ever going to be happy.


>> Integrating hardening into the upstream kernel is
>> a good thing for security, not a bad thing.
> I never said it's a bad thing. Indeed I'm all for making vanilla Linux
> more secure. Just how KSPP tries to do it is IMHO wrong. Ripping hunks
> out of grsecurity and trying to integrate them into vanilla Linux
> without understanding all the interdependencies or even the features
> themselves, how would that provide security? By chance, maybe. But not
> intentional, as that requires having thought of every corner case and
> boundary condition.

I seriously doubt that grsecurity is as wonderful as you seem
convinced it is. The fact that one can't identify independent
features or their interdependencies unless you're one of the
authors does not speak well for it. No, much better to examine
the flying saucer at Roswell and use what you've learned to build
understandable components than to "just clone" the starship.

> Regards,
> Mathias
>
