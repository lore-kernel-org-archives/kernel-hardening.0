Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <87eg67ooe5.fsf@concordia.ellerman.id.au>
References: <1465336628-18219-1-git-send-email-keescook@chromium.org>
 <1465336628-18219-4-git-send-email-keescook@chromium.org> <87h9b4oebf.fsf@concordia.ellerman.id.au>
 <CAGXu5jL8UBfs7NjSgKOeqd9toRgtW3gPu53TPLbTMRJiwRUvPg@mail.gmail.com> <87eg67ooe5.fsf@concordia.ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 2 Aug 2016 12:12:33 -0700
Message-ID: <CAGXu5j+tc8Q9NkDi7Wf_JV=D65WC=v=y4ormng9nJ6avDKCMZQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Re: Linker segfault on powerpc when
 CONFIG_LKDTM=y (was Re: [kernel-hardening] [PATCH 3/5] lkdtm: add function
 for testing .rodata section)
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Jiri Slaby <jslaby@suse.cz>, Guenter Roeck <linux@roeck-us.net>, LKML <linux-kernel@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, Anton Blanchard <anton@samba.org>, Alan Modra <amodra@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 1, 2016 at 8:12 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
>
>> On Mon, Aug 1, 2016 at 5:37 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
>>> Kees Cook <keescook@chromium.org> writes:
>>>
>>>> This adds a function that lives in the .rodata section. The section
>>>> flags are corrected using objcopy since there is no way with gcc to
>>>> declare section flags in an architecture-agnostic way.
>>>>
>>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>>> ---
>>>>  drivers/misc/Makefile       |  7 +++++++
>>>>  drivers/misc/lkdtm.h        |  6 ++++++
>>>>  drivers/misc/lkdtm_core.c   | 24 +++++++++++++++++-------
>>>>  drivers/misc/lkdtm_rodata.c | 10 ++++++++++
>>>>  4 files changed, 40 insertions(+), 7 deletions(-)
>>>>  create mode 100644 drivers/misc/lkdtm.h
>>>>  create mode 100644 drivers/misc/lkdtm_rodata.c
>>>
>>> This is blowing up my linker :(
>>>
>>>   scripts/link-vmlinux.sh: line 52: 36260 Segmentation fault      (core dumped) ${LD} ${LDFLAGS} ${LDFLAGS_vmlinux} -o ${2} -T ${lds} ${KBUILD_VMLINUX_INIT} --start-group ${KBUILD_VMLINUX_MAIN} --end-group ${1}
>>>
>>> Haven't had a chance to debug it further.
>>
>> Argh. Do you want a quick fix for this now? I can add a PPC CONFIG
>> blacklist for the rodata check, maybe?
>
> Nah that's OK, none of our defconfigs have it enabled so it's not a real
> blocker. It also builds OK as a module - though I haven't tested the
> result yet.

Okay, I'll leave it as is.

>> Also, what version of gcc? I'll see if I can reproduce this with a
>> cross compiler...
>
> The original hit was with gcc-5.3 (which is actually a x86->ppc cross):
>
>   http://kisskb.ellerman.id.au/kisskb/buildresult/12762730/
>
> But I can also reproduce with 5.4, and 6.1.0.
>
> Interestingly I *can't* reproduce with the Ubuntu x86->ppc cross
> (5.4.0-6ubuntu1~16.04.1).

Oh, weird. Well, that does explains my lack of hitting the problem,
though: that's the cross compiler I was using. :P

> Those toolchains are all using binutils 2.26 AFAIK.

I wonder if this is some gold vs bfd issue, or a specific bug that got
fixed in the Ubuntu tree but hasn't landed in 6.1 or 5.4 (??)

> Going back to a really old toolchain (gcc 4.6.3/binutils 2.22) it does
> build but I get these warnings:
>
>  powerpc64-linux-ld: drivers/misc/built-in.o: .opd is not a regular array of opd entries
>  powerpc64-linux-ld: drivers/built-in.o: .opd is not a regular array of opd entries

How strange. I wonder if there's some corner case of the objcopy that
is wrong...

> So probably don't worry about it and we'll try and work it out on our end.

Okay, sounds good.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
