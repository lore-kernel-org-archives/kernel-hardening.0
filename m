MIME-Version: 1.0
References: <20190220180934.GA46255@beast> <20190221173307.GB7019@linux.intel.com>
In-Reply-To: <20190221173307.GB7019@linux.intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Feb 2019 09:37:52 -0800
Message-ID: <CAGXu5j+rfR4T2Mo75bfp7L9RAPWQ7xchQTfW3JpDbHRMOocjbQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86/asm: Pin sensitive CR4 bits
Content-Type: text/plain; charset="UTF-8"
To: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jann Horn <jannh@google.com>, Dominik Brodowski <linux@dominikbrodowski.net>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, X86 ML <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 9:33 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
> On Wed, Feb 20, 2019 at 10:09:34AM -0800, Kees Cook wrote:
> > +     if (WARN_ONCE((val & cr4_pin) != cr4_pin, "cr4 bypass attempt?!\n"))
>
> Printing what bits diverged would be helpful in the unlikely event that the
> WARN_ONCE triggers.  "cr4 bypass attempt" is probably only meaningful to
> people that are already familiar with the code, e.g.:
>
>         if (WARN_ONCE((val & cr4_pin) != cr4_pin,
>             "Attempt to unpin cr4 bits: %lx, cr4 bypass attack?!", ~val & cr4_pin))

Ah yeah, I like it. I'll send a v3. Thanks!

-- 
Kees Cook
