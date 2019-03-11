MIME-Version: 1.0
References: <20190212180441.15340-1-keescook@chromium.org> <20190212180441.15340-3-keescook@chromium.org>
In-Reply-To: <20190212180441.15340-3-keescook@chromium.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 11 Mar 2019 11:52:09 +0100
Message-ID: <CAMuHMdW6N40+0gGQ+LSrN64Mo4A0-ELAm0pR3gWQ0mNanyBuUQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] lib: Introduce test_stackinit module
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, kernel-hardening@lists.openwall.com, Linux/m68k <linux-m68k@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Kees,

On Tue, Feb 12, 2019 at 7:08 PM Kees Cook <keescook@chromium.org> wrote:
> Adds test for stack initialization coverage. We have several build options
> that control the level of stack variable initialization. This test lets us
> visualize which options cover which cases, and provide tests for some of
> the pathological padding conditions the compiler will sometimes fail to
> initialize.

With current upstream, using gcc Ubuntu 8.2.0-1ubuntu2~18.04, I get
on m68k:

test_stackinit: u8_zero: stack fill missed target!?
test_stackinit: u8_zero: fill 1 wide
test_stackinit: u8_zero: target offset by 20
test_stackinit: u16_zero: stack fill missed target!?
test_stackinit: u16_zero: fill 2 wide
test_stackinit: u16_zero: target offset by 20
test_stackinit: u32_zero: stack fill missed target!?
test_stackinit: u32_zero: fill 4 wide
test_stackinit: u32_zero: target offset by 20
test_stackinit: u64_zero: stack fill missed target!?
test_stackinit: u64_zero: fill 8 wide
test_stackinit: u64_zero: target offset by 20
test_stackinit: char_array_zero: stack fill missed target!?
test_stackinit: char_array_zero: fill 16 wide
test_stackinit: char_array_zero: target offset by -12
test_stackinit: small_hole_zero: stack fill missed target!?
test_stackinit: small_hole_zero: fill 14 wide
test_stackinit: small_hole_zero: target offset by -12
test_stackinit: big_hole_zero ok
test_stackinit: trailing_hole_zero: stack fill missed target!?
test_stackinit: trailing_hole_zero: fill 14 wide
test_stackinit: trailing_hole_zero: target offset by -12
test_stackinit: packed_zero: stack fill missed target!?
test_stackinit: packed_zero: fill 16 wide
test_stackinit: packed_zero: target offset by -12
test_stackinit: small_hole_dynamic_partial: stack fill missed target!?
test_stackinit: small_hole_dynamic_partial: fill 14 wide
test_stackinit: small_hole_dynamic_partial: target offset by -12
test_stackinit: big_hole_dynamic_partial ok
test_stackinit: trailing_hole_dynamic_partial: stack fill missed target!?
test_stackinit: trailing_hole_dynamic_partial: fill 14 wide
test_stackinit: trailing_hole_dynamic_partial: target offset by -12
test_stackinit: packed_dynamic_partial: stack fill missed target!?
test_stackinit: packed_dynamic_partial: fill 16 wide
test_stackinit: packed_dynamic_partial: target offset by -12
test_stackinit: small_hole_static_partial: stack fill missed target!?
test_stackinit: small_hole_static_partial: fill 14 wide
test_stackinit: small_hole_static_partial: target offset by -12
test_stackinit: big_hole_static_partial ok
test_stackinit: trailing_hole_static_partial: stack fill missed target!?
test_stackinit: trailing_hole_static_partial: fill 14 wide
test_stackinit: trailing_hole_static_partial: target offset by -12
test_stackinit: packed_static_partial: stack fill missed target!?
test_stackinit: packed_static_partial: fill 16 wide
test_stackinit: packed_static_partial: target offset by -12
test_stackinit: small_hole_static_all: stack fill missed target!?
test_stackinit: small_hole_static_all: fill 14 wide
test_stackinit: small_hole_static_all: target offset by -12
test_stackinit: big_hole_static_all FAIL (uninit bytes: 61)
test_stackinit: trailing_hole_static_all: stack fill missed target!?
test_stackinit: trailing_hole_static_all: fill 14 wide
test_stackinit: trailing_hole_static_all: target offset by -12
test_stackinit: packed_static_all: stack fill missed target!?
test_stackinit: packed_static_all: fill 16 wide
test_stackinit: packed_static_all: target offset by -12
test_stackinit: small_hole_dynamic_all: stack fill missed target!?
test_stackinit: small_hole_dynamic_all: fill 14 wide
test_stackinit: small_hole_dynamic_all: target offset by -12
test_stackinit: big_hole_dynamic_all FAIL (uninit bytes: 61)
test_stackinit: trailing_hole_dynamic_all: stack fill missed target!?
test_stackinit: trailing_hole_dynamic_all: fill 14 wide
test_stackinit: trailing_hole_dynamic_all: target offset by -12
test_stackinit: packed_dynamic_all: stack fill missed target!?
test_stackinit: packed_dynamic_all: fill 16 wide
test_stackinit: packed_dynamic_all: target offset by -12
test_stackinit: small_hole_runtime_partial: stack fill missed target!?
test_stackinit: small_hole_runtime_partial: fill 14 wide
test_stackinit: small_hole_runtime_partial: target offset by -12
test_stackinit: big_hole_runtime_partial FAIL (uninit bytes: 127)
test_stackinit: trailing_hole_runtime_partial: stack fill missed target!?
test_stackinit: trailing_hole_runtime_partial: fill 14 wide
test_stackinit: trailing_hole_runtime_partial: target offset by -12
test_stackinit: packed_runtime_partial: stack fill missed target!?
test_stackinit: packed_runtime_partial: fill 16 wide
test_stackinit: packed_runtime_partial: target offset by -12
test_stackinit: small_hole_runtime_all: stack fill missed target!?
test_stackinit: small_hole_runtime_all: fill 14 wide
test_stackinit: small_hole_runtime_all: target offset by -12
test_stackinit: big_hole_runtime_all FAIL (uninit bytes: 61)
test_stackinit: trailing_hole_runtime_all: stack fill missed target!?
test_stackinit: trailing_hole_runtime_all: fill 14 wide
test_stackinit: trailing_hole_runtime_all: target offset by -12
test_stackinit: packed_runtime_all: stack fill missed target!?
test_stackinit: packed_runtime_all: fill 16 wide
test_stackinit: packed_runtime_all: target offset by -12
test_stackinit: u8_none: stack fill missed target!?
test_stackinit: u8_none: fill 1 wide
test_stackinit: u8_none: target offset by 20
test_stackinit: u16_none: stack fill missed target!?
test_stackinit: u16_none: fill 2 wide
test_stackinit: u16_none: target offset by 20
test_stackinit: u32_none: stack fill missed target!?
test_stackinit: u32_none: fill 4 wide
test_stackinit: u32_none: target offset by 20
test_stackinit: u64_none: stack fill missed target!?
test_stackinit: u64_none: fill 8 wide
test_stackinit: u64_none: target offset by 20
test_stackinit: char_array_none: stack fill missed target!?
test_stackinit: char_array_none: fill 16 wide
test_stackinit: char_array_none: target offset by -12
test_stackinit: switch_1_none: stack fill missed target!?
test_stackinit: switch_1_none: fill 8 wide
test_stackinit: switch_1_none: target offset by 16
test_stackinit: switch_2_none: stack fill missed target!?
test_stackinit: switch_2_none: fill 8 wide
test_stackinit: switch_2_none: target offset by 16
test_stackinit: small_hole_none: stack fill missed target!?
test_stackinit: small_hole_none: fill 14 wide
test_stackinit: small_hole_none: target offset by -12
test_stackinit: big_hole_none FAIL (uninit bytes: 128)
test_stackinit: trailing_hole_none: stack fill missed target!?
test_stackinit: trailing_hole_none: fill 14 wide
test_stackinit: trailing_hole_none: target offset by -12
test_stackinit: packed_none: stack fill missed target!?
test_stackinit: packed_none: fill 16 wide
test_stackinit: packed_none: target offset by -12
test_stackinit: user: stack fill missed target!?
test_stackinit: user: fill 14 wide
test_stackinit: user: target offset by -12
test_stackinit: failures: 42

Any idea what is wrong? I find the test code a bit hard to understand...

Also, I see comments making assumptions that are not true:

    struct test_small_hole {
            size_t one;
            char two;
            /* 3 byte padding hole here. */
            int three;
            unsigned long four;
    };

On m68k (and a few other architectures), integrals of 16-bit and larger
are aligned to a 2-byte address, so the padding may be only a single byte.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
