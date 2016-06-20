Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 20 Jun 2016 09:07:24 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
References: <cover.1466036668.git.luto@kernel.org>
 <20160616060538.GA3923@osiris>
 <CALCETrVD6aLzvgHxTji0mm5Fzkqq_h-bxWqF1bv+7z33UrgYgA@mail.gmail.com>
 <20160617072737.GA3960@osiris>
 <CALCETrVh+w1Bj2K5QGvJwsbrGrrD_=zz1vWPC2zXUai6YB9dBA@mail.gmail.com>
 <20160620055836.GA3266@osiris>
 <CALCETrUgpbTXnvkmLNZz9sSq8fgz1g8eoGv=1Lif2dhyB6GrSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUgpbTXnvkmLNZz9sSq8fgz1g8eoGv=1Lif2dhyB6GrSg@mail.gmail.com>
Message-Id: <20160620070724.GB3266@osiris>
Subject: [kernel-hardening] Re: [PATCH 00/13] Virtually mapped stacks with guard pages (x86,
 core)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brian Gerst <brgerst@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 19, 2016 at 11:01:48PM -0700, Andy Lutomirski wrote:
> > The tmll instruction tests if any of the higher bits within the 16k
> > stackframe address are set. In this specific case that would be bits 7-15
> > (mask 0x3f80). If no bit would be set we know that only up to 128 bytes
> > would be left on the stack, and thus trigger an exception.
> >
> > This check does of course only work if a 16k stack is also 16k aligned,
> > which is always the case.
> >
> 
> Oh, interesting.  How do you handle the case of a single function that
> uses more than 128 bytes of stack?

The compiler uses the next larger value of the stackframe size that is a
power of 2 for checking. So another example with a stackframe size of 472
bytes would be the below one with a mask of 0x3e00:

0000000000392db8 <htree_inlinedir_to_tree>:
  392db8:       eb 6f f0 48 00 24       stmg    %r6,%r15,72(%r15)
  392dbe:       a7 f1 3e 00             tmll    %r15,15872
  392dc2:       b9 04 00 ef             lgr     %r14,%r15
  392dc6:       a7 84 00 01             je      392dc8 <htree_inlinedir_to_tree+0x10>
  392dca:       e3 f0 fe 28 ff 71       lay     %r15,-472(%r15)
