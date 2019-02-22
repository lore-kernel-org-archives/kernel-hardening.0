From: Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH 0/7] Kernel Userspace Protection for radix
In-Reply-To: <CAGXu5jL0ZOzTo2sXiWkgemcwHusX4YuM9b_9y-MZ2THuDoRC+g@mail.gmail.com>
References: <20190221093601.27920-1-ruscur@russell.cc> <CAGXu5j+P1wh0uf1kfMywSTo4NYtwFPSnKXg6wbfyBRqwVRZVYA@mail.gmail.com> <8ef1669cdfbcc6114eebc30c610c91c191c7cc7a.camel@russell.cc> <CAGXu5jL0ZOzTo2sXiWkgemcwHusX4YuM9b_9y-MZ2THuDoRC+g@mail.gmail.com>
Date: Fri, 22 Feb 2019 14:46:24 +1100
Message-ID: <87bm34pjsf.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
To: Kees Cook <keescook@chromium.org>, Russell Currey <ruscur@russell.cc>
Cc: PowerPC <linuxppc-dev@lists.ozlabs.org>, Nick Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@c-s.fr>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:
> On Thu, Feb 21, 2019 at 4:09 PM Russell Currey <ruscur@russell.cc> wrote:
>> On Thu, 2019-02-21 at 08:07 -0800, Kees Cook wrote:
>> > On Thu, Feb 21, 2019 at 1:36 AM Russell Currey <ruscur@russell.cc>
>> > wrote:
>> > > The first three patches of these series are from Christophe's work
>> > > and are
>> > > the bare minimum framework needed to implement the support for
>> > > radix.
>> > >
>> > > In patch 3, I have removed from Christophe's patch my
>> > > implementation of
>> > > the 64-bit exception handling code, since we don't have an answer
>> > > for
>> > > making nested exceptions work yet.  This is mentioned in the final
>> > > KUAP
>> > > patch.  Regardless, this is still a significant security
>> > > improvement
>> > > and greatly narrows the attack surface.
>> >
>> > Nice! Am I understanding correctly that with this series powerpc9 and
>> > later, using radix, will pass the lkdtm tests for KUAP and KUEP (i.e.
>> > EXEC_USERSPACE and ACCESS_USERSPACE)?
>>
>> Yes!  We've had execution prevention for a while on radix (which is
>> default on POWER9) since 3b10d0095a1e, the only functional thing this
>> series does is allow disabling it with nosmep.  This series adds access
>> prevention.
>
> Ah-ha; excellent. And CONFIG_PPC_RADIX_MMU is "default y" already. :)

Though on real hardware it doesn't really work yet, at least if there
are any idle states enabled.

Patch under discussion to fix it:

  https://patchwork.ozlabs.org/patch/1038568/


cheers
