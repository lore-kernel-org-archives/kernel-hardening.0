Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
References: <cover.1466466093.git.luto@kernel.org> <CA+55aFyahpuy94qqECj0ZA6oD3Vy0r=gY2cH8_dB1a-4XURV2Q@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 21 Jun 2016 09:45:33 -0700
Message-ID: <CALCETrX0VXZVgy0_6-Jq_sT4yPKYogGjTZvn8VqvMzPtw4-3wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v3 00/13] Virtually mapped stacks with guard pages (x86, core)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 20, 2016 at 9:01 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jun 20, 2016 at 4:43 PM, Andy Lutomirski <luto@kernel.org> wrote:
>>
>> On my laptop, this adds about 1.5=C2=B5s of overhead to task creation,
>> which seems to be mainly caused by vmalloc inefficiently allocating
>> individual pages even when a higher-order page is available on the
>> freelist.
>
> I really think that problem needs to be fixed before this should be merge=
d.
>
> The easy fix may be to just have a very limited re-use of these stacks
> in generic code, rather than try to do anything fancy with multi-page
> allocations. Just a few of these allocations held in reserve (perhaps
> make the allocations percpu to avoid new locks).
>
> It won't help for a thundering herd problem where you start tons of
> new threads, but those don't tend to be short-lived ones anyway. In
> contrast, I think one common case is the "run shell scripts" that runs
> tons and tons of short-lived processes, and having a small "stack of
> stacks" would probably catch that case very nicely. Even a
> single-entry cache might be ok, but I see no reason to not make it be
> perhaps three or four stacks per CPU.
>
> Make the "thread create/exit" sequence go really fast by avoiding the
> allocation/deallocation, and hopefully catching a hot cache and TLB
> line too.

To put the numbers in perspective: we'll pay the 1.5=C2=B5s every time we
do any kind of clone(), but I think that many of the interesting cases
may be so far dominated by other costs that this is lost in the noise.
For scripts, execve() and all the dynamic linking overhead is so much
larger that no one will ever notice this:

time for i in `seq 1000`; do /bin/true; done

real    0m2.641s
user    0m0.058s
sys    0m0.107s

That's over 2ms per /bin/true invocation, so we're talking about less
than a 0.1% slowdown.  For fork() (i.e. !CLONE_VM), we'll have the
full cost of copying the mm.  And for anything with a thundering herd,
there will be lots of context switches, and just the context switches
are likely to swamp the task creation time.

On the flip side, on workloads where higher-order page allocation
requires any sort of compation, using vmalloc should be much faster.

So I'm leaning toward fewer cache entries per cpu, maybe just one.
I'm all for making it a bit faster, but I think we should weigh that
against increasing memory usage too much and thus scaring away the
embedded folks.

--Andy
