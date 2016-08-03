Reply-To: kernel-hardening@lists.openwall.com
From: Michael Ellerman <mpe@ellerman.id.au>
In-Reply-To: <CAGXu5j+tc8Q9NkDi7Wf_JV=D65WC=v=y4ormng9nJ6avDKCMZQ@mail.gmail.com>
References: <1465336628-18219-1-git-send-email-keescook@chromium.org> <1465336628-18219-4-git-send-email-keescook@chromium.org> <87h9b4oebf.fsf@concordia.ellerman.id.au> <CAGXu5jL8UBfs7NjSgKOeqd9toRgtW3gPu53TPLbTMRJiwRUvPg@mail.gmail.com> <87eg67ooe5.fsf@concordia.ellerman.id.au> <CAGXu5j+tc8Q9NkDi7Wf_JV=D65WC=v=y4ormng9nJ6avDKCMZQ@mail.gmail.com>
Date: Wed, 03 Aug 2016 14:46:49 +1000
Message-ID: <87lh0elarq.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: [kernel-hardening] Re: Linker segfault on powerpc when CONFIG_LKDTM=y (was Re: [kernel-hardening] [PATCH 3/5] lkdtm: add function for testing .rodata section)
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, LKML <linux-kernel@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, Anton Blanchard <anton@samba.org>, Alan Modra <amodra@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Kees Cook <keescook@chromium.org> writes:
> On Mon, Aug 1, 2016 at 8:12 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>> Kees Cook <keescook@chromium.org> writes:
>>> On Mon, Aug 1, 2016 at 5:37 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>>>>
>>>>   scripts/link-vmlinux.sh: line 52: 36260 Segmentation fault      (core dumped) ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${2} -T ${lds} ${KBUILD_VMLINUX_INIT} --start-group ${KBUILD_VMLINUX_MAIN} --end-group ${1}
>>>>
>>>> Haven't had a chance to debug it further.
...
>> Interestingly I *can't* reproduce with the Ubuntu x86->ppc cross
>> (5.4.0-6ubuntu1~16.04.1).
>
> Oh, weird. Well, that does explains my lack of hitting the problem,
> though: that's the cross compiler I was using. :P

Actually that was a false negative.

The trick is you have to have LKDTM=y *and* FUNCTION_TRACER=y.

It is a linker bug:

  https://sourceware.org/bugzilla/show_bug.cgi?id=20428

Which Alan has already fixed.

But we need to workaround existing linkers that are out there.

We can do that by marking lkdtm_rodata_do_nothing() notrace, which I
think makes sense for all arches actually.

So I'll send you a patch to do that.

cheers
