MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <4dd5a4d0f6b694f17eaf64c80c36a2560993b9ea.1517164461.git.luto@kernel.org>
References: <cover.1517164461.git.luto@kernel.org> <4dd5a4d0f6b694f17eaf64c80c36a2560993b9ea.1517164461.git.luto@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2018 11:15:15 -0800
Message-ID: <CA+55aFxbE6p+3kMumsTfh_E=fR=bteKi4d6WLGaFeBP8JBv_eg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 3/3] syscalls: Add a bit of documentation to __SYSCALL_DEFINE
To: Andy Lutomirski <luto@kernel.org>
Cc: the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jan 28, 2018 at 10:38 AM, Andy Lutomirski <luto@kernel.org> wrote:
> __SYSCALL_DEFINE is rather magical.  Add a bit of documentation.

Ack.

Is that "long long" part of the example on purpose? Because that's
likely the only really nasty part about any ptregs wrapper: some
arguments aren't _one_ register, they are two. And "long long" is the
simplest example, even though in practice the type is most often
"loff_t".

You won't see this on 64-bit architectures, but it's visible on 32-bit ones.

We may have to do wrappers for those, and error out for 'long long'.
We already do that for some cases, for compat system calls. See for
example

COMPAT_SYSCALL_DEFINE5(preadv, compat_ulong_t, fd,
                const struct compat_iovec __user *,vec,
                compat_ulong_t, vlen, u32, pos_low, u32, pos_high)
{
        loff_t pos = ((loff_t)pos_high << 32) | pos_low;

        return do_compat_preadv64(fd, vec, vlen, pos, 0);
}

where we have the issue of a 64-bit value being split over two
registers even on 64-bit, due to it being a compat interface for 32
bit.

But if we pick up the values by hand from ptregs in a wrapper, we'll
have this issue even for native calls on 32-bit.

             Linus
