Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20120311172512.GA2729@redhat.com>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <1331421919-15499-2-git-send-email-tixxdz@opendz.org> <20120311172512.GA2729@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Mar 2012 15:48:02 -0700
Message-ID: <CA+55aFweRPaxMk1Y8vQg+yzwRA94GYngtZLrB0AkHo5-egfQBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH 1/9] exec: add a global execve counter
To: Oleg Nesterov <oleg@redhat.com>
Cc: Djalal Harouni <tixxdz@opendz.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Mar 11, 2012 at 10:25 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> It should be per-process, signal_struct makes more sense. Or may be
> mm_struct.

I do wonder if we shouldn't just consider the "struct mm_struct"
pointer to *be* the unique exec ID. It's what /proc/pid/mem does, and
it works fine, and allows us to just use a normal pointer as the
unique ID.

Just increment the mm_count for the thing, and hold a reference to it,
and now you're all done.

By definition an execve() will change the mm struct, and if you have a
refcount to the old one, it won't be re-used. And it's not a huge
allocation, although it would definitely be good to put that thing on
a diet.

And as long as we use 'mm_count', not 'mm_users', it won't pin
anything else in memory. That's part of the whole point of the
doubly-refcounted thing.

                      Linus
