Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 28 Jul 2016 19:02:40 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160728190240.GS4541@io.lakedaemon.net>
References: <1469471141-25669-1-git-send-email-william.c.roberts@intel.com>
 <20160726030201.6775-1-jason@lakedaemon.net>
 <20160726033032.GD4541@io.lakedaemon.net>
 <CAGXu5jJo=8LYRarF8WqJg+b8Jf6ngZ_P_400HmuAk_j5-N-TcA@mail.gmail.com>
 <20160726170052.GI4541@io.lakedaemon.net>
 <CAGXu5jLT-pZc_67UeTJj-dCsRJteT2CCwaviGOKCXHnL8t-URw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLT-pZc_67UeTJj-dCsRJteT2CCwaviGOKCXHnL8t-URw@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC patch 1/6] random: Simplify API for random address requests
To: Kees Cook <keescook@chromium.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, linux-mm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ralf Baechle <ralf@linux-mips.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Nick Kralevich <nnk@google.com>, Jeffrey Vander Stoep <jeffv@google.com>, alyzyn@android.com, Daniel Cashman <dcashman@android.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 26, 2016 at 10:07:22AM -0700, Kees Cook wrote:
> On Tue, Jul 26, 2016 at 10:00 AM, Jason Cooper <jason@lakedaemon.net> wrote:
...
> > if (range == 0 || ULONG_MAX - range < start)
> >         return start;
> 
> Should it "abort" like this? I was thinking just cap the range, something like:
> 
> if (range > ULONG_MAX - start)
>     range = ULONG_MAX - start

yes, will do.

thx,

Jason.
