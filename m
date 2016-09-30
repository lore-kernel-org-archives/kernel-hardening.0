Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 30 Sep 2016 17:41:48 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160930164147.GD1729@remoulade>
References: <20160929213257.30505-1-labbott@redhat.com>
 <20160929213257.30505-4-labbott@redhat.com>
 <20160930155814.GA1729@remoulade>
 <CAGXu5jJHohnRBxQAY-S7_iccgjc6xNUdBGb67b1-cOATyO-q0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJHohnRBxQAY-S7_iccgjc6xNUdBGb67b1-cOATyO-q0A@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] arm64: dump: Add checking for writable and
 exectuable pages
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <labbott@redhat.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, David Brown <david.brown@linaro.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Sep 30, 2016 at 09:25:45AM -0700, Kees Cook wrote:
> On Fri, Sep 30, 2016 at 8:58 AM, Mark Rutland <mark.rutland@arm.com> wrote:

> > Would it be worth verifying that all kernel mappings are UXN, too?
> >
> > ARMv8 allows execute-only mappings, and a !UXN mapping could result in an info
> > leak (e.g. pointers in MOVZ+MOVK sequences), or potential asynchronous issues
> > (e.g. user instruction fetches accessing read-destructive device registers).
> > All kernel mappings *should* be UXN.
> 
> I love this idea, but based on what came up with hardened usercopy,
> there are a lot of readers of kernel memory still. I think the
> expectations around UXN need to be clarified so we can reason about
> things like perf that want to read the kernel text.

The UXN (User eXecute Never) bit only controls whether userspace can execute a
page, not whether the kernel can read it. The RW permissions come from the AP
bits regardless.

We already try to ensure that all kernel memory is UXN by construction, so this
would just be a sanity check, as with the rest of the W^X checks.

The MOVZ+MOVK case above is where a sequence of 16-bit immediate MOVs are used
to encode a pointer. If a kernel mapping lacked UXN, userspace could execute it
(unprivileged), and extract the pointer generated into a GPR.

Having kernel exec-only memory is a different story entirely, though I agree
it's something to look into.

Thanks,
Mark
