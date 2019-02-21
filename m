MIME-Version: 1.0
References: <20190218232308.11241-1-tobin@kernel.org> <20190218232308.11241-6-tobin@kernel.org>
 <CAG48ez0utQJjoJW69OwGiuH1EQtcD939-5u71ruD_1nr0eJK0g@mail.gmail.com> <CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com>
In-Reply-To: <CAGXu5jKeS3bkTSXEw2nsjrWoqhbkDZD4C=PdYTHMtM0GNk6tSg@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 21 Feb 2019 15:28:13 +0100
Message-ID: <CAG48ez34MMBfTzQFxj2o5brYDrUS89_gvX9=SnpWZ+TjMUV-BQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] lib: Fix function documentation for strncpy_from_user
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: "Tobin C. Harding" <tobin@kernel.org>, Shuah Khan <shuah@kernel.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kernel list <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 2:05 AM Kees Cook <keescook@chromium.org> wrote:
> On Mon, Feb 18, 2019 at 4:52 PM Jann Horn <jannh@google.com> wrote:
> > AFAICS the byte_at_a_time loop exits when max==0 is reached, and then
> > if `res >= count` (in other words, if we've copied as many bytes as
> > requested, haven't encountered a null byte so far, and haven't reached
> > the end of the address space), we return `res`, which is the same as
> > `count`. Are you sure?
>
> Oh, whew, there is only 1 arch-specific implementation of this. I
> thought you meant there was multiple implementations.

Not sure what you're talking about. Are you talking about
implementations of strncpy_from_user()?


csky: custom strncpy_from_user() calls custom __do_strncpy_from_user,
which is a macro containing a big asm() block.


h8300:
;;; long strncpy_from_user(void *to, void *from, size_t n)
strncpy_from_user:
mov.l er2,er2
bne 1f
sub.l er0,er0
rts
[...]


mips:
static inline long
strncpy_from_user(char *__to, const char __user *__from, long __len)
{
long res;

if (eva_kernel_access()) {
__asm__ __volatile__(
"move\t$4, %1\n\t"
"move\t$5, %2\n\t"
"move\t$6, %3\n\t"
[...]


unicore32:
ENTRY(__strncpy_from_user)
mov ip, r1
1: sub.a r2, r2, #1
ldrusr r3, r1, 1, ns
bfs 2f
stb.w r3, [r0]+, #1
cxor.a r3, #0
[...]


and so on.

> So, generally speaking, I'd love to split all strncpy* uses into
> strscpy_zero() (when expecting to do str->str copies), and some new
> function, named like mempadstr() or str2mem() that copies a str to a
> __nonstring char array, with trailing padding, if there is space. Then
> there is no more mixing the two cases and botching things.
