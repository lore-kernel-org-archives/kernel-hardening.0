Date: Wed, 27 Feb 2019 09:20:32 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 0/3] x86/asm: More pinning
Message-ID: <20190227082032.GA22049@kroah.com>
References: <20190226233647.28547-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226233647.28547-1-keescook@chromium.org>
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Sean Christopherson <sean.j.christopherson@intel.com>, Dominik Brodowski <linux@dominikbrodowski.net>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 26, 2019 at 03:36:44PM -0800, Kees Cook wrote:
> This adds CR0 pinning (for WP), and cleans up the CR4 pin to avoid
> taking an exception from WARN before fixing up the desired pin.
> Additionally adds lkdtm test (which depends on the CR4 patch, otherwise
> I'd send it via Greg's tree).

No objection from me to route around me, please do!

greg k-h
