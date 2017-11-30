MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CA+55aFyobrT7SkFC+PVX0USvRicVt_UPH_nkc-G9Bi8yrCCgPw@mail.gmail.com>
References: <20171129134612.72ccb53d@alans-desktop> <20171129.095014.1909386937628805919.davem@davemloft.net>
 <20171129155406.i2lyclquj75lvtn4@thunk.org> <20171129.105816.1108278026315471171.davem@davemloft.net>
 <CA+55aFyobrT7SkFC+PVX0USvRicVt_UPH_nkc-G9Bi8yrCCgPw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Nov 2017 16:06:48 -0800
Message-ID: <CAGXu5jL+qmekLedFxRC5O7jFdtZUh0NcnLSU7x7mC+zNORTCeg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v5 next 1/5] modules:capabilities: add request_module_cap()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, Theodore Ts'o <tytso@mit.edu>, One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Djalal Harouni <tixxdz@gmail.com>, Andrew Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, James Morris <james.l.morris@oracle.com>, Ben Hutchings <ben.hutchings@codethink.co.uk>, Solar Designer <solar@openwall.com>, "Serge E. Hallyn" <serge@hallyn.com>, Jessica Yu <jeyu@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@kernel.org>, Network Development <netdev@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 29, 2017 at 2:45 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Nov 29, 2017 at 7:58 AM, David Miller <davem@davemloft.net> wrote:
>>
>> We're talking about making sure that loading "ppp.ko" really gets
>> ppp.ko rather than some_other_module.ko renamed to ppp.ko via some
>> other mechanism.
>>
>> Both modules have legitimate signatures so the kernel will happily
>> load both.
>
> Yes. We could make the module name be part of the signing process, but
> one problem with that is that at module loading time we don't actually
> have the filename any more.

FWIW, I added this (well, KBUILD_MODNAME) to the module info just recently:

3e2e857f9c3a ("module: Add module name to modinfo")

> User space opens the file and then just feeds the data to the kernel.
> So if you fooled modprobe into feeding the wrong module, that's it.
>
> And yes, we can obviously embed the module name into the ELF headers
> (that is all part of the signed payload), but the module name doesn't
> actually necessarily match what we originally asked for.
>
> Why? Module aliases and module dependencies - which is why we have
> that user mode side at all. When we do "request_module(XYZ)" we don't
> necessarily know what the dependencies are, so we expect modprobe to
> just load the right modules.
>
> So if modprobe then loads some other module (dccp or whatever), the
> kernel has no real way to know "oh, that wasn't part of the dependency
> chain for the module we aked for".
>
> Now, if modprobe is taught to check that the filename of the module
> that it opens actually matches the metadata in the ELF sections, that
> would solve it, but it's out of the kernels hands..

Right, the aliases are why these kinds of renaming shenanigans don't
mean anything: it's not distinguishable from whatever modprobe.conf
ultimately tells modprobe to do.

If you can't trust your filesystem to hold your kernel modules
correctly, you have much bigger problems. (And yes, capabilities are a
problem here, since there are many paths to full root from individual
capabilities, but that's a known issue that is much larger than
tricking modprobe.)

-Kees

-- 
Kees Cook
Pixel Security
