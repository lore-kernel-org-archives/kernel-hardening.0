MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180227111532.1144-1-ppandit@redhat.com>
References: <20180227111532.1144-1-ppandit@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 27 Feb 2018 11:28:53 -0800
Message-ID: <CAGXu5j+-qUrt-8kQ6WRUM=DH8K3Zgmm2ejRgiKJMLDrSXRtmdg@mail.gmail.com>
Subject: Re: [PATCH 0/1] Zero initialise kernel stack variables
Content-Type: text/plain; charset="UTF-8"
To: P J P <ppandit@redhat.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Florian Weimer <fweimer@redhat.com>, P J P <pjp@fedoraproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 27, 2018 at 3:15 AM, P J P <ppandit@redhat.com> wrote:
> Hello,

Hi!

>
> Please see:
>   -> https://gcc.gnu.org/ml/gcc-patches/2014-06/msg00615.html
>
> This experimental patch by Florian Weimer(CC'd) adds an option
> '-finit-local-vars' to gcc(1) compiler. When a program(or kernel)
> is built using this option, its automatic(local) variables are
> initialised with zero(0). This could significantly reduce the kernel
> information leakage issues.
>
> A dnf(8) repository of the latest gcc-7.3.1 package built with the above
> patch and kernel-4.15.5 package built using '-finit-local-vars' option
> on Fedora-27 is available below
>
>   -> https://pjp.fedorapeople.org/init-vars/
>
> This same kernel is running on my F27 test machine as I write this.
> There is no slowness or notice-able performance impact as such.

Unfortunately "noticeable" isn't going to be a viable metric. You'll
need to do some real-world benchmarks (i.e. kernel builds, hackbench,
etc), and compare the results. Even just initializing
passed-by-reference variables (GCC_PLUGIN_STRUCTLEAK_BYREF_ALL) had
measurable performance impact.

It would be nice to have four options/features available from the
compiler, from least to most performance impact:

- initialize padding to zero when static initializers are used (this
would make  foo = { .field = something }; identical to memset(&foo, 0,
sizeof(foo)); foo.field = something for all structures, but now, any
structures with padding _must_ use the latter to be safe, which is
highly error-prone).

- initialize all uninitialized variables that contain a structure
marked with a special attribute (e.g.
__attribute__((force_initialize)) ).

- initialize all uninitialized variables that are passed by reference
(see GCC_PLUGIN_STRUCTLEAK_BYREF_ALL).

- initialize all uninitialized variables (-finit-local-vars seems to do this)

> The patch here adds a kbuild menu option to enable/disable '-finit-local-vars'
> compiler flag while building the Linux kernel.

Since this is a single patch, I think it'd be better to fold this
entire cover letter into patch 1.

> I'd appreciate your review and/or inputs to test this option further.

Thanks for sending this!

-Kees

-- 
Kees Cook
Pixel Security
