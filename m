Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 23 Jun 2016 20:19:11 +0000
From: Jason Cooper <jason@lakedaemon.net>
Message-ID: <20160623201911.GO9922@io.lakedaemon.net>
References: <1466556426-32664-1-git-send-email-keescook@chromium.org>
 <20160622124707.GC9922@io.lakedaemon.net>
 <CAJcbSZHbGJBhTMeAEJF4VVazYypDCO=UFJpi8y0kXKrdM=WXQA@mail.gmail.com>
 <CAGXu5jK_42d+jkPr4Ck0iL52-ignY9gq-eUZ73_YuhKJERrRxA@mail.gmail.com>
 <20160623193358.GL9922@io.lakedaemon.net>
 <CACXcFmnu5M_pQw5oTU+P6j7udj2vJSjctHDT0NY5Xc3uuf-Ovg@mail.gmail.com>
 <CAGXu5jKSk9910EiyR1q+UzPst_XeP5_Uyx7Wu3j4+Tnsha70qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKSk9910EiyR1q+UzPst_XeP5_Uyx7Wu3j4+Tnsha70qg@mail.gmail.com>
Subject: Re: [kernel-hardening] [PATCH v7 0/9] x86/mm: memory area address
 KASLR
To: kernel-hardening@lists.openwall.com
Cc: Sandy Harris <sandyinchina@gmail.com>, Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@suse.de>, Baoquan He <bhe@redhat.com>, Yinghai Lu <yinghai@kernel.org>, Juergen Gross <jgross@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Xiao Guangrong <guangrong.xiao@linux.intel.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Dave Young <dyoung@redhat.com>, Joerg Roedel <jroedel@suse.de>, Lv Zheng <lv.zheng@intel.com>, Mark Salter <msalter@redhat.com>, Dmitry Vyukov <dvyukov@google.com>, Stephen Smalley <sds@tycho.nsa.gov>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Jan Beulich <JBeulich@suse.com>, LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jun 23, 2016 at 12:59:07PM -0700, Kees Cook wrote:
> On Thu, Jun 23, 2016 at 12:45 PM, Sandy Harris <sandyinchina@gmail.com> wrote:
> > Jason Cooper <jason@lakedaemon.net> wrote:
> >
> >> Modern systems that receive a seed from the bootloader via the
> >> random-seed property (typically from the hw-rng) can mix both sources
> >> for increased resilience.
> >>
> >> Unfortunately, I'm not very familiar with the internals of x86
> >> bootstrapping.  Could GRUB be scripted to do a similar task?  How would
> >> the address and size of the seed be passed to the kernel?  command line?
> >
> > One suggestion is at:
> > http://www.av8n.com/computer/htm/secure-random.htm#sec-boot-image
> 
> Interesting! This might pose a problem for signed images, though.
> (Actually, for signed arm kernels is the DT signed too? If so, it
> would be a similar problem.)

That's the reason for userspace,random-seed = <address, size>.  Once
set, the dtb never has to change.  The bootloader loads the file to the
same address at each boot.  Userspace is responsible, as it is already,
for updating the random-seed file while up.

thx,

Jason.
