MIME-Version: 1.0
References: <20190212180441.15340-1-keescook@chromium.org> <20190212180441.15340-3-keescook@chromium.org>
 <CAMuHMdW6N40+0gGQ+LSrN64Mo4A0-ELAm0pR3gWQ0mNanyBuUQ@mail.gmail.com>
In-Reply-To: <CAMuHMdW6N40+0gGQ+LSrN64Mo4A0-ELAm0pR3gWQ0mNanyBuUQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 23 Apr 2019 15:42:46 -0700
Message-ID: <CAGXu5jL-J=VTmG4SnnXxFod4G=AxNL5mdeshEKs4yNWb4aYsFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] lib: Introduce test_stackinit module
Content-Type: text/plain; charset="UTF-8"
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux/m68k <linux-m68k@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 11, 2019 at 3:52 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Kees,
>
> On Tue, Feb 12, 2019 at 7:08 PM Kees Cook <keescook@chromium.org> wrote:
> > Adds test for stack initialization coverage. We have several build options
> > that control the level of stack variable initialization. This test lets us
> > visualize which options cover which cases, and provide tests for some of
> > the pathological padding conditions the compiler will sometimes fail to
> > initialize.
>
> With current upstream, using gcc Ubuntu 8.2.0-1ubuntu2~18.04, I get
> on m68k:

Thanks for testing this on other architectures!

> test_stackinit: u8_zero: stack fill missed target!?

Hmpf. That's frustrating. That implies that the leaf function is
assembled in such a way that the "leaking" memory address and the
"controlled" memory address on the stack end up in different
locations. I had a lot of problems with this before I unified my leaf
function. I wonder if some inlining is happening with the m68k
compiler that I haven't accounted for?

> Any idea what is wrong? I find the test code a bit hard to understand...

Yeah, there was a lot of repetition, so I tried to save my sanity and
build macros. The particular problem above is with the "test_..."'s
call of the "leaf_..." functions:

        /* Fill stack with 0xFF. */                             \
        ignored = leaf_ ##name((unsigned long)&ignored, 1,      \
                                FETCH_ARG_ ## which(zero));     \
        /* Clear entire check buffer for later bit tests. */    \
        memset(check_buf, 0x00, sizeof(check_buf));             \
        /* Extract stack-defined variable contents. */          \
        ignored = leaf_ ##name((unsigned long)&ignored, 0,      \
                                FETCH_ARG_ ## which(zero));     \

those two leaf_* invocations should produce stack variables at the
same location on the stack:

        var_type var INIT_ ## which ## _ ## init_level;         \
                                                                \
        target_start = &var;                                    \
        target_size = sizeof(var);                              \
        /*                                                      \
         * Keep this buffer around to make sure we've got a     \
         * stack frame of SOME kind...                          \
         */                                                     \
        memset(buf, (char)(sp && 0xff), sizeof(buf));           \
        /* Fill variable with 0xFF. */                          \
        if (fill) {                                             \
                fill_start = &var;                              \
                fill_size = sizeof(var);                        \

(note "target_start" and "fill_start" being assigned the location of
(in theory) the same stack location)

This gets checked later:

        /* Validate that compiler lined up fill and target. */  \
        if (!range_contains(fill_start, fill_size,              \
                            target_start, target_size)) {       \
                pr_err(#name ": stack fill missed target!?\n"); \
                pr_err(#name ": fill %zu wide\n", fill_size);   \
                pr_err(#name ": target offset by %d\n", \
                        (int)((ssize_t)(uintptr_t)fill_start -  \
                        (ssize_t)(uintptr_t)target_start));     \
                return 1;                                       \

which is where you're seeing the report.

> Also, I see comments making assumptions that are not true:
>
>     struct test_small_hole {
>             size_t one;
>             char two;
>             /* 3 byte padding hole here. */
>             int three;
>             unsigned long four;
>     };
>
> On m68k (and a few other architectures), integrals of 16-bit and larger
> are aligned to a 2-byte address, so the padding may be only a single byte.

Ah! Good point. I can update the comments, but the test should still
be valid (it just has a smaller hole).

Thanks again!

-- 
Kees Cook
