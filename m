Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrX0VXZVgy0_6-Jq_sT4yPKYogGjTZvn8VqvMzPtw4-3wg@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
 <CALCETrX0VXZVgy0_6-Jq_sT4yPKYogGjTZvn8VqvMzPtw4-3wg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Jun 2016 10:16:46 -0700
Message-ID: <CA+55aFzBAdM2UGpmVQjhnEtsvfPmJE1aqeoo4e65PrQvsvsFnQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jun 21, 2016 at 9:45 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> So I'm leaning toward fewer cache entries per cpu, maybe just one.
> I'm all for making it a bit faster, but I think we should weigh that
> against increasing memory usage too much and thus scaring away the
> embedded folks.

I don't think the embedded folks will be scared by a per-cpu cache, if
it's just one or two entries.  And I really do think that even just
one or two entries will indeed catch a lot of the cases.

And yes, fork+execve() is too damn expensive in page table build-up
and tear-down. I'm not sure why bash doesn't do vfork+exec for when it
has to wait for the process anyway, but it doesn't seem to do that.

                 Linus
