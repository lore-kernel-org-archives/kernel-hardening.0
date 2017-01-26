MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAEk6tEyquWE2HS=Nrtzx4RS_GXRMNBBXVtac1dFP2Py17cN_MQ@mail.gmail.com>
References: <CAEk6tExvL7NCB8P-YP7MwT6Ysi8S08H+RgsvBfRXp336noTfxg@mail.gmail.com>
 <CAGXu5j+KYYRvWC1MmMyn3w1N5DsXeAnHR3wZvjpUfUaqd3L2Rw@mail.gmail.com> <CAEk6tEyquWE2HS=Nrtzx4RS_GXRMNBBXVtac1dFP2Py17cN_MQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 26 Jan 2017 13:42:20 -0800
Message-ID: <CAGXu5jL=W0WVNU7LC8j_A1o=dnP0KwiU+Qp=Wu1bzR_FnCtEuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Introduction
To: Jessica Frazelle <me@jessfraz.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 25, 2017 at 8:12 PM, Jessica Frazelle <me@jessfraz.com> wrote:
> On Wed, Jan 25, 2017, 11:37 Kees Cook <keescook@chromium.org> wrote:
>>
>> On Mon, Jan 23, 2017 at 4:06 PM, Jessica Frazelle <me@jessfraz.com> wrote:
>> > I've been lurking on this mailing list for over a year now, so I think
>> > I understand the gist of how it works. I am looking for some ways to
>> > help out in my free time.
>>
>> Greetings! Thanks for saying "hi". :)
>>
>> > The subsystems I know the most about are cgroups and namespaces. I
>> > previously was a maintainer of Docker (I added the seccomp integration
>> > and maintained the AppArmor bits) and now I work on kubernetes.
>> >
>> > Let me know if you think there is a good place to start!
>>
>> I've mostly been trying to keep track of kernel self-protection TODO
>> items, so I haven't been keeping too up to date on userspace-support
>> things that the kernel provides. I know Solar has a list of things
>> he'd like to see, and I know there was an earlier attempt at building
>> an LSM to provide a more hardened chroot implementation (that Elena
>> sent a version of last year).
>>
>
> I am familiar with the chroot LSM from GRSEC, I'm not sure if this
> would help containers much mostly because we use pivot_root and a lot
> of that functionality can be reproduced by either capabilities
> dropping or seccomp. I'm guessing it has a use outside containers but
> I'm not really sure what that may be other than ease of use of not
> having to drop caps etc. I am more than willing to help make sure it
> gets done in a way everyone wants if that's the case.
>
>>
>> Are there any gaps in existing cgroups/namespaces stuff that you'd
>> like to see fixed? Or are there any areas of self-protection work that
>> you find interesting and would want to learn more about?
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Nexus Security
>
> I would definitely like to help with some mechanisms that containers
> and others could integrate to become more secure and I have some ideas
> for this, but they are kind of a larger scale feature.
>
> For now, I would love to help with whatever low hanging fruit no one
> else wants to do but that might benefit some people. Then maybe once
> I've been around the block enough times see if you all are interested
> in something I have briefly thought of that maybe we could make
> awesome together.
>
> Honestly I'm open to working on whatever no one else wants too :)

You said the magic words! ;) Looking at the TODO, I'll pick this semi-randomly:

- expand use of __ro_after_init, especially in arch/arm64

It'd be nice to look through arch/arm64 to find anything that is close
to be able to be declared as const, but can't due to some post-boot
but pre-init changes. This is needs some manual examination currently,
but you can look at other uses of __ro_after_init in arch/x86 and
arch/arm. Of course, there's no reason to limit yourself to arch/arm64
if you find similar things in the core kernel code too.

-Kees

-- 
Kees Cook
Nexus Security
