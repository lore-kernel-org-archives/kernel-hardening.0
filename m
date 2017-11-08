Date: Wed, 8 Nov 2017 14:24:18 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171108032418.GB18478@eros>
References: <1509945567-11801-1-git-send-email-me@tobin.cc>
 <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3] scripts: add leaking_addresses.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 06, 2017 at 09:27:09AM -0800, Linus Torvalds wrote:
> On Sun, Nov 5, 2017 at 9:19 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > Currently we are leaking addresses from the kernel to user space. This
> > script is an attempt to find some of those leakages. Script parses
> > `dmesg` output and /proc and /sys files for hex strings that look like
> > kernel addresses.
> 
> Lovely. This is great. It shows just how much totally pointless stuff
> we leak, and to normal users that really shouldn't need it.
> 
> I had planned to wait for 4.15 to look at the printk hashing stuff
> etc, but this part I think I could/should merge early just because I
> think a lot of kernel developers will go "Why the f*ck would we expose
> that kernel address there?"

If we assume kptr_restrict is totally broken. Running this (with
kptr_restrict==0 and outputting a summary) hints that plugging all these
leaks is not an insurmountable problem. Perhaps we do not need to hash
%p by default? If we add %pX (or what ever) that hashes the address then
using the script to find the problems we can migrate to %pX as needed.

This approach relies on a concrete concensus (do we have those ;) as to
how and when we should print pointers. I just replied to you on that
topic in another thread. This raises the issue that this hashing
discussion is crazy fragmented and hard for people to follow (CC lists
are different on a few of the threads also), is it correct protocol to
patch Documentation with the concensus we have so far?

---
 Documentation/leaking_addresses.rst | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/leaking_addresses.rst

diff --git a/Documentation/leaking_addresses.rst b/Documentation/leaking_addresses.rst
new file mode 100644
index 000000000000..737a1b76b3f7
--- /dev/null
+++ b/Documentation/leaking_addresses.rst
@@ -0,0 +1,33 @@
+Leaking Kernel Addresses
+========================
+
+If we show kernel addresses to user space bad things can happen.
+
+Work in Progress
+----------------
+
+- Create a tool to scan the kernel for leaking addresses.
+  - Partially done, see scripts/leaking_addresses.pl
+- Provide some sort of pointer hashing (i.e unique identifier).
+- Move away from kptr_restrict (and %pK).
+- Fix leaks on a case by case basis.
+
+WTF, just tell me how to print a pointer
+----------------------------------------
+
+Essentially you must consider _carefully_ who the needs to see the address and why.
+
+- If it is for profiling guard with perf_event_paranoid.
+- If the file is intended for root-only, then guard via file permissions.
+- If a unique identifier will suffice use hashing specifier (still to do).
+
+- If you really need the address ...    
+
+Ideas
+-----
+
+- Add a printk specifier that prints conditionally based on
+  perf_event_paranoid? 
+
+- Add seq_printf_sanitize() that only shows addresses to root (based on the
+  permissions of the process that opens the file)?  
-- 
2.7.4

thanks,
Tobin.
