Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 15 Apr 2016 08:55:59 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20160415065559.GA30715@gmail.com>
References: <1458631937-14593-1-git-send-email-bhe@redhat.com>
 <20160405015613.GA4654@x1.redhat.com>
 <CAGXu5jKtXndmfLNt1PZvL1oE5BXHDHsAcGBy=0V-nHg=6CA8HA@mail.gmail.com>
 <20160413101950.GC9482@gmail.com>
 <CAGXu5jL21Jk7tKYnVULDskOKeq-QgQM6E0z6EuzmDMp5Sa2iBA@mail.gmail.com>
 <CAGXu5jJFcT9CgKvJSJ9rDOz4D8fJRhDbxBGwOpQhUA2OyYPAzg@mail.gmail.com>
 <20160414150641.GA2599@x1.redhat.com>
 <CAGXu5jLEDekACCizQaDinLZ63oc=40VpXfwBP5thagA3pCOOOA@mail.gmail.com>
 <20160415040830.GB2631@x1.redhat.com>
 <CAGXu5j+mQ9eSObwD6rVAE7TYoj_n05nH761zpTiXMGQkH1uoTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+mQ9eSObwD6rVAE7TYoj_n05nH761zpTiXMGQkH1uoTA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 00/20] x86, boot: kaslr cleanup and 64bit kaslr support
To: Kees Cook <keescook@chromium.org>
Cc: Baoquan He <bhe@redhat.com>, Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>, Andy Lutomirski <luto@kernel.org>, lasse.collin@tukaani.org, Andrew Morton <akpm@linux-foundation.org>, Dave Young <dyoung@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> On Thu, Apr 14, 2016 at 9:08 PM, Baoquan He <bhe@redhat.com> wrote:

> >> I will split these chunks up into the correct patches and resend the series. 
> >> If you get a chance, can you double-check this?
> >
> > Yes, these changes sounds great. I checked the series you posted, and have to 
> > say you make them look much better. The change logs are perfect and great code 
> > refactoring. Just one little bit thing, here:
> >
> > [kees: rewrote changelog, refactored goto into while, limit 32-bit to 1G] in 
> > patch [PATCH v5 19/21] x86, KASLR: Add physical address randomization >4G
> >
> > In i386 KERNEL_IMAGE_SIZE is kept to be 0x20000000, namely 512M, w/o kaslr 
> > enabled. So here I guess it's a typo, should be "limit 32-bit to 1G". And what 
> > I said is wrong about upper limit yesterday, in fact i386 can put kernel in 
> > [16M, 896M), not 768M. But KERNEL_IMAGE_SIZE is good enough for i386 for now.
> 
> Ah yeah, thanks. If we do a v6, I'll update the typo. I was going to say "limit 
> 32-bit to KERNEL_IMAGE_SIZE" but it was going to line-wrap.
> :P

No need to resend, I've fixed the changelog.

Thanks,

	Ingo
