Return-Path: <linux-api-owner@vger.kernel.org>
MIME-Version: 1.0
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
	 <201906251131.419D8ACB@keescook>
In-Reply-To: <201906251131.419D8ACB@keescook>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 25 Jun 2019 13:13:11 -0700
Message-ID: <CALCETrWg+vZWAdY-6etLnh=wyB1aXdG9s8ASUXX=cjjFm7CKZQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-api-owner@vger.kernel.org
Subject: Re: Detecting the availability of VSYSCALL
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, linux-arch <linux-arch@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Carlos O'Donell <carlos@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 25, 2019 at 1:08 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Jun 25, 2019 at 05:15:27PM +0200, Florian Weimer wrote:
> > Should we try mapping something at the magic address (without MAP_FIXED)
> > and see if we get back a different address?  Something in the auxiliary
> > vector would work for us, too, but nothing seems to exists there
> > unfortunately.
>
> It seems like mmap() won't even work because it's in the high memory
> area. I can't map something a page under the vsyscall page either, so I
> can't distinguish it with mmap, mprotect, madvise, or msync. :(
>

I keep contemplating making munmap() work on it.  That would nicely
answer the question: if munmap() fails, it's not there, and, if
munmap() succeeds, it's not there :)
