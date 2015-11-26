Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 26 Nov 2015 10:57:13 +0100
MIME-Version: 1.0
Message-ID: <5656D779.17137.12A1EA53@pageexec.freemail.hu>
In-reply-to: <20151126085425.GA29848@gmail.com>
References: <1448401114-24650-1-git-send-email-keescook@chromium.org>, <565595F5.32536.DB9FE75@pageexec.freemail.hu>, <20151126085425.GA29848@gmail.com>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: Re: [kernel-hardening] [PATCH 0/2] introduce post-init read-only memory
To: Ingo Molnar <mingo@kernel.org>
Cc: kernel-hardening@lists.openwall.com, Mathias Krause <minipli@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86-ml <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Michael Ellerman <mpe@ellerman.id.au>, linux-arch@vger.kernel.org, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 26 Nov 2015 at 9:54, Ingo Molnar wrote:

> * PaX Team <pageexec@freemail.hu> wrote:
> 
> > actually the kernel could silently recover from this given how the page fault 
> > handler could easily determine that the fault address fell into the 
> > data..read_only section and just silently undo the read-only property, log the 
> > event to dmesg and retry the faulting access.
> 
> So a safer method would be to decode the faulting instruction, to skip it by 
> fixing up the return RIP and to log the event. It would be mostly equivalent to 
> trying to write to ROM (which get ignored as well), so it's a recoverable (and 
> debuggable) event.

if by skipping you mean ignoring the write attempt then it's not a good idea
as it has a good chance to cause unexpected behaviour down the line.

e.g., imagine that the write was to a function pointer (even an entire ops
structure) or a boolean that controls some important feature for after-init
code. ignoring/dropping such writes could cause all kinds of logic bugs (if
not worse).

my somewhat related war story is that i once tried to constify machine_ops
(both the struct and the variable of the same name) directly and just forced
the writes in kvm/xen/etc via type casts. now i knew it was all undefined
behaviour but i didn't expect gcc to take advantage of it but it did (const
propagated the *initial* fptr values into the indirect calls by turning them
into direct calls) and which in turn prevented proper reboots for guests
(an event which obviously happens much later after init/boot to the great
puzzlement of end users and myself).

misusing __read_only and ignoring write attempts would effectively produce
the same misbehaviour as above so i strongly advise against it.

now i understand that the motivation is probably to preserve the read-only
property despite wrong use of __read_only but for this i'd suggest to simply
not make the silent recovery the default behaviour and enable it on the
kernel command line only. after all, this is expected to be a reproducible
problem and affected users can just reboot (in fact, they'd be advised to)
when it happens and get a proper report that they could then send back to lkml.

i also don't expect this to be a frequent problem as __read_only will have
to be handled carefully in every case and not just at the time of adding it
to a variable but also later during code evolution. as i suggested in the
constify plugin thread earlier, use of __read_only should be tied to compile
time checking of all uses of the affected variable to eliminate the entire
problem of problematic writes.
