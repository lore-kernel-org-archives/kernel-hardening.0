Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Sat, 16 Apr 2016 11:00:25 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160416090025.GB30071@gmail.com>
References: <1460672954-32567-1-git-send-email-keescook@chromium.org>
 <1460672954-32567-8-git-send-email-keescook@chromium.org>
 <20160415083105.GG30715@gmail.com>
 <CAGXu5j+3zO=csJuZkYsqCwD3hgCCUfJtUwGnKJZEBmga6hbJhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+3zO=csJuZkYsqCwD3hgCCUfJtUwGnKJZEBmga6hbJhA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v5 07/21] x86, boot: Fix run_size calculation
To: Kees Cook <keescook@chromium.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Junjie Mao <eternal.n08@gmail.com>, Josh Triplett <josh@joshtriplett.org>, Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Redfearn <matt.redfearn@imgtec.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> > So can we rename it to something more expressive, such as kernel_total_size or 
> > so?
> 
> You got it. Thanks again for digging through all this!

You are welcome! A couple of logistical suggestions:

Could you please split up the series a bit and limit the next series to say no 
more than around 5 patches? (Can be a little bit more when justified to finish up 
a particular line of thought) That way I can apply them in reviewable groups, 
without having to reject the whole series because some patch deep into the series 
has some problem.

I'd suggest starting with absolutely critical fixes (if any!) as-is, to make 
backporting easier. By the looks of it I don't think there's any such patch in 
this series, but just in case there are any, they can be at the front.

Then come the various cleanup patches and non-critical fixes - everything that is 
not supposed to change the behavior of the kernel. I'd suggest doing them in 
roughly this order:

 - file renames first - so that any later revert in a smaller patch does not have
   to go through a rename barrier.

 - then .o-invariant trivial cleanups, the fixing, harmonization (and creation ;-)
   of comments.

 - then come more involved cleanups like moving logic from build time to boot
   time, stricter bounds checks, non-essential fixes, etc.

It might be useful if you declared at this stage that you are mostly done with the 
preparatory work and that the code base is ready for heavier changes, so that 
people (and me) can review the whole source for anything missing. Often a car 
needs a good power wash before we can tell what body work is needed.

... and once we are happy and proud about the code base, then come the more 
exciting things: more fundamental changes, and new features - on top of a squeaky 
clean code base.

This all can happen pretty quickly, as long as the ordering is proper.

Thanks,

	Ingo
